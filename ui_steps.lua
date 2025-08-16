-- Guide step accessor (post-chapter migration)
local function QS_GetStepsForGuide(name)
    local g = QuestShellGuides and QuestShellGuides[name]
    if type(g) == "table" then
        if g.steps then return g.steps end
        if g.chapters and g.chapters[1] and g.chapters[1].steps then return g.chapters[1].steps end
    end
    return {}
end

-- =========================
-- QuestShell UI — Steps (with context menu)
-- - Scroll perf (text height cache)
-- - Proper scrollbar reset when guide shrinks
-- - Preserve scroll position between step updates; reset on guide change
-- - Header shows guide meta (no chapters)
-- - Global opacity control (+/−5%) from the header menu (applies to all UI)
-- Vanilla/Turtle (Lua 5.0) safe
-- =========================

QuestShellUI = QuestShellUI or {}

-- ---------- Saved vars / opacity ----------
local function EnsureDB()
    QuestShellDB = QuestShellDB or {}
    QuestShellDB.ui = QuestShellDB.ui or {}
    if QuestShellDB.ui.listX == nil then QuestShellDB.ui.listX = 560 end
    if QuestShellDB.ui.listY == nil then QuestShellDB.ui.listY = -220 end
    if QuestShellDB.ui.listW == nil then QuestShellDB.ui.listW = 360 end
    if QuestShellDB.ui.listH == nil then QuestShellDB.ui.listH = 320 end
    if QuestShellDB.ui.locked == nil then QuestShellDB.ui.locked = false end
    -- Fully opaque by default
    if QuestShellDB.ui.backdropAlpha == nil then QuestShellDB.ui.backdropAlpha = 1.0 end
end
local function PanelA()
    EnsureDB()
    local a = QuestShellDB.ui.backdropAlpha or 1.0
    if a < 0 then a = 0 elseif a > 1 then a = 1 end
    return a
end

-- ---------- Textures / constants ----------
local TEX_TALK   = "Interface\\GossipFrame\\GossipGossipIcon"
local TEX_ACCEPT = "Interface\\GossipFrame\\AvailableQuestIcon"
local TEX_TURNIN = "Interface\\GossipFrame\\ActiveQuestIcon"
local TEX_KILL   = "Interface\\Icons\\Ability_DualWield"
local TEX_LOOT   = "Interface\\Icons\\INV_Misc_Bag_08"
local TEX_OTHER  = "Interface\\Icons\\INV_Misc_Note_01"
local TEX_BULLET = "Interface\\Buttons\\UI-CheckBox-Up"
local TEX_CHECK  = "Interface\\Buttons\\UI-CheckBox-Check"

local TEX_HEARTH  = "Interface\\Icons\\INV_Misc_Rune_01"
local TEX_CLASSES = "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes"

local CLASS_COORDS = {
  WARRIOR={0.00,0.25,0.00,0.25}, MAGE={0.25,0.50,0.00,0.25}, ROGUE={0.50,0.75,0.00,0.25},
  DRUID  ={0.75,1.00,0.00,0.25}, HUNTER={0.00,0.25,0.25,0.50}, SHAMAN={0.25,0.50,0.25,0.50},
  PRIEST ={0.50,0.75,0.25,0.50}, WARLOCK={0.75,1.00,0.25,0.50}, PALADIN={0.00,0.25,0.50,0.75},
}
local function SetClassIcon(tex)
    if not tex then return end
    tex:SetTexture(TEX_CLASSES)
    local _, class = UnitClass("player")
    local c = CLASS_COORDS[class or ""]
    if c then tex:SetTexCoord(c[1],c[2],c[3],c[4]) else tex:SetTexCoord(0,1,0,1) end
end

-- ---------- Layout ----------
local GUTTER_BULLET_W = 12
local GUTTER_GAP       = 4
local ICON_W           = 12
local ROW_VGAP         = 2
local CHECKBOX_W       = 16

local STEP_GAP         = 4
local ZEBRA_ODD_ALPHA  = 0.1
local ZEBRA_EVEN_ALPHA = 0.1
local SELECT_ALPHA     = 0.3

local TEXT_X = GUTTER_BULLET_W + GUTTER_GAP + ICON_W + GUTTER_GAP

-- ---------- Locals ----------
local listFrame, header, headerTitle, headerLevelFS, headerStepFS
local scroll, scrollChild, rowPool, meterFS
local _lastSteps, _lastCurrentIndex, _lastCompletedMap
local _heightCache, _cachedWidthKey = {}, nil

-- context menu bits
local _ctxMenu, _ctxOverlay
local _ctxAnchor

-- ---------- Helpers ----------
local function ClearHeightCache() _heightCache = {} end

local function ClampAndPlace(f, x, y, fw, fh)
    if not f or not UIParent then return end
    f:ClearAllPoints(); f:SetPoint("TOPLEFT", UIParent, "TOPLEFT", x or 0, y or 0); f:Show()
    local sw, sh = UIParent:GetWidth() or 1024, UIParent:GetHeight() or 768
    local cx, cy = x or 0, y or 0
    local ww, hh = fw or (f:GetWidth() or 360), fh or (f:GetHeight() or 320)
    if cx > sw - ww then cx = sw - ww end
    if cx < 0 then cx = 0 end
    if cy > 0 then cy = 0 end
    if cy < -(sh - hh) then cy = -(sh - hh) end
    f:ClearAllPoints(); f:SetPoint("TOPLEFT", UIParent, "TOPLEFT", cx, cy)
    return cx, cy
end

local function MeasureTextHeight(text, width)
    local w = math.max(1, width or 200)
    local key = tostring(w).."|"..(text or "")
    local h = _heightCache[key]
    if h then return h end

    meterFS:ClearAllPoints()
    meterFS:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -2000, 2000)
    meterFS:SetAlpha(0)
    meterFS:Show()
    meterFS:SetWidth(w)
    meterFS:SetText(text or "")
    h = meterFS:GetHeight() or 0
    if h <= 0 then
        local _, lh = meterFS:GetFont(); if not lh or lh <= 0 then lh = 12 end
        local _, nl = string.gsub(text or "", "\n", ""); h = (nl+1)*lh
    end
    h = math.ceil(h)
    _heightCache[key] = h
    return h
end

local function _RefreshScrollBar()
    if not scroll or not scrollChild then return end
    local viewH = scroll:GetHeight() or 1
    local contentH = scrollChild:GetHeight() or 1
    local range = contentH - viewH
    if range < 0 then range = 0 end

    local sb = (getglobal and getglobal("QuestShellStepsScrollScrollBar")) or nil
    if sb and sb.SetMinMaxValues then
        sb:SetMinMaxValues(0, range)
        if range == 0 then
            sb:SetValue(0)
            if scroll.SetVerticalScroll then scroll:SetVerticalScroll(0) end
            local up = getglobal and getglobal("QuestShellStepsScrollScrollBarScrollUpButton")
            local down = getglobal and getglobal("QuestShellStepsScrollScrollBarScrollDownButton")
            if up and up.Hide then up:Hide() end
            if down and down.Hide then down:Hide() end
        else
            local up = getglobal and getglobal("QuestShellStepsScrollScrollBarScrollUpButton")
            local down = getglobal and getglobal("QuestShellStepsScrollScrollBarScrollDownButton")
            if up and up.Show then up:Show() end
            if down and down.Show then down:Show() end
            local cur = sb:GetValue() or 0
            if cur > range then
                sb:SetValue(range)
                if scroll.SetVerticalScroll then scroll:SetVerticalScroll(range) end
            end
        end
    end
end

-- ---------- Row factory ----------
local function MakeRow(index)
    local row = CreateFrame("Button", "QuestShellStepRow"..tostring(index), scrollChild)
    row:SetHeight(24)
    row:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, - (index-1)*24)
    row:SetPoint("RIGHT", scrollChild, "RIGHT", 0, 0)

    row.chk = CreateFrame("CheckButton", nil, row, "UICheckButtonTemplate")
    row.chk:SetWidth(CHECKBOX_W); row.chk:SetHeight(CHECKBOX_W)
    row.chk:SetPoint("RIGHT", row, "RIGHT", 0, 0)
    row.chk:SetScript("OnClick", function()
        if not row._index then return end
        if QS_UI_SetStepCompleted then QS_UI_SetStepCompleted(row._index, row.chk:GetChecked()) end
    end)

    row.lines = {}
    local k = 1
    while k <= 8 do
        local bullet = row:CreateTexture(nil, "ARTWORK")
        bullet:SetWidth(GUTTER_BULLET_W); bullet:SetHeight(GUTTER_BULLET_W)
        bullet:SetTexture(TEX_BULLET); bullet:Hide()

        local check = row:CreateTexture(nil, "OVERLAY")
        check:SetWidth(GUTTER_BULLET_W); check:SetHeight(GUTTER_BULLET_W)
        check:SetTexture(TEX_CHECK); check:SetPoint("CENTER", bullet, "CENTER", 0, 0); check:SetAlpha(0)

        local icon = row:CreateTexture(nil, "ARTWORK")
        icon:SetWidth(ICON_W); icon:SetHeight(ICON_W); icon:Hide()

        local fs = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        fs:SetJustifyH("LEFT"); fs:SetJustifyV("TOP"); fs:SetText(""); fs:Hide()

        row.lines[k] = { bullet=bullet, check=check, icon=icon, fs=fs }
        k = k + 1
    end

    row:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
    row:GetHighlightTexture():SetBlendMode("ADD")
    row:GetHighlightTexture():SetAlpha(0.18)

    row:SetScript("OnClick", function()
        if row._index and QuestShell and QuestShell.JumpToStep then QuestShell.JumpToStep(row._index) end
    end)

    row.bg = row:CreateTexture(nil, "BACKGROUND")
    row.bg:SetAllPoints(row)
    row.bg:SetTexture("Interface\\Buttons\\WHITE8x8")
    row.bg:SetVertexColor(1,1,1,0)

    row.sep = row:CreateTexture(nil, "ARTWORK")
    row.sep:SetTexture("Interface\\Buttons\\WHITE8x8")
    row.sep:SetHeight(1)
    row.sep:SetPoint("BOTTOMLEFT", row, "BOTTOMLEFT", TEXT_X, 0)
    row.sep:SetPoint("BOTTOMRIGHT", row, "BOTTOMRIGHT", -CHECKBOX_W-2, 0)
    row.sep:SetVertexColor(1,1,1,0.06)

    return row
end

local function ResizeRowsToWidth()
    if not scrollChild then return end
    local w = scrollChild:GetWidth() or 322
    local contentW = w - (CHECKBOX_W + 12)
    local textW = contentW - TEXT_X

    local newKey = tostring(textW)
    if newKey ~= _cachedWidthKey then
        ClearHeightCache()
        _cachedWidthKey = newKey
    end

    local i = 1
    while rowPool and rowPool[i] do
        local r = rowPool[i]
        if r.lines then
            local k = 1
            while r.lines[k] do
                local L = r.lines[k]
                if L and L.fs then L.fs:SetWidth(textW) end
                k = k + 1
            end
        end
        i = i + 1
    end
end

-- ---------- Header (guide meta only) ----------
local function SetHeaderFromGuide(currentIndexOverride)
    local gmeta = (QS_GuideMeta and QS_GuideMeta()) or {}
    local title = gmeta.title or "QuestShell"
    local minL, maxL = gmeta.minLevel, gmeta.maxLevel
    local levels = ""
    if minL or maxL then
        levels = "  "..tostring(minL or "?").."-"..tostring(maxL or "?")
    end
    if headerTitle then headerTitle:SetText("|cffffee00"..title.."|r") end
    if headerLevelFS then headerLevelFS:SetText(levels) end

    local steps = (QS_GuideData and QS_GuideData()) or {}
    local n = table.getn(steps or {})

    local function isEligible(i)
        local s = steps[i]
        if not s then return false end
        return (not QS_StepIsEligible) or QS_StepIsEligible(s)
    end

    local total, i = 0, 1
    while i <= n do if isEligible(i) then total = total + 1 end; i = i + 1 end

    local curIdx = tonumber(currentIndexOverride)
    if not curIdx then
        local st = QuestShellDB and QuestShellDB.guides and QuestShellDB.guides[QuestShell.activeGuide]
        curIdx = (st and st.currentStep) or 1
    end
    if curIdx < 1 then curIdx = 1 end; if curIdx > n then curIdx = n end

    local cur, j = 0, 1
    while j <= curIdx do if isEligible(j) then cur = cur + 1 end; j = j + 1 end
    if cur == 0 and total > 0 then cur = 1 end

    if headerStepFS then headerStepFS:SetText("Step "..tostring(cur).."/"..tostring(total)) end
end

-- ---------- Build visual rows ----------
local function BuildRows(step, fallbackTitle, forceComplete)
    if QS_BuildVisualRows then
        return QS_BuildVisualRows(step, fallbackTitle, forceComplete) or {}
    end
    local note = (step and (step.note or step.title)) or (fallbackTitle or "")
    return { { bullet=false, icon=nil, text=note } }
end

-- ---------- Render ----------
local function RebuildContent(steps, currentIndex, completedMap)
    local total = (steps and table.getn(steps)) or 0
    local y = 0
    local w = scrollChild:GetWidth() or 322
    local contentW = w - (CHECKBOX_W + 12)
    local textW = math.max(1, contentW - TEXT_X)

    local i, j = 1, 1
    while i <= total do
        local step = steps[i]
        local eligible = (not QS_StepIsEligible) or QS_StepIsEligible(step)
        if eligible then
            local row = rowPool and rowPool[j] or MakeRow(j)
            rowPool = rowPool or {}; rowPool[j] = row
            row._index = i

            local isCompleted = (completedMap and completedMap[i]) or false
            row.chk:SetChecked(isCompleted)

            local baseAlpha = (math.mod(i, 2) == 0) and ZEBRA_EVEN_ALPHA or ZEBRA_ODD_ALPHA
            local tint = (i == currentIndex) and SELECT_ALPHA or baseAlpha
            row.bg:SetVertexColor(1,1,1, tint)

            local lines = BuildRows(step, step and step.title or "", isCompleted)
            local cy = 0

            local k = 1
            while row.lines[k] do
                local slot = row.lines[k]; local data = lines[k]
                if data then
                    local anchorY = -cy
                    slot.bullet:ClearAllPoints()
                    slot.bullet:SetPoint("TOPLEFT", row, "TOPLEFT", 0, anchorY)
                    if data.bullet then
                        slot.bullet:Show()
                        if data.done then slot.check:SetAlpha(1); slot.check:SetVertexColor(0.20,1.00,0.20) else slot.check:SetAlpha(0) end
                    else
                        slot.bullet:Hide(); slot.check:SetAlpha(0)
                    end

                    slot.icon:ClearAllPoints()
                    slot.icon:SetPoint("TOPLEFT", row, "TOPLEFT", GUTTER_BULLET_W + GUTTER_GAP, anchorY)
                    if data.icon then
                        slot.icon:Show(); slot.icon:SetTexture(data.icon)
                    else
                        slot.icon:Hide()
                    end

                    local txt = data.text or ""
                    slot.fs:ClearAllPoints()
                    slot.fs:SetPoint("TOPLEFT", row, "TOPLEFT", TEXT_X, anchorY)
                    slot.fs:SetWidth(textW)
                    slot.fs:SetText(txt)
                    if data.done then slot.fs:SetTextColor(0.6,1.0,0.6) else slot.fs:SetTextColor(1,1,1) end
                    slot.fs:Show()

                    local h = MeasureTextHeight(txt, textW)
                    if h < ICON_W then h = ICON_W end
                    cy = cy + h + ROW_VGAP
                else
                    slot.bullet:Hide(); slot.check:SetAlpha(0)
                    slot.icon:Hide(); slot.fs:SetText(""); slot.fs:Hide()
                end
                k = k + 1
            end

            if cy > 0 then cy = cy - ROW_VGAP end
            local rowH = math.max(20, cy)
            row:SetHeight(rowH)
            row:ClearAllPoints()
            row:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, -y)
            row:SetPoint("RIGHT", scrollChild, "RIGHT", 0, 0)

            row.chk:ClearAllPoints()
            row.chk:SetPoint("TOPRIGHT", row, "TOPRIGHT", 0, - math.floor(rowH/2 - CHECKBOX_W/2))

            y = y + rowH + STEP_GAP
            row:Show()

            j = j + 1
        end
        i = i + 1
    end

    while rowPool and rowPool[j] do rowPool[j]:Hide(); j = j + 1 end

    if y < 1 then y = 1 end
    scrollChild:SetHeight(y)
    _RefreshScrollBar()
    SetHeaderFromGuide(currentIndex)
end

local function Relayout()
    if not listFrame or not _lastSteps then return end
    ResizeRowsToWidth()
    RebuildContent(_lastSteps, _lastCurrentIndex, _lastCompletedMap)
end

-- ---------- Opacity (apply + global setter) ----------
function QuestShellUI.ApplyAlpha_Steps()
    if listFrame then listFrame:SetBackdropColor(0,0,0, PanelA()) end
    if header then header:SetBackdropColor(0.12,0.12,0.12, PanelA()) end -- header uses same alpha
    if QuestShellUI.ApplyAlpha_Tracker then QuestShellUI.ApplyAlpha_Tracker() end
    if QuestShellUI.ApplyAlpha_Menu then QuestShellUI.ApplyAlpha_Menu() end
end

function QuestShellUI.SetGlobalAlpha(a)
    EnsureDB()
    if not a then return end
    if a < 0 then a = 0 end
    if a > 1 then a = 1 end
    QuestShellDB.ui.backdropAlpha = a
    QuestShellUI.ApplyAlpha_Steps()
end

-- ---------- Context menu ----------
local function _HideContextMenu()
    if _ctxOverlay then _ctxOverlay:Hide() end
    if _ctxMenu then _ctxMenu:Hide() end
end

local function _MakeMenuButton(parent, idx, text, onClick, isDim)
    local b = parent._rows and parent._rows[idx]
    if not b then
        b = CreateFrame("Button", nil, parent)
        parent._rows = parent._rows or {}
        parent._rows[idx] = b
        b.hl = b:CreateTexture(nil, "HIGHLIGHT")
        b.hl:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight"); b.hl:SetBlendMode("ADD"); b.hl:SetAlpha(0.2); b.hl:SetAllPoints(b)
        b.fs = b:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        b.fs:SetPoint("LEFT", b, "LEFT", 6, 0)
        b:SetHeight(18)
    end
    b:ClearAllPoints()
    if idx == 1 then b:SetPoint("TOPLEFT", parent, "TOPLEFT", 6, -6); b:SetPoint("RIGHT", parent, "RIGHT", -6, 0)
    else b:SetPoint("TOPLEFT", parent._rows[idx-1], "BOTTOMLEFT", 0, -2); b:SetPoint("RIGHT", parent, "RIGHT", -6, 0) end
    b.fs:SetText(text or "")
    if isDim then b.fs:SetTextColor(0.75,0.75,0.75) else b.fs:SetTextColor(1,1,1) end
    b:SetScript("OnClick", function() if onClick then onClick() end; _HideContextMenu() end)
    b:Show()
    return b
end

local function _RebuildContextMenu()
    if not _ctxMenu then return end
    local row = 1

    _MakeMenuButton(_ctxMenu, row, "Open Guides…", function()
        if QuestShellUI and QuestShellUI.ToggleMenu then QuestShellUI.ToggleMenu(_ctxAnchor or _ctxMenu) end
    end); row = row + 1

    _MakeMenuButton(_ctxMenu, row, "Show/Hide Tracker", function()
        local f = (getglobal and getglobal("QuestShellTracker")) or QuestShellTracker
        if not f and QuestShellUI and QuestShellUI.Update then QuestShellUI.Update(); f = QuestShellTracker end
        if f then if f:IsShown() then f:Hide() else f:Show() end end
    end); row = row + 1

    _MakeMenuButton(_ctxMenu, row, "Opacity +5%", function()
        local a = PanelA() + 0.05; if a > 1 then a = 1 end
        QuestShellUI.SetGlobalAlpha(a)
    end); row = row + 1

    _MakeMenuButton(_ctxMenu, row, "Opacity −5%", function()
        local a = PanelA() - 0.05; if a < 0 then a = 0 end
        QuestShellUI.SetGlobalAlpha(a)
    end); row = row + 1

    local percent = math.floor((PanelA()*100) + 0.5)
    _MakeMenuButton(_ctxMenu, row, "Current Opacity: "..percent.."%", nil, true); row = row + 1

    _MakeMenuButton(_ctxMenu, row, "Lock/Unlock Frames", function()
        EnsureDB(); QuestShellDB.ui.locked = not QuestShellDB.ui.locked
    end); row = row + 1

    _MakeMenuButton(_ctxMenu, row, "Options…", function()
        if QuestShellUI and QuestShellUI.ToggleOptions then QuestShellUI.ToggleOptions()
        elseif QS_Print then QS_Print("Options UI not found.") end
    end); row = row + 1

    _ctxMenu:SetHeight(6 + (row-1)*20 + 6)
end

local function _EnsureContextMenu()
    if _ctxMenu then return end

    _ctxOverlay = CreateFrame("Button", "QuestShellStepsMenuOverlay", UIParent)
    _ctxOverlay:SetAllPoints(UIParent)
    _ctxOverlay:SetFrameStrata("FULLSCREEN_DIALOG")
    _ctxOverlay:EnableMouse(true)
    _ctxOverlay:SetScript("OnClick", function()
        if _ctxMenu then _ctxMenu:Hide() end
        _ctxOverlay:Hide()
    end)
    _ctxOverlay:Hide()

    _ctxMenu = CreateFrame("Frame", "QuestShellStepsContext", UIParent)
    _ctxMenu:SetWidth(180); _ctxMenu:SetHeight(10)
    _ctxMenu:SetFrameStrata("FULLSCREEN_DIALOG")
    _ctxMenu:SetBackdrop({
        bgFile="Interface\\Buttons\\WHITE8x8", -- solid
        edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",
        tile=true, tileSize=16, edgeSize=12,
        insets={ left=3, right=3, top=3, bottom=3 }
    })
    _ctxMenu:SetBackdropColor(0,0,0,1.0) -- solid black
    _ctxMenu:Hide()
end

function QuestShellUI.ShowStepsMenu(anchor)
    _ctxAnchor = anchor
    _EnsureContextMenu()
    _RebuildContextMenu()
    _ctxOverlay:Show()
    _ctxMenu:ClearAllPoints()
    if anchor then _ctxMenu:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", -2, -2)
    else _ctxMenu:SetPoint("CENTER", UIParent, "CENTER", 0, 0) end
    _ctxMenu:Show()
end

-- ---------- Create frame ----------
local function CreateList()
    EnsureDB(); if listFrame then return end
    rowPool = {}

    listFrame = CreateFrame("Frame", "QuestShellSteps", UIParent)
    listFrame:SetWidth(QuestShellDB.ui.listW or 360)
    listFrame:SetHeight(QuestShellDB.ui.listH or 320)
    listFrame:SetFrameStrata("DIALOG")
    listFrame:SetBackdrop({
        bgFile="Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",
        tile=true, tileSize=16, edgeSize=16,
        insets={ left=4, right=4, top=4, bottom=4 }
    })
    listFrame:SetBackdropColor(0,0,0, PanelA())

    meterFS = listFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    meterFS:SetAlpha(0); meterFS:Show()

    listFrame:SetMovable(true); listFrame:EnableMouse(true); listFrame:SetClampedToScreen(true)
    listFrame:SetResizable(true); listFrame:SetMinResize(280,180); listFrame:SetMaxResize(700,700)
    listFrame:SetScript("OnSizeChanged", function()
        QuestShellDB.ui.listW, QuestShellDB.ui.listH = listFrame:GetWidth(), listFrame:GetHeight()
        if scrollChild then scrollChild:SetWidth(listFrame:GetWidth() - 38) end
        Relayout(); _RefreshScrollBar()
    end)

    local x = QuestShellDB.ui.listX or 560
    local y = QuestShellDB.ui.listY or -220
    x, y = ClampAndPlace(listFrame, x, y, listFrame:GetWidth(), listFrame:GetHeight())
    QuestShellDB.ui.listX, QuestShellDB.ui.listY = x, y

    header = CreateFrame("Frame", "QuestShellStepsHeader", listFrame)
    header:SetPoint("TOPLEFT", listFrame, "TOPLEFT", 4, -4)
    header:SetPoint("TOPRIGHT", listFrame, "TOPRIGHT", -4, -4)
    header:SetHeight(24)
    header:SetBackdrop({
        bgFile="Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",
        tile=true, tileSize=16, edgeSize=12,
        insets={ left=3, right=3, top=3, bottom=3 }
    })
    header:SetBackdropColor(0.12,0.12,0.12, PanelA())
    header:EnableMouse(true); header:RegisterForDrag("LeftButton","RightButton")
    header:SetFrameLevel(listFrame:GetFrameLevel()+10)
    header:SetScript("OnDragStart", function()
        EnsureDB(); if QuestShellDB.ui.locked then return end
        listFrame:StartMoving(); listFrame.isMoving = true
    end)
    header:SetScript("OnDragStop", function()
        if listFrame.isMoving then
            listFrame:StopMovingOrSizing(); listFrame.isMoving = nil
            local _,_,_,sx,sy = listFrame:GetPoint()
            sx, sy = ClampAndPlace(listFrame, sx, sy, listFrame:GetWidth(), listFrame:GetHeight())
            QuestShellDB.ui.listX, QuestShellDB.ui.listY = sx, sy
        end
    end)

    local hearth = CreateFrame("Button", "QuestShellStepsMenuBtn", header)
    hearth:SetWidth(18); hearth:SetHeight(18); hearth:SetPoint("LEFT", header, "LEFT", 6, 0)
    local htex = hearth:CreateTexture(nil, "ARTWORK"); htex:SetAllPoints(hearth); htex:SetTexture(TEX_HEARTH)
    hearth:SetScript("OnClick", function() QuestShellUI.ShowStepsMenu(hearth) end)

    local classIcon = header:CreateTexture(nil, "ARTWORK")
    classIcon:SetWidth(18); classIcon:SetHeight(18)
    classIcon:SetPoint("LEFT", hearth, "RIGHT", 6, 0)
    SetClassIcon(classIcon)

    headerTitle = header:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    headerTitle:SetPoint("LEFT", classIcon, "RIGHT", 6, 0); headerTitle:SetText("Guide")

    headerLevelFS = header:CreateFontString(nil, "OVERLAY", "GameFontDisable")
    headerLevelFS:SetPoint("LEFT", headerTitle, "RIGHT", 4, 0); headerLevelFS:SetText("")

    headerStepFS = header:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    headerStepFS:SetPoint("RIGHT", header, "RIGHT", -6, 0); headerStepFS:SetText("Step 1/1")

    scroll = CreateFrame("ScrollFrame", "QuestShellStepsScroll", listFrame, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", listFrame, "TOPLEFT", 8, - (4+24+6))
    scroll:SetPoint("BOTTOMRIGHT", listFrame, "BOTTOMRIGHT", -28, 8)

    scrollChild = CreateFrame("Frame", "QuestShellStepsScrollChild", scroll)
    scroll:SetScrollChild(scrollChild)
    scrollChild:SetHeight(1)
    scrollChild:SetWidth((QuestShellDB.ui.listW or 360) - 38)

    if scroll.EnableMouseWheel then
        scroll:EnableMouseWheel(true)
        scroll:SetScript("OnMouseWheel", function()
            local sb = getglobal and getglobal("QuestShellStepsScrollScrollBar")
            if not sb then return end
            local v = (sb:GetValue() or 0) - (arg1 or 0) * 30
            local _, max = sb:GetMinMaxValues()
            if v < 0 then v = 0 end
            if max and v > max then v = max end
            sb:SetValue(v)
            if scroll.SetVerticalScroll then scroll:SetVerticalScroll(v) end
        end)
    end

    local sGrip = CreateFrame("Button", "QuestShellStepsSize", listFrame)
    sGrip:SetWidth(16); sGrip:SetHeight(16)
    sGrip:SetPoint("BOTTOMRIGHT", listFrame, "BOTTOMRIGHT", -4, 4)
    local sTex = sGrip:CreateTexture(nil, "ARTWORK"); sTex:SetAllPoints(sGrip)
    sTex:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    sGrip:SetScript("OnMouseDown", function() listFrame:StartSizing() end)
    sGrip:SetScript("OnMouseUp", function()
        listFrame:StopMovingOrSizing()
        if scrollChild then scrollChild:SetWidth(listFrame:GetWidth() - 38) end
        Relayout(); _RefreshScrollBar()
    end)

    listFrame:Show()
    SetHeaderFromGuide(_lastCurrentIndex or 1)
end

-- ---------- Public ----------
function QuestShellUI.ToggleList()
    if not listFrame then CreateList() end
    if listFrame:IsShown() then listFrame:Hide() else listFrame:Show() end
end

function QuestShellUI.UpdateList(steps, currentIndex, completedMap)
    if not listFrame then CreateList() end

    local oldStepsRef = _lastSteps
    local sb = (getglobal and getglobal("QuestShellStepsScrollScrollBar")) or nil
    local prevScroll = 0
    if sb and sb.GetValue then prevScroll = sb:GetValue() or 0
    elseif scroll and scroll.GetVerticalScroll then prevScroll = scroll:GetVerticalScroll() or 0 end
    local guideChanged = (oldStepsRef ~= steps)

    _lastSteps, _lastCurrentIndex, _lastCompletedMap = steps, currentIndex, completedMap

    ClearHeightCache()
    RebuildContent(steps, currentIndex, completedMap)

    sb = (getglobal and getglobal("QuestShellStepsScrollScrollBar")) or nil
    local target = guideChanged and 0 or (prevScroll or 0)
    if sb and sb.GetMinMaxValues then
        local _, max = sb:GetMinMaxValues(); if not max then max = 0 end
        if target > max then target = max end
        sb:SetValue(target); if scroll and scroll.SetVerticalScroll then scroll:SetVerticalScroll(target) end
    elseif scroll and scroll.SetVerticalScroll then
        scroll:SetVerticalScroll(target or 0)
    end

    QuestShellUI.ApplyAlpha_Steps()
end

local boot = CreateFrame("Frame")
boot:RegisterEvent("VARIABLES_LOADED")
boot:SetScript("OnEvent", function() CreateList() end)

-- =========================
-- QuestShell UI — Tracker
-- Compact tracker for the current step with: header, checkbox, rows with icons.
-- Compatibility: Vanilla/Turtle (Lua 5.0)
-- =========================
-- Public:
--   QuestShellUI.Update(title, typ, body)    -- internal: called by core
--   QuestShellUI.SetFontScale(scale)         -- 0.6..1.8
-- Notes:
--   - Uses fixed slot widths for bullet/icon for reliable alignment in 1.12.
--   - No 'self' / no '#' operator; uses table.getn, etc.
-- =========================

QuestShellUI = QuestShellUI or {}

-- ------------------------- Saved vars -------------------------
local function EnsureDB()
    QuestShellDB = QuestShellDB or {}
    QuestShellDB.ui = QuestShellDB.ui or {}
    if QuestShellDB.ui.trackerX == nil then QuestShellDB.ui.trackerX = 250 end
    if QuestShellDB.ui.trackerY == nil then QuestShellDB.ui.trackerY = -140 end
    if QuestShellDB.ui.trackerW == nil then QuestShellDB.ui.trackerW = 360 end
    if QuestShellDB.ui.trackerH == nil then QuestShellDB.ui.trackerH = 160 end
    if QuestShellDB.ui.locked   == nil then QuestShellDB.ui.locked   = false end
    if QuestShellDB.ui.trackerFontScale == nil then QuestShellDB.ui.trackerFontScale = 1.0 end
end

-- ------------------------- Constants -------------------------
local TEX_TALK   = "Interface\\GossipFrame\\GossipGossipIcon"
local TEX_ACCEPT = "Interface\\GossipFrame\\AvailableQuestIcon"
local TEX_TURNIN = "Interface\\GossipFrame\\ActiveQuestIcon"
local TEX_KILL   = "Interface\\Icons\\Ability_DualWield"
local TEX_LOOT   = "Interface\\Icons\\INV_Misc_Bag_08"
local TEX_OTHER  = "Interface\\Icons\\INV_Misc_Note_01"
local TEX_BULLET = "Interface\\Buttons\\UI-CheckBox-Up"        -- empty box
local TEX_CHECK  = "Interface\\Buttons\\UI-CheckBox-Check"      -- tick (green when done)
local TEX_RUN    = "Interface\\Icons\\Ability_Rogue_Sprint"
local TEX_USE    = "Interface\\Icons\\INV_Misc_Gear_02"

local LEFT_PAD, RIGHT_PAD = 8, 10
local SLOT_W, GAP = 12, 4
local ROW_VGAP = 3

-- ------------------------- Frame state -------------------------
local tracker, header, headerStepFS, chk
local content, rowPool
local baseHeaderSize, baseRowSize = nil, nil

-- Mini Use-Item button (new)
local mini, miniIcon, miniCD, miniCountFS
local _miniLastItemId, _miniNextPoll = nil, 0

local function ContentWidth()
    return (content and content:GetWidth() or 320)
end

local function ClampAndPlace(f, x, y, fw, fh)
    if not f or not UIParent then return end
    f:ClearAllPoints()
    f:SetPoint("TOPLEFT", UIParent, "TOPLEFT", x or 0, y or 0)
    f:Show()
    local sw, sh = UIParent:GetWidth() or 1024, UIParent:GetHeight() or 768
    local cx = x or 0; local cy = y or 0
    local ww = fw or (f:GetWidth() or 360)
    local hh = fh or (f:GetHeight() or 160)
    if cx > sw - ww then cx = sw - ww end
    if cx < 0 then cx = 0 end
    if cy > 0 then cy = 0 end
    if cy < -(sh - hh) then cy = -(sh - hh) end
    f:ClearAllPoints(); f:SetPoint("TOPLEFT", UIParent, "TOPLEFT", cx, cy)
    return cx, cy
end

-- ------------------------- Row renderer -------------------------
local function EnsureRowPool() if rowPool then return end; rowPool = {} end

local function AcquireRow(i)
    EnsureRowPool()
    if rowPool[i] then return rowPool[i] end

    local r = CreateFrame("Frame", "QuestShellTrackerRow"..tostring(i), content)
    r:SetHeight(14)

    r.bullet = r:CreateTexture(nil, "ARTWORK")
    r.bullet:SetWidth(SLOT_W); r.bullet:SetHeight(SLOT_W)
    r.bullet:SetTexture(TEX_BULLET)

    r.check = r:CreateTexture(nil, "OVERLAY")
    r.check:SetWidth(SLOT_W); r.check:SetHeight(SLOT_W)
    r.check:SetTexture(TEX_CHECK)
    r.check:SetPoint("CENTER", r.bullet, "CENTER", 0, 0)

    r.icon = r:CreateTexture(nil, "ARTWORK")
    r.icon:SetWidth(SLOT_W); r.icon:SetHeight(SLOT_W)

    r.text = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    r.text:SetJustifyH("LEFT")

    rowPool[i] = r
    return r
end

local function ReleaseRows(fromIndex)
    if not rowPool then return end
    local i = fromIndex
    while rowPool[i] do rowPool[i]:Hide(); i = i + 1 end
end

local function QS_TrackerApplyFontScale()
    local scale = (QuestShellDB and QuestShellDB.ui and QuestShellDB.ui.trackerFontScale) or 1.3

    if headerStepFS then
        local f,s,fl = headerStepFS:GetFont()
        if not baseHeaderSize then baseHeaderSize = s or 12 end
        headerStepFS:SetFont(f, math.floor(baseHeaderSize * scale + 0.5), fl)
    end

    if rowPool then
        local i = 1
        while rowPool[i] do
            local fs = rowPool[i].text
            if fs then
                local f,s,fl = fs:GetFont()
                if not baseRowSize then baseRowSize = s or 12 end
                fs:SetFont(f, math.floor(baseRowSize * scale + 0.5), fl)
            end
            i = i + 1
        end
    end
end

-- Build rows for any step
local function BuildRows(step, fallbackTitle, forceComplete)
    local rows, c = {}, 0
    local stype = string.upper(step and step.type or "")

    if stype == "ACCEPT" or stype == "TURNIN" then
        local npc = step and step.npc
        local who = (type(npc) == "table" and npc.name) or (type(npc) == "string" and npc) or "the quest giver"
        c=c+1; rows[c] = { icon=TEX_TALK, text=("Talk to "..who), bullet=false }
        c=c+1; rows[c] = { icon=(stype=="TURNIN" and TEX_TURNIN or TEX_ACCEPT), text=(step and step.title) or "", bullet=false }

    elseif stype == "TRAVEL" then
        local note = (step and step.note) or "Travel to the marked location."
        local cmeta = step and step.coords or {}
        local where = ""
        if cmeta and cmeta.x and cmeta.y then
            local z = cmeta.map or ""
            where = string.format("(%.1f, %.1f %s)", cmeta.x, cmeta.y, z)
        end
        c=c+1; rows[c] = { icon=TEX_RUN, text=note, bullet=false }
        if where ~= "" then
            c=c+1; rows[c] = { icon=nil, text=where, bullet=false }
        end

    elseif stype == "USE_ITEM" then
        local nameTxt = step and (step.itemName or ("Item ID "..tostring(step.itemId or "?")))
        local tar = (step and step.npc and step.npc.name) and (" with "..step.npc.name.." selected") or ""
        local line = "Use: "..(nameTxt or "item")..tar
        c=c+1; rows[c] = { icon=TEX_USE, text=line, bullet=false }

    else
        local note = (step and step.note) or (fallbackTitle or "")
        c=c+1; rows[c] = { icon=nil, text=note, bullet=false }

        -- Build objective rows from guide, overlaying counts when possible
        local orows = QS_BuildObjectiveRows and QS_BuildObjectiveRows(step, forceComplete) or {}
        local j = 1
        while j <= table.getn(orows) do
            local R = orows[j]
            local kind = R.kind or "other"
            local icon = (kind=="kill" and TEX_KILL) or (kind=="loot" and TEX_LOOT) or TEX_OTHER
            c=c+1; rows[c] = { icon=icon, text=(R.text or ""), bullet=true, done=(R.done and true or false) }
            j = j + 1
        end
    end

    return rows
end

local function RenderRows(rows)
    local prev = nil
    local i = 1
    while rows and rows[i] do
        local data = rows[i]
        local r = AcquireRow(i)

        r:ClearAllPoints()
        r:SetPoint("TOPLEFT", prev or content, prev and "BOTTOMLEFT" or "TOPLEFT", 0, prev and -ROW_VGAP or 0)

        -- bullet slot
        r.bullet:ClearAllPoints(); r.bullet:SetPoint("LEFT", r, "LEFT", 0, 0)
        if data.bullet then
            r.bullet:Show()
            r.bullet:SetVertexColor(1, 1, 1, 1)
            if data.done then
                r.check:SetAlpha(1)
                r.check:SetVertexColor(0.20, 1.00, 0.20)
            else
                r.check:SetAlpha(0)
                r.check:SetVertexColor(1, 1, 1)
            end
        else
            r.bullet:Hide()
            r.check:SetAlpha(0)
            r.check:SetVertexColor(1, 1, 1)
        end

        -- icon slot
        local x = SLOT_W + GAP
        if data.icon then
            r.icon:Show(); r.icon:SetTexture(data.icon)
            r.icon:ClearAllPoints(); r.icon:SetPoint("LEFT", r, "LEFT", x, 0)
            x = x + SLOT_W + GAP
        else
            r.icon:Hide()
        end

        r.text:ClearAllPoints()
        r.text:SetPoint("LEFT", r, "LEFT", x, 0)
        r.text:SetWidth(ContentWidth() - x)
        r.text:SetText(data.text or "")

        if data.bullet and data.done then
            r.text:SetTextColor(0.60, 1.00, 0.60)
        else
            r.text:SetTextColor(1, 1, 1)
        end

        r:SetWidth(ContentWidth())
        r:SetHeight(r.text:GetHeight() + 2)
        r:Show()

        prev = r
        i = i + 1
    end
    ReleaseRows(i)
    QS_TrackerApplyFontScale()
end

-- ------------------------- Header -------------------------
function UpdateHeaderStep()
    local steps = (QS_GuideData and QS_GuideData()) or {}
    local n = table.getn(steps or {})

    local function isEligible(i)
        local s = steps[i]
        if not s then return false end
        return (not QS_StepIsEligible) or QS_StepIsEligible(s)
    end

    -- current = ordinal among eligible steps (skip gated)
    local curIdx = 1
    local st = QuestShellDB and QuestShellDB.guides and QuestShellDB.guides[QuestShell.activeGuide]
    if st and st.currentStep then curIdx = st.currentStep end

    local cur = 0
    local i = 1
    while i <= math.min(curIdx, n) do
        if isEligible(i) then cur = cur + 1 end
        i = i + 1
    end
    if cur == 0 and n > 0 then cur = 1 end

    headerStepFS:SetText("Step "..tostring(cur))
end

-- ------------------------- Mini Use-Item button -------------------------
local function _FindUseItemForStep(step)
    if not step then return nil, nil end
    local stype = string.upper(step.type or "")
    if stype == "USE_ITEM" and step.itemId then
        return step.itemId, (step.itemName or nil)
    end
    if stype == "COMPLETE" and step.objectives and type(step.objectives)=="table" then
        local i=1
        while step.objectives[i] do
            local o = step.objectives[i]
            if o and string.lower(o.kind or "")=="use_item" and o.itemId then
                return o.itemId, (o.label or step.itemName or nil)
            end
            i = i + 1
        end
    end
    return nil, nil
end


local function _UpdateMiniTooltip(id, name)
    if not mini or not mini:IsShown() then return end
    if not GameTooltip or not QS_FindItemInBags or not GameTooltip.SetBagItem then return end
    local b, s = QS_FindItemInBags(id)
    if not b or not s then return end

    GameTooltip:SetOwner(mini, "ANCHOR_RIGHT")
    GameTooltip:SetBagItem(b, s)  -- pfUI-safe, uses the real bag link internally
    GameTooltip:Show()
end

local function _MiniUseItemClick()
    if not _miniLastItemId or not QS_FindItemInBags then return end
    local b,s = QS_FindItemInBags(_miniLastItemId)
    if b and s and UseContainerItem then
        UseContainerItem(b, s)
    else
        if QS_Print then QS_Print("Item not found in bags.") end
    end
end

local function _MiniEnsure()
    if mini then return end
    mini = CreateFrame("Button", "QuestShellMiniUse", header)
    mini:SetWidth(24); mini:SetHeight(24)
    -- place left of the checkbox
    mini:SetPoint("RIGHT", header, "RIGHT", -28, 0)

    miniIcon = mini:CreateTexture(nil, "BACKGROUND")
    miniIcon:SetAllPoints(mini)
    miniIcon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")

    -- Cooldown overlay (if available in 1.12)
    if CreateFrame then
        local ok, cd = pcall(CreateFrame, "Cooldown", "QuestShellMiniUseCD", mini, "CooldownFrameTemplate")
        if ok and cd then
            miniCD = cd
            miniCD:SetAllPoints(mini)
        end
    end

    miniCountFS = mini:CreateFontString(nil, "OVERLAY", "NumberFontNormalSmall")
    miniCountFS:SetPoint("BOTTOMRIGHT", mini, "BOTTOMRIGHT", -1, 1)
    miniCountFS:SetText("")

    mini:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    mini:SetScript("OnClick", _MiniUseItemClick)
    mini:SetScript("OnEnter", function()
        if _miniLastItemId then _UpdateMiniTooltip(_miniLastItemId) end
    end)
    mini:SetScript("OnLeave", function()
        if GameTooltip then GameTooltip:Hide() end
    end)

    -- light polling to refresh count/cooldown
    mini:SetScript("OnUpdate", function()
        _miniNextPoll = _miniNextPoll + (arg1 or 0)
        if _miniNextPoll < 0.2 then return end
        _miniNextPoll = 0

        if not _miniLastItemId or not mini:IsShown() then return end
        if QS_CountItemInBags then
            local c = QS_CountItemInBags(_miniLastItemId) or 0
            if c > 1 then miniCountFS:SetText(tostring(c))
            else miniCountFS:SetText("") end
        end

        if QS_FindItemInBags and miniCD and CooldownFrame_SetTimer and GetContainerItemCooldown then
            local b,s = QS_FindItemInBags(_miniLastItemId)
            if b and s then
                local start, dur, enable = GetContainerItemCooldown(b, s)
                if start and dur then CooldownFrame_SetTimer(miniCD, start, dur, enable) end
            end
        end
    end)
end

local function _ShowMiniForStep(step)
    _MiniEnsure()
    local id, name = _FindUseItemForStep(step)
    if not id then
        mini:Hide()
        _miniLastItemId = nil
        return
    end

    _miniLastItemId = id

    -- set icon from GetItemInfo if available, else from bag slot texture
    local tex = nil
    if QS_FindItemInBags then
        local b,s = QS_FindItemInBags(id)
        if b and s and GetContainerItemInfo then
            do
                local t,name,count,locked,quality,readable = GetContainerItemInfo(b, s)
                tex = t
            end
        end
    end
    if not tex and GetItemInfo then
        do
            -- 1.12 returns: name, link, quality, level, reqLevel, type, subType, stackCount, equipLoc, texture, sellPrice
            local _name, _link, _quality, _ilvl, _req, _type, _sub, _stack, _equip, texture = GetItemInfo(id)
            tex = texture
        end
    end
    miniIcon:SetTexture(tex or "Interface\\Icons\\INV_Misc_QuestionMark")

    -- prime count and cooldown right away
    if QS_CountItemInBags then
        local c = QS_CountItemInBags(id) or 0
        if c > 1 then miniCountFS:SetText(tostring(c)) else miniCountFS:SetText("") end
    end
    if QS_FindItemInBags and miniCD and CooldownFrame_SetTimer and GetContainerItemCooldown then
        local b,s = QS_FindItemInBags(id)
        if b and s then
            local start, dur, enable = GetContainerItemCooldown(b, s)
            if start and dur then CooldownFrame_SetTimer(miniCD, start, dur, enable) end
        end
    end

    mini:Show()
end

-- ------------------------- Create tracker -------------------------
local function CreateTracker()
    EnsureDB(); if tracker then return end

    tracker = CreateFrame("Frame", "QuestShellTracker", UIParent)
    tracker:SetWidth(QuestShellDB.ui.trackerW or 360)
    tracker:SetHeight(QuestShellDB.ui.trackerH or 160)
    tracker:SetFrameStrata("DIALOG")
    tracker:SetBackdrop({
        bgFile="Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",
        tile=true, tileSize=16, edgeSize=16,
        insets={ left=4, right=4, top=4, bottom=4 }
    })
    tracker:SetBackdropColor(0,0,0,0.85)

    tracker:SetMovable(true); tracker:EnableMouse(true); tracker:SetClampedToScreen(true)
    tracker:SetResizable(true)
    tracker:SetMinResize(260, 120)
    tracker:SetMaxResize(700, 320)
    tracker:SetScript("OnSizeChanged", function()
        EnsureDB()
        QuestShellDB.ui.trackerW, QuestShellDB.ui.trackerH = tracker:GetWidth(), tracker:GetHeight()
        QuestShellUI.Update()
    end)

    local x = QuestShellDB.ui.trackerX or 250
    local y = QuestShellDB.ui.trackerY or -140
    x, y = ClampAndPlace(tracker, x, y, tracker:GetWidth(), tracker:GetHeight())
    QuestShellDB.ui.trackerX, QuestShellDB.ui.trackerY = x, y

    local grip = CreateFrame("Button", "QuestShellTrackerSize", tracker)
    grip:SetWidth(16); grip:SetHeight(16)
    grip:SetPoint("BOTTOMRIGHT", tracker, "BOTTOMRIGHT", -4, 4)
    local gtex = grip:CreateTexture(nil, "ARTWORK")
    gtex:SetAllPoints(grip)
    gtex:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    grip:SetScript("OnMouseDown", function() tracker:StartSizing() end)
    grip:SetScript("OnMouseUp", function()
        tracker:StopMovingOrSizing()
        QuestShellDB.ui.trackerW, QuestShellDB.ui.trackerH = tracker:GetWidth(), tracker:GetHeight()
    end)

    -- Header (drag + checkbox at right)
    header = CreateFrame("Frame", "QuestShellTrackerHeader", tracker)
    header:SetPoint("TOPLEFT", tracker, "TOPLEFT", 4, -4)
    header:SetPoint("TOPRIGHT", tracker, "TOPRIGHT", -4, -4)
    header:SetHeight(24)
    header:SetBackdrop({
        bgFile="Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",
        tile=true, tileSize=16, edgeSize=12,
        insets={ left=3, right=3, top=3, bottom=3 }
    })
    header:SetBackdropColor(0.12,0.12,0.12,0.9)
    header:EnableMouse(true)
    header:RegisterForDrag("LeftButton","RightButton")
    header:SetFrameLevel(tracker:GetFrameLevel()+10)
    header:SetScript("OnDragStart", function()
        EnsureDB()
        if QuestShellDB.ui.locked then return end
        tracker:StartMoving(); tracker.isMoving = true
    end)
    header:SetScript("OnDragStop", function()
        if tracker.isMoving then
            tracker:StopMovingOrSizing(); tracker.isMoving = nil
            local _,_,_,sx,sy = tracker:GetPoint()
            sx, sy = ClampAndPlace(tracker, sx, sy, tracker:GetWidth(), tracker:GetHeight())
            QuestShellDB.ui.trackerX, QuestShellDB.ui.trackerY = sx, sy
        end
    end)

    headerStepFS = header:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    headerStepFS:SetPoint("LEFT", header, "LEFT", 6, 0)
    headerStepFS:SetText("Step 1/1")

    chk = CreateFrame("CheckButton", "QuestShellTrackerHeaderCheck", header, "UICheckButtonTemplate")
    chk:SetWidth(16); chk:SetHeight(16)
    chk:SetPoint("RIGHT", header, "RIGHT", -6, 0)
    chk:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
    chk:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down")
    chk:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight")
    local ct = chk:CreateTexture(nil, "OVERLAY")
    ct:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
    ct:SetVertexColor(0.35, 0.75, 1.0)
    ct:SetAllPoints(chk)
    chk:SetCheckedTexture(ct)
    chk:SetScript("OnClick", function()
        local st = QuestShellDB and QuestShellDB.guides and QuestShellDB.guides[QuestShell.activeGuide]
        if not st then return end
        local cur = (st.currentStep or 1)
        if QS_UI_SetStepCompleted then QS_UI_SetStepCompleted(cur, chk:GetChecked()) end
    end)

    -- Mini use-item button lives in the header, left of the checkbox
    _MiniEnsure()
    mini:Hide()

    content = CreateFrame("Frame", "QuestShellTrackerContent", tracker)
    content:SetPoint("TOPLEFT", tracker, "TOPLEFT", LEFT_PAD, -(4+24+6))
    content:SetPoint("RIGHT", tracker, "RIGHT", -RIGHT_PAD, 0)
    content:SetHeight(1)

    tracker:Show()
    QS_TrackerApplyFontScale()
end

-- ------------------------- Public API -------------------------
function QuestShellUI.Update(title, typ, body)
    if not tracker then CreateTracker() end
    UpdateHeaderStep()

    local step = QS_CurrentStep and QS_CurrentStep() or nil

    local st   = QuestShellDB and QuestShellDB.guides and QuestShellDB.guides[QuestShell.activeGuide]
    local cur  = (st and st.currentStep) or 1
    local forceComplete = (QS_UI_IsStepCompleted and QS_UI_IsStepCompleted(cur)) and true or false

    local rows = BuildRows(step, title or "", forceComplete)
    RenderRows(rows)

    -- show/hide mini use-item icon based on step
    _ShowMiniForStep(step)

    if QS_UI_IsStepCompleted then chk:SetChecked(forceComplete) end
end

function QuestShellUI.SetFontScale(scale)
    if not scale then return end
    if scale < 0.6 then scale = 0.6 end
    if scale > 1.8 then scale = 1.8 end
    QuestShellDB = QuestShellDB or {}; QuestShellDB.ui = QuestShellDB.ui or {}
    QuestShellDB.ui.trackerFontScale = scale
    QS_TrackerApplyFontScale()
    QuestShellUI.Update()
end

-- boot
local boot = CreateFrame("Frame")
boot:RegisterEvent("VARIABLES_LOADED")
boot:SetScript("OnEvent", function() CreateTracker() end)

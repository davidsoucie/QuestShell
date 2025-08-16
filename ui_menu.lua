-- =========================
-- QuestShell UI — Guides Popup (no chapters)
-- Opaque black background (ignores global opacity).
-- Vanilla/Turtle (Lua 5.0) safe.
-- =========================

QuestShellUI = QuestShellUI or {}

-- ---------- locals ----------
local popup, overlay, scroll, child
local rowPool = {}

local function _GuideMeta(name)
    if QS_GuideMeta then return QS_GuideMeta(name) end
    local g = QuestShellGuides and QuestShellGuides[name]
    if type(g) == "table" then return g end
    return { title = tostring(name or "?"), steps = {} }
end

local function _AllGuidesOrdered()
    if QS_AllGuidesOrdered then return QS_AllGuidesOrdered() end
    local t, i = {}, 1
    for k,_ in pairs(QuestShellGuides or {}) do t[i] = k; i = i + 1 end
    table.sort(t)
    return t
end

local function _FmtTitle(meta)
    local title = (meta and meta.title) or "Guide"
    local a,b = meta and meta.minLevel, meta and meta.maxLevel
    if a or b then title = string.format("%s  %s-%s", title, tostring(a or "?"), tostring(b or "?")) end
    return title
end

local function _AcquireRow(i)
    if rowPool[i] then return rowPool[i] end
    local r = CreateFrame("Button", "QuestShellGuideRow"..tostring(i), child)
    r:SetHeight(20)

    r.bg = r:CreateTexture(nil, "BACKGROUND")
    r.bg:SetAllPoints(r)
    r.bg:SetTexture("Interface\\Buttons\\WHITE8x8")
    r.bg:SetVertexColor(1,1,1,0) -- zebra is drawn per-row

    r.hl = r:CreateTexture(nil, "HIGHLIGHT")
    r.hl:SetTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")
    r.hl:SetBlendMode("ADD")
    r.hl:SetAlpha(0.18)
    r.hl:SetAllPoints(r)

    r.check = r:CreateTexture(nil, "ARTWORK")
    r.check:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
    r.check:SetWidth(14); r.check:SetHeight(14)
    r.check:SetPoint("LEFT", r, "LEFT", 6, 0)
    r.check:Hide()

    r.text = r:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    r.text:SetPoint("LEFT", r, "LEFT", 24, 0)
    r.text:SetPoint("RIGHT", r, "RIGHT", -6, 0)
    r.text:SetJustifyH("LEFT")

    rowPool[i] = r
    return r
end

local function _ReleaseRows(fromIndex)
    local i = fromIndex
    while rowPool[i] do rowPool[i]:Hide(); i = i + 1 end
end

local function _EnsurePopup()
    if popup then return end

    overlay = CreateFrame("Button", "QuestShellGuidesOverlay", UIParent)
    overlay:SetAllPoints(UIParent)
    overlay:SetFrameStrata("FULLSCREEN_DIALOG")
    overlay:EnableMouse(true)
    overlay:SetScript("OnClick", function() popup:Hide() end)
    overlay:Hide()

    popup = CreateFrame("Frame", "QuestShellGuidesPopup", UIParent)
    popup:SetWidth(300); popup:SetHeight(280)
    popup:SetFrameStrata("FULLSCREEN_DIALOG")
    popup:SetBackdrop({
        -- OPAQUE black background
        bgFile="Interface\\Buttons\\WHITE8x8",
        edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",
        tile=true, tileSize=16, edgeSize=12,
        insets={ left=4, right=4, top=4, bottom=4 }
    })
    popup:SetBackdropColor(0,0,0,1.0) -- force solid

    local titleFS = popup:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    titleFS:SetPoint("TOPLEFT", popup, "TOPLEFT", 8, -6)
    titleFS:SetText("QuestShell – Guides")

    scroll = CreateFrame("ScrollFrame", "QuestShellGuidesScroll", popup, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", popup, "TOPLEFT", 8, -28)
    scroll:SetPoint("BOTTOMRIGHT", popup, "BOTTOMRIGHT", -28, 8)

    child = CreateFrame("Frame", "QuestShellGuidesScrollChild", scroll)
    scroll:SetScrollChild(child)
    child:SetWidth(300-8-28)
    child:SetHeight(1)

    popup:SetScript("OnShow", function() overlay:Show() end)
    popup:SetScript("OnHide", function() overlay:Hide() end)
    popup:Hide()
end

local function _RefreshList()
    if not popup then return end
    local names = _AllGuidesOrdered()
    local y, i = 0, 1
    local cur = QuestShell and QuestShell.activeGuide

    while names[i] do
        local key = names[i]
        local meta = _GuideMeta(key)
        local row = _AcquireRow(i)

        row:ClearAllPoints()
        row:SetPoint("TOPLEFT", child, "TOPLEFT", 0, -y)
        row:SetPoint("RIGHT", child, "RIGHT", 0, 0)

        row.text:SetText(_FmtTitle(meta))
        if key == cur then row.check:Show() else row.check:Hide() end

        local zebra = (math.mod(i, 2) == 0) and 0.1 or 0.1
        row.bg:SetVertexColor(1,1,1, key == cur and 0.12 or zebra)

        row:SetScript("OnClick", function()
            if QuestShell and QuestShell.LoadGuide then QuestShell.LoadGuide(key) end
            popup:Hide()
        end)

        row:Show()
        y = y + 22
        i = i + 1
    end

    _ReleaseRows(i)
    child:SetHeight(math.max(1, y))
end

function QuestShellUI.ToggleMenu(anchor)
    _EnsurePopup()
    if popup:IsShown() then
        popup:Hide()
    else
        popup:ClearAllPoints()
        if anchor then popup:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", -2, -2)
        else popup:SetPoint("CENTER", UIParent, "CENTER", 0, 0) end
        _RefreshList()
        popup:Show()
    end
end

-- keep for API symmetry, but menu ignores global alpha on purpose
function QuestShellUI.ApplyAlpha_Menu()
    if popup then popup:SetBackdropColor(0,0,0,1.0) end
end

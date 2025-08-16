-- =========================

-- QuestShell UI — Gear Menu (Guides & Chapters)
-- Modal menu listing guides on the left and chapters on the right.
-- =========================
QuestShellUI = QuestShellUI or {}

local menuFrame, guidesScroll, chScroll, importBtn, optionsBtn

-- REPLACE the whole EnsureMenu(...) with this version
local function EnsureMenu(parent)
    if menuFrame then return end
    menuFrame = CreateFrame("Frame", "QuestShellMenu", UIParent)
    menuFrame:SetWidth(430); menuFrame:SetHeight(360)
    menuFrame:SetBackdrop({
        bgFile="Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",
        tile=true, tileSize=16, edgeSize=16,
        insets={ left=6, right=6, top=6, bottom=6 }
    })
    menuFrame:SetBackdropColor(0,0,0,0.92)
    menuFrame:EnableMouse(true)
    menuFrame:SetMovable(true)
    menuFrame:RegisterForDrag("LeftButton")
    menuFrame:SetScript("OnDragStart", function() this:StartMoving() end)
    menuFrame:SetScript("OnDragStop",  function() this:StopMovingOrSizing() end)

    local title = menuFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", menuFrame, "TOPLEFT", 10, -10)
    title:SetText("|cffffff00QuestShell – Guides|r")

    local close = CreateFrame("Button", nil, menuFrame, "UIPanelButtonTemplate")
    close:SetPoint("TOPRIGHT", menuFrame, "TOPRIGHT", -10, -8)
    close:SetWidth(60); close:SetHeight(20)
    close:SetText("Close")
    close:SetScript("OnClick", function() menuFrame:Hide() end)

    local gbox = CreateFrame("Frame", nil, menuFrame)
    gbox:SetWidth(190); gbox:SetHeight(280)
    gbox:SetPoint("TOPLEFT", menuFrame, "TOPLEFT", 10, -40)
    gbox:SetBackdrop({
        bgFile="Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",
        tile=true, tileSize=16, edgeSize=16,
        insets={ left=4, right=4, top=4, bottom=4 }
    })
    gbox:SetBackdropColor(0,0,0,0.25)

    guidesScroll = CreateFrame("ScrollFrame", "QuestShellGuidesScroll", gbox, "UIPanelScrollFrameTemplate")
    guidesScroll:SetPoint("TOPLEFT", gbox, "TOPLEFT", 4, -4)
    guidesScroll:SetPoint("BOTTOMRIGHT", gbox, "BOTTOMRIGHT", -24, 4)
    local gchild = CreateFrame("Frame", "QuestShellGuidesScrollChild", guidesScroll)
    gchild:SetWidth(160); gchild:SetHeight(1)
    guidesScroll:SetScrollChild(gchild)
    gbox._child = gchild

    local cbox = CreateFrame("Frame", nil, menuFrame)
    cbox:SetWidth(190); cbox:SetHeight(280)
    cbox:SetPoint("TOPRIGHT", menuFrame, "TOPRIGHT", -10, -40)
    cbox:SetBackdrop({
        bgFile="Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile="Interface\\Tooltips\\UI-Tooltip-Border",
        tile=true, tileSize=16, edgeSize=16,
        insets={ left=4, right=4, top=4, bottom=4 }
    })
    cbox:SetBackdropColor(0,0,0,0.25)

    chScroll = CreateFrame("ScrollFrame", "QuestShellChaptersScroll", cbox, "UIPanelScrollFrameTemplate")
    chScroll:SetPoint("TOPLEFT", cbox, "TOPLEFT", 4, -4)
    chScroll:SetPoint("BOTTOMRIGHT", cbox, "BOTTOMRIGHT", -24, 4)
    local cchild = CreateFrame("Frame", "QuestShellChaptersScrollChild", chScroll)
    cchild:SetWidth(160); cchild:SetHeight(1)
    chScroll:SetScrollChild(cchild)
    cbox._child = cchild

    importBtn = CreateFrame("Button", nil, menuFrame, "UIPanelButtonTemplate")
    importBtn:SetPoint("BOTTOMLEFT", menuFrame, "BOTTOMLEFT", 10, 10)
    importBtn:SetWidth(100); importBtn:SetHeight(22)
    importBtn:SetText("Import guide")
    importBtn:SetScript("OnClick", function()
        if QuestShellUI and QuestShellUI.ShowImport then
            QuestShellUI.ShowImport()
        else
            UIErrorsFrame:AddMessage("Importer not installed.", 1,0.4,0.4, 1.0, 3)
        end
    end)

    optionsBtn = CreateFrame("Button", nil, menuFrame, "UIPanelButtonTemplate")
    optionsBtn:SetPoint("LEFT", importBtn, "RIGHT", 8, 0)
    optionsBtn:SetWidth(80); optionsBtn:SetHeight(22)
    optionsBtn:SetText("Options")
    optionsBtn:SetScript("OnClick", function()
        if QuestShellUI and QuestShellUI.ShowOptions then
            QuestShellUI.ShowOptions()
        else
            UIErrorsFrame:AddMessage("Options UI missing.", 1,0.4,0.4, 1.0, 3)
        end
    end)
end


local function RefreshChaptersForGuide(name)
    
    if not chScroll then return end
    local parent = chScroll:GetScrollChild()
    if not parent then return end

    parent:SetWidth(260)

    -- ensure rows table
    parent._rows = parent._rows or {}
    local rows = parent._rows

    -- create or reuse a single button that opens the guide
    local b = rows[1]
    if not b then
        b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
        rows[1] = b
        b:SetHeight(22)
        b:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, -4)
        b:SetPoint("RIGHT", parent, "RIGHT", 0, 0)
        b:SetScript("OnClick", function()
            if QuestShell and QuestShell.LoadGuide then QuestShell.LoadGuide(b._guide) end
            -- no chapters anymore
        end)
    end

    local g = QuestShellGuides and QuestShellGuides[name]
    local title = (g and g.title) or name or "Guide"
    local minL = (g and g.minLevel) or "?"
    local maxL = (g and g.maxLevel) or "?"

    b:SetText(title.."  "..tostring(minL).."-"..tostring(maxL))
    b._guide = name
    b:Show()

    -- hide any extra rows
    local i = 2
    while rows[i] do
        rows[i]:Hide()
        i = i + 1
    end

    parent:SetHeight(28)
end

local function RefreshGuides()
    if not guidesScroll then return end
    local parent = guidesScroll:GetScrollChild()
    local names = {}
    local k
    for k,_ in pairs(QuestShellGuides or {}) do names[table.getn(names)+1] = k end
    table.sort(names, function(a,b)
        local A = QuestShellGuides[a]; local B = QuestShellGuides[b]
        local amin = (A and A.minLevel) or 0; local bmin = (B and B.minLevel) or 0
        if amin ~= bmin then return amin < bmin end
        local amax = (A and A.maxLevel) or 0; local bmax = (B and B.maxLevel) or 0
        if amax ~= bmax then return amax < bmax end
        return a < b
    end)

    local y = -4
    local rows = parent._rows or {}
    local i = 1
    while i <= table.getn(names) do
        local b = rows[i]
        if not b then
            b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
            rows[i] = b
            b:SetHeight(20)
            b:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, y)
            b:SetPoint("RIGHT", parent, "RIGHT", 0, 0)
            b:SetText("...")
            b:SetScript("OnClick", function()
                RefreshChaptersForGuide(b._name)
            end)
        end
        local meta = QuestShellGuides[names[i]]
        local title = (meta and meta.title) or names[i]
        local minL = (meta and meta.minLevel) or "?"
        local maxL = (meta and meta.maxLevel) or "?"
        b:SetText(title.."  "..tostring(minL).."-"..tostring(maxL))
        b._name = names[i]
        b:Show()
        y = y - 22
        i = i + 1
    end
    while rows[i] do rows[i]:Hide(); i = i + 1 end
    parent._rows = rows
    parent:SetHeight(-y + 4)

    if QuestShell and QuestShell.activeGuide then
        RefreshChaptersForGuide(QuestShell.activeGuide)
    end
end

function QuestShellUI.ToggleMenu(anchor)
    EnsureMenu()
    if menuFrame:IsShown() then
        menuFrame:Hide()
    else
        if anchor then
            menuFrame:ClearAllPoints()
            menuFrame:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -6)
        end
        RefreshGuides()
        menuFrame:Show()
    end
end
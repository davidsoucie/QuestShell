-- =========================
-- QuestShell UI — Arrow
-- Minimal orientation/approx distance arrow widget (off by default)
-- Compatibility: Vanilla/Turtle (Lua 5.0)
-- =========================
-- Behavior:
--   - Only shows if QuestShellDB.ui.arrowEnabled == true (saved variable gate).
--   - If a TRAVEL step is active and the arrow is enabled, core_events primes it
--     via QuestShellUI.ArrowSet(map, x, y, title).
-- Public:
--   QuestShellUI_AttachArrowToTracker(trackerFrame) -- optional positioning
--   QuestShellUI.ArrowSet(map, x, y, title)
--   QuestShellUI.ArrowClear()
-- =========================

QuestShellUI = QuestShellUI or {}

local QSArrowTarget = nil   -- { map="", x=58.7, y=44.4, title="..." }
local arrowFrame, arrowDirFS, arrowDistFS
local arrowUpdateAccum = 0

local function ArrowEnabled()
    return (QuestShellDB and QuestShellDB.ui and QuestShellDB.ui.arrowEnabled) == true
end

local function EnsureFrame(parent)
    if arrowFrame then return end
    parent = parent or UIParent

    arrowFrame = CreateFrame("Frame", "QuestShellArrow", parent)
    arrowFrame:SetWidth(140); arrowFrame:SetHeight(18)
    arrowFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 200) -- detached; not on tracker
    arrowFrame:Hide()

    arrowDirFS  = arrowFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    arrowDirFS:SetPoint("LEFT", arrowFrame, "LEFT", 0, 0)
    arrowDirFS:SetText("")

    arrowDistFS = arrowFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    arrowDistFS:SetPoint("LEFT", arrowDirFS, "RIGHT", 6, 0)
    arrowDistFS:SetText("")

    arrowFrame:SetScript("OnUpdate", function()
        arrowUpdateAccum = arrowUpdateAccum + (arg1 or 0)
        if arrowUpdateAccum < 0.2 then return end
        arrowUpdateAccum = 0

        if not ArrowEnabled() or not QSArrowTarget then
            arrowFrame:Hide()
            return
        end

        local playerZone = GetRealZoneText() or GetZoneText() or ""
        if QSArrowTarget.map ~= "" and string.lower(QSArrowTarget.map) ~= string.lower(playerZone) then
            arrowDirFS:SetText("|cffff5555"..QSArrowTarget.map.."|r")
            arrowDistFS:SetText("other zone")
            return
        end

        SetMapToCurrentZone()
        local px, py = GetPlayerMapPosition("player")
        if not px or not py or (px == 0 and py == 0) then
            arrowDirFS:SetText("—")
            arrowDistFS:SetText("no pos")
            return
        end

        local tx = (QSArrowTarget.x or 0) / 100.0
        local ty = (QSArrowTarget.y or 0) / 100.0
        local dx = tx - px
        local dy = ty - py

        local angle = math.atan2(dy, dx)
        local facing = (GetPlayerFacing and GetPlayerFacing()) or 0
        local rel = angle - facing
        local pi = math.pi
        while rel < -pi do rel = rel + 2*pi end
        while rel >  pi do rel = rel - 2*pi end

        -- Lua 5.0 safe modulo
        local sector = math.floor((rel + pi/8) / (pi/4))
        local m = math.mod(sector, 8); if m < 0 then m = m + 8 end
        local idx = m + 1
        local dirs = {"N","NE","E","SE","S","SW","W","NW"}
        arrowDirFS:SetText(dirs[idx])

        local dist = math.sqrt(dx*dx + dy*dy) * 100.0
        arrowDistFS:SetText(string.format("~%.1f", dist))
        arrowFrame:Show()
    end)
end

-- Backward-compat attach (respected but still hidden unless enabled)
function QuestShellUI_AttachArrowToTracker(trackerFrame)
    EnsureFrame(trackerFrame or UIParent)
    arrowFrame:ClearAllPoints()
    arrowFrame:SetPoint("BOTTOMLEFT", trackerFrame or UIParent, "BOTTOMLEFT", 8, 8)
end

-- Public API (no-op when disabled)
function QuestShellUI.ArrowSet(map, x, y, title)
    if not ArrowEnabled() then return end
    EnsureFrame()
    QSArrowTarget = { map = map or "", x = x, y = y, title = title or "" }
    if arrowFrame then arrowFrame:Show() end
end

function QuestShellUI.ArrowClear()
    QSArrowTarget = nil
    if arrowFrame then arrowFrame:Hide() end
end

-- Ensure it's hidden on load unless explicitly enabled
local boot = CreateFrame("Frame")
boot:RegisterEvent("VARIABLES_LOADED")
boot:SetScript("OnEvent", function()
    QuestShellDB = QuestShellDB or {}; QuestShellDB.ui = QuestShellDB.ui or {}
    if QuestShellDB.ui.arrowEnabled ~= true then
        QuestShellDB.ui.arrowEnabled = false
        QuestShellUI.ArrowClear()
    end
end)

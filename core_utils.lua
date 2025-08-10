-- =========================
-- QuestShell core_utils.lua
-- Utils, DB, logging, quest-log helpers
-- =========================

QuestShell = QuestShell or {}
-- default guide on startup
if QuestShell.activeGuide == nil then QuestShell.activeGuide = "Test" end
if QuestShell.debug == nil then QuestShell.debug = true end

function QS_Print(m) if DEFAULT_CHAT_FRAME then DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[QuestShell]|r "..tostring(m)) end end
function QS_Warn(m)  if DEFAULT_CHAT_FRAME then DEFAULT_CHAT_FRAME:AddMessage("|cffff8800[QuestShell]|r "..tostring(m)) end end
function QS_D(m)     if QuestShell.debug then QS_Print(m) end end

-- DB shape supports chapters:
-- QuestShellDB.guides[guideName] = {
--   currentChapter = 1,
--   currentStep    = 1,
--   completedByChapter = { [chapterIndex] = { stepIdx, stepIdx, ... } }
-- }
function QS_EnsureDB()
    if not QuestShellDB then QuestShellDB = { guides = {}, ui = {} } end
    if not QuestShellDB.guides then QuestShellDB.guides = {} end
    if not QuestShellDB.ui then QuestShellDB.ui = {} end

    if not QuestShellDB.guides[QuestShell.activeGuide] then
        QuestShellDB.guides[QuestShell.activeGuide] = {
            currentChapter = 1,
            currentStep    = 1,
            completedByChapter = {},
        }
    else
        -- migrate old shape (pre-chapters)
        local st = QuestShellDB.guides[QuestShell.activeGuide]
        if not st.currentChapter then st.currentChapter = 1 end
        if st.completedSteps and not st.completedByChapter then
            st.completedByChapter = {}
            st.completedByChapter[1] = st.completedSteps
            st.completedSteps = nil
        end
        if not st.currentStep then st.currentStep = 1 end
    end
end

-- --- Bag / Item helpers (Lua 5.0 safe) --------------------
local function QS__ItemIdFromLink(link)
    if not link then return nil end
    local _,_,id = string.find(link, "item:(%d+)")
    if id then return tonumber(id) end
    return nil
end

-- Count total copies of itemId in all bags
function QS_CountItemInBags(itemId)
    if not itemId then return 0 end
    local total = 0
    local bag = 0
    while bag <= 4 do
        local slots = GetContainerNumSlots(bag) or 0
        local s = 1
        while s <= slots do
            local link = GetContainerItemLink(bag, s)
            if link then
                local id = QS__ItemIdFromLink(link)
                if id and id == itemId then
                    local _, count = GetContainerItemInfo(bag, s)
                    if count then total = total + count else total = total + 1 end
                end
            end
            s = s + 1
        end
        bag = bag + 1
    end
    return total
end

-- Find first bag/slot for itemId
function QS_FindItemInBags(itemId)
    if not itemId then return nil,nil end
    local bag = 0
    while bag <= 4 do
        local slots = GetContainerNumSlots(bag) or 0
        local s = 1
        while s <= slots do
            local link = GetContainerItemLink(bag, s)
            if link then
                local id = QS__ItemIdFromLink(link)
                if id and id == itemId then return bag, s end
            end
            s = s + 1
        end
        bag = bag + 1
    end
    return nil, nil
end

-- Quest log helpers
function QS_FindQuestLogIndexByTitle(title)
    if not title then return nil end
    local n = GetNumQuestLogEntries() or 0
    local i = 1
    while i <= n do
        local t, _, _, _, isHeader = GetQuestLogTitle(i)
        if not isHeader and t == title then return i end
        i = i + 1
    end
    return nil
end

function QS_IsQuestObjectivesCompleteByIndex(idx)
    if not idx then return false end
    local n = GetNumQuestLeaderBoards(idx) or 0
    if n == 0 then return false end
    local i = 1
    while i <= n do
        local _, _, done = GetQuestLogLeaderBoard(i, idx)
        if not done then return false end
        i = i + 1
    end
    return true
end

-- =====================================================================
-- Objective plumbing: Build stable rows from the guide, overlaying live
-- quest-log counts only when we can confidently match the quest.
-- Vanilla/Turtle Lua 5.0 safe (no '%', no '#').
-- =====================================================================

-- Try to pick the most likely quest-log entry for this step, based on
-- exact quest title + how many objective labels match.
-- Try to pick the most-likely quest-log entry for this step
local function QS__FindQuestLogIndexForStep(step)
    if not step or not step.title then return nil end
    local title = step.title
    local entries = GetNumQuestLogEntries() or 0
    local i, bestIdx, bestScore = 1, nil, -1
    while i <= entries do
        local t, _, _, isHeader = GetQuestLogTitle(i)
        if not isHeader and t == title then
            local score, n = 0, (GetNumQuestLeaderBoards(i) or 0)
            if step.objectives and type(step.objectives) == "table" then
                local j = 1
                while j <= n do
                    local txt = GetQuestLogLeaderBoard(j, i)
                    local k = 1
                    while step.objectives[k] do
                        local o = step.objectives[k]
                        local lab = o and o.label
                        if lab and txt and string.find(string.lower(txt), string.lower(lab)) then
                            score = score + 1
                        end
                        k = k + 1
                    end
                    j = j + 1
                end
            end
            if score > bestScore then bestScore = score; bestIdx = i end
        end
        i = i + 1
    end
    return bestIdx
end

-- Parse "x/y" or "x of y" — Lua 5.0 safe
local function QS__ParseCounts(s)
    if not s then return nil, nil end
    local _, _, a, b = string.find(s, "(%d+)%s*/%s*(%d+)")
    if a and b then return tonumber(a), tonumber(b) end
    _, _, a, b = string.find(s, "(%d+)%s+of%s+(%d+)")
    if a and b then return tonumber(a), tonumber(b) end
    return nil, nil
end

-- Public: build objective rows. If forceComplete==true, format as x/x and mark done.
function QS_BuildObjectiveRows(step, forceComplete)
    local rows = {}
    if not step then return rows end

    local idx = QS__FindQuestLogIndexForStep(step)

    -- Prefer guide-defined objectives; overlay counts from log when we can match.
    if step.objectives and type(step.objectives) == "table" and table.getn(step.objectives) > 0 then
        local k = 1
        while step.objectives[k] do
            local O = step.objectives[k] or {}
            local label  = O.label or ""
            local target = O.target or 0
            local cur, done = 0, false

            if idx then
                local n = GetNumQuestLeaderBoards(idx) or 0
                local j = 1
                while j <= n do
                    local txt, _, qdone = GetQuestLogLeaderBoard(j, idx)
                    if txt and label ~= "" and string.find(string.lower(txt), string.lower(label)) then
                        local c, t = QS__ParseCounts(txt)
                        if c then cur = c end
                        if t then target = t end
                        if qdone then done = true end
                        break
                    end
                    j = j + 1
                end
            end

            if forceComplete and target and target > 0 then
                cur, done = target, true
            end

            local out
            if label ~= "" and target and target > 0 then
                out = label..": "..tostring(cur or 0).."/"..tostring(target)
            else
                out = (label ~= "" and label) or (O.text or "")
            end

            rows[table.getn(rows)+1] = {
                text   = out,
                done   = done,
                kind   = O.kind or "other",
                cur    = cur,
                target = target,
                label  = label
            }
            k = k + 1
        end
        return rows
    end

    -- Fallback: no guide objectives → mirror quest log (old behavior).
    if idx then
        local n = GetNumQuestLeaderBoards(idx) or 0
        local j = 1
        while j <= n do
            local txt, _, qdone = GetQuestLogLeaderBoard(j, idx)
            local out, done = txt or "", (qdone and true or false)
            if forceComplete then
                local c, t = QS__ParseCounts(txt)
                if t then
                    -- rewrite "x/y" → "t/t"
                    out = string.gsub(txt, "(%d+)%s*/%s*(%d+)", tostring(t).."/"..t, 1)
                    done = true
                else
                    done = true
                end
            end
            rows[table.getn(rows)+1] = { text = out, done = done, kind = "other", cur = nil, target = nil, label = nil }
            j = j + 1
        end
    end
    return rows
end

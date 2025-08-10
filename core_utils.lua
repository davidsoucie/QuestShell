-- =========================
-- QuestShell core_utils.lua
-- Utils, DB, logging, quest-log helpers
-- (Lua 5.0 / Turtle safe; no '#' and no 'self')
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
-- Objective plumbing
--  * Fix: match labels against quest-log subjects by equality (not substring).
--  * We normalize strings first (lowercase, strip counts/punctuation/keywords).
-- =====================================================================

-- Normalize helper (Lua 5.0 safe)
local function QS__trim(s)
    if not s then return "" end
    s = string.gsub(s, "^%s+", "")
    s = string.gsub(s, "%s+$", "")
    return s
end

-- Extract the "subject" part from a quest-log objective line.
-- Examples:
--   "Young Thistle Boar slain: 1/4" -> "young thistle boar"
--   "Crawler Legs: 0/4"             -> "crawler legs"
local function QS__ObjectiveSubject(txt)
    if not txt then return "" end
    local s = string.lower(txt)

    -- drop any "x/y" or "x of y"
    s = string.gsub(s, "%d+%s*/%s*%d+", "")
    s = string.gsub(s, "%d+%s+of%s+%d+", "")
    -- cut off after a colon if present (common pattern "Thing: x/y")
    local a, b = string.find(s, ":")
    if a then s = string.sub(s, 1, a - 1) end
    -- strip trailing keywords like "slain"
    s = string.gsub(s, "%s+slain%s*$", "")
    -- collapse whitespace
    s = string.gsub(s, "%s+", " ")
    return QS__trim(s)
end

-- Normalize a guide label to compare with quest-log subject
local function QS__NormLabel(lbl)
    if not lbl then return "" end
    local s = string.lower(lbl)
    s = string.gsub(s, "%s+slain%s*$", "")
    s = string.gsub(s, "%s+", " ")
    return QS__trim(s)
end

-- Optional questID helpers (use if server exposes them)
local function QS__LogQuestID(logIndex)
    if GetQuestLogQuestID then return GetQuestLogQuestID(logIndex) end
    if C_QuestLog and C_QuestLog.GetQuestIDForLogIndex then
        return C_QuestLog.GetQuestIDForLogIndex(logIndex)
    end
    return nil
end

-- Try to pick the most likely quest-log entry for this step, based on
-- exact quest title + how many objective subjects EQUAL the labels.
local function QS__FindQuestLogIndexForStep(step)
    if not step or not step.title then return nil end
    local title = step.title
    local entries = GetNumQuestLogEntries() or 0
    local i, bestIdx, bestScore = 1, nil, -1
    while i <= entries do
        local t, _, _, isHeader = GetQuestLogTitle(i)
        if not isHeader and t == title then
            local score = 0
            local n = GetNumQuestLeaderBoards(i) or 0
            if step.objectives and type(step.objectives) == "table" then
                local j = 1
                while j <= n do
                    local txt = GetQuestLogLeaderBoard(j, i)
                    local subj = QS__ObjectiveSubject(txt)
                    -- compare with each label (normalized equality)
                    local k = 1
                    while step.objectives[k] do
                        local o = step.objectives[k]
                        local lab = QS__NormLabel(o and (o.label or o.text))
                        if lab ~= "" and subj ~= "" and lab == subj then
                            score = score + 1
                            break
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
            local labelRaw = O.label or O.text or ""
            local label = QS__NormLabel(labelRaw)
            local target = O.target or 0
            local cur, done = 0, false

            if idx then
                local n = GetNumQuestLeaderBoards(idx) or 0
                local j = 1
                while j <= n do
                    local txt, _, qdone = GetQuestLogLeaderBoard(j, idx)
                    local subj = QS__ObjectiveSubject(txt)
                    if label ~= "" and subj ~= "" and label == subj then
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
            if labelRaw ~= "" and target and target > 0 then
                out = labelRaw..": "..tostring(cur or 0).."/"..tostring(target)
            else
                out = (labelRaw ~= "" and labelRaw) or ""
            end

            rows[table.getn(rows)+1] = {
                text   = out,
                done   = done,
                kind   = O.kind or "other",
                cur    = cur,
                target = target,
                label  = labelRaw
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
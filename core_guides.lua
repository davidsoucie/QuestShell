-- =========================
-- QuestShell core_guides.lua
-- Guide metadata/data access, chapter helpers, loader, jump/advance
-- Compatibility: Vanilla/Turtle (Lua 5.0)
-- =========================
-- Public surface:
--   QS_GuideMeta(name?)                -> {title, steps}|{title, chapters}
--   QS_GuideHasChapters(name?)         -> boolean
--   QS_ChapterCount(name?)             -> number
--   QS_GuideState()                    -> saved-state table for active guide
--   QS_CurrentChapterIndex()           -> number
--   QS_ChapterMeta(idx)                -> chapter meta for current guide
--   QS_GuideData()                     -> steps[] for current chapter
--   QS_CurrentStep()                   -> step table for current step
--   QuestShell.SetChapter(idx)         -> switches chapter, finds next uncompleted step
--   QS_AllGuidesOrdered()              -> array of guide keys sorted by level/title
--   QuestShell.LoadGuide(name)         -> set active guide, reset chapter/step
--   QS_LoadNextGuideIfAny()            -> bool; loads next ordered guide if exists
--   QuestShell.JumpToStep(idx)         -> set currentStep within chapter
-- =========================

-- Safe UI refresher (works even if QuestShellUI_UpdateAll isn't defined yet)
local function QS_UI_RefreshAll()
    if QuestShellUI_UpdateAll then
        QuestShellUI_UpdateAll()
        return
    end
    -- minimal fallback: refresh list + tracker directly
    if QuestShellUI and QuestShellUI.UpdateList then
        local steps = QS_GuideData and QS_GuideData() or {}
        local st = QS_GuideState and QS_GuideState() or {}
        local ch = QS_CurrentChapterIndex and QS_CurrentChapterIndex() or 1
        local arr = (st.completedByChapter and st.completedByChapter[ch]) or {}
        local set = {}; local i=1; while arr and arr[i] do set[arr[i]] = true; i=i+1 end
        QuestShellUI.UpdateList(steps, st.currentStep or 1, set)
    end
    if QuestShellUI and QuestShellUI.Update then
        local step = QS_CurrentStep and QS_CurrentStep() or nil
        local title = step and step.title or "QuestShell"
        local typ   = step and step.type  or ""
        QuestShellUI.Update(title, typ, "")
    end
end

-- --- Guide meta resolution ---
-- Accepts: old single-zone (array or {steps=...}) OR new campaign ({chapters=...})
function QS_GuideMeta(name)
    local key = name or QuestShell.activeGuide
    local g = QuestShellGuides and QuestShellGuides[key]
    if type(g) == "table" then
        if not g.steps and not g.chapters then
            return { title = key, steps = g } -- legacy array → synthesize
        end
        return g
    end
    return { title = key, steps = {} }
end

function QS_GuideHasChapters(name)
    local m = QS_GuideMeta(name)
    return (m.chapters and type(m.chapters) == "table")
end

function QS_ChapterCount(name)
    local m = QS_GuideMeta(name)
    if m.chapters then return table.getn(m.chapters or {}) end
    return 1
end

-- ----- Saved state accessors -----
function QS_GuideState()
    return QuestShellDB.guides[QuestShell.activeGuide]
end

function QS_CurrentChapterIndex()
    local st = QS_GuideState()
    return (st and st.currentChapter) or 1
end

-- Chapter meta (synthesizes a single chapter for legacy format)
function QS_ChapterMeta(idx)
    local m = QS_GuideMeta()
    if m.chapters then
        return m.chapters[idx]
    else
        local steps = (m.steps and m.steps) or {}
        return {
            id       = "chapter1",
            title    = (m.title or QuestShell.activeGuide),
            zone     = m.zone,
            minLevel = m.minLevel,
            maxLevel = m.maxLevel,
            steps    = steps
        }
    end
end

-- Steps for the *current* chapter
function QS_GuideData()
    local chMeta = QS_ChapterMeta(QS_CurrentChapterIndex())
    return chMeta and chMeta.steps
end

-- Current step object (within current chapter)
function QS_CurrentStep()
    local d, s = QS_GuideData(), QS_GuideState()
    if not d or not s then return nil end
    return d[s.currentStep]
end

-- Normalize st.currentStep to the first eligible & incomplete step in the current chapter
-- Normalize st.currentStep to the first eligible & incomplete step in the current chapter
function QS_NormalizeCurrentStep()
    local st = QS_GuideState and QS_GuideState() or nil
    local steps = QS_GuideData and QS_GuideData() or {}
    if not st or not steps then return end

    st.completedByChapter = st.completedByChapter or {}
    local ch = (QS_CurrentChapterIndex and QS_CurrentChapterIndex()) or 1
    local arr = st.completedByChapter[ch] or {}

    -- build a set of completed indices (your saved shape uses an array of indices)
    local done = {}
    local i = 1
    while arr and arr[i] do
        done[arr[i]] = true
        i = i + 1
    end

    local n = table.getn(steps or {})
    local cur = st.currentStep or 1
    if cur < 1 then cur = 1 end
    if cur > n then cur = n end

    local function isEligible(iidx)
        local s = steps[iidx]
        if not s then return false end
        if done[iidx] then return false end
        if QS_StepIsEligible and not QS_StepIsEligible(s) then return false end
        return true
    end

    if not isEligible(cur) then
        cur = 1
        while cur <= n and not isEligible(cur) do
            cur = cur + 1
        end
    end

    st.currentStep = cur
end


-- ----- Chapter switching -----
function QuestShell.SetChapter(idx)
    local n = QS_ChapterCount()
    if idx < 1 then idx = 1 end
    if idx > n then idx = n end
    local st = QS_GuideState()
    st.currentChapter = idx

    st.completedByChapter = st.completedByChapter or {}
    local doneSet = {}
    local arr = st.completedByChapter[idx] or {}
    local i = 1
    while i <= table.getn(arr) do doneSet[arr[i]] = true; i = i + 1 end

    local steps = QS_GuideData() or {}
    local total = table.getn(steps)
    local cur = 1
    while cur <= total and (doneSet[cur] or (QS_StepIsEligible and not QS_StepIsEligible(steps[cur]))) do
    cur = cur + 1
    end
    st.currentStep = cur

    QS_Print("Switched to chapter "..idx.."/"..n..": "..(QS_ChapterMeta(idx).title or ""))
    QS_UI_RefreshAll()
end

-- Ordered list of guide keys: level (min,max), then title
function QS_AllGuidesOrdered()
    local names = {}
    for k,_ in pairs(QuestShellGuides or {}) do names[table.getn(names)+1] = k end
    table.sort(names, function(a,b)
        local ga, gb = QS_GuideMeta(a), QS_GuideMeta(b)
        local amin, bmin = ga.minLevel or 0, gb.minLevel or 0
        if amin ~= bmin then return amin < bmin end
        local amax, bmax = ga.maxLevel or 0, gb.maxLevel or 0
        if amax ~= bmax then return amax < bmax end
        return (ga.title or a) < (gb.title or b)
    end)
    return names
end

-- Load a guide (resets to chapter 1, step 1)
function QuestShell.LoadGuide(name)
    if not (QuestShellGuides and QuestShellGuides[name]) then
        QS_Warn("Guide not found: "..tostring(name))
        return
    end

    QuestShell.activeGuide = name
    QS_EnsureDB()

    local st = QuestShellDB.guides[name]
    st.currentChapter = 1
    st.currentStep    = 1
    st.completedByChapter = st.completedByChapter or {}

    -- normalize to first eligible & incomplete step
    if QS_NormalizeCurrentStep then QS_NormalizeCurrentStep() end

    local meta = QS_GuideMeta(name)
    local lv = ""
    if meta and (meta.minLevel or meta.maxLevel) then
        lv = " ("..tostring(meta.minLevel or "?").."-"..tostring(meta.maxLevel or "?")..")"
    end
    QS_Print("Loaded guide: "..((meta and meta.title) or name)..lv)

    QS_UI_RefreshAll()
end


-- Advance to next guide in ordered list, if any
function QS_LoadNextGuideIfAny()
    local names = QS_AllGuidesOrdered()
    local cur = QuestShell.activeGuide
    local idx, n = nil, table.getn(names)
    local i = 1
    while i <= n do if names[i] == cur then idx = i break end i = i + 1 end
    if idx and idx < n then
        local nextName = names[idx+1]
        QS_Print("Guide complete. Loading next: "..nextName)
        QuestShell.LoadGuide(nextName)
        return true
    end
    return false
end

-- Jump to step within current chapter
function QuestShell.JumpToStep(idx)
    local steps = QS_GuideData(); if not steps then return end
    if idx < 1 then idx = 1 end
    local n = table.getn(steps); if idx > n then idx = n end

    local st = QS_GuideState and QS_GuideState() or {}
    st.currentStep = idx

    -- Tell next UI refresh to keep this exact selection (even if completed)
    QuestShell = QuestShell or {}
    QuestShell._skipNormalizeOnce = true

    QS_Print("Jumped to step "..tostring(idx)..": "..tostring(steps[idx].type or "?").." "..tostring(steps[idx].title or ""))
    -- Use your safe refresh wrapper
    if QS_UI_RefreshAll then QS_UI_RefreshAll() elseif QuestShellUI_UpdateAll then QuestShellUI_UpdateAll() end
end


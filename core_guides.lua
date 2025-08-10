-- =========================
-- QuestShell core_guides.lua
-- Guide metadata/data access, chapters, ordering, loader, jump/advance
-- =========================

-- Back-compat:
--  - Old single-zone guide: QuestShellGuides["Name"] = { steps = {...} } or just an array
--  - Campaign guide: QuestShellGuides["Name"] = { title=..., minLevel=..., maxLevel=..., chapters = { {title=..., steps={...}}, ... } }


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

-- meta for a guide key (returns table with .steps or .chapters)
function QS_GuideMeta(name)
    local key = name or QuestShell.activeGuide
    local g = QuestShellGuides and QuestShellGuides[key]
    if type(g) == "table" then
        -- if it's an old-format plain array of steps, synthesize metadata wrapper
        if not g.steps and not g.chapters then
            return { title = key, steps = g }
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

-- current chapter index from DB
function QS_GuideState()
    return QuestShellDB.guides[QuestShell.activeGuide]
end

function QS_CurrentChapterIndex()
    local st = QS_GuideState()
    return (st and st.currentChapter) or 1
end

-- chapter meta (synthesizes a single chapter for old-format guides)
function QS_ChapterMeta(idx)
    local m = QS_GuideMeta()
    if m.chapters then
        return m.chapters[idx]
    else
        -- single-chapter synthesized from legacy guide
        local steps = (m.steps and m.steps) or {}
        return { id="chapter1", title=(m.title or QuestShell.activeGuide), zone = m.zone, minLevel = m.minLevel, maxLevel = m.maxLevel, steps = steps }
    end
end

-- the steps table for the *current* chapter
function QS_GuideData()
    local chMeta = QS_ChapterMeta(QS_CurrentChapterIndex())
    return chMeta and chMeta.steps
end

-- current step object (within current chapter)
function QS_CurrentStep()
    local d, s = QS_GuideData(), QS_GuideState()
    if not d or not s then return nil end
    return d[s.currentStep]
end

-- change chapter, clamp, set currentStep to first not-completed
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
    while cur <= total and doneSet[cur] do cur = cur + 1 end
    st.currentStep = cur

    QS_Print("Switched to chapter "..idx.."/"..n..": "..(QS_ChapterMeta(idx).title or ""))
    QS_UI_RefreshAll()
end

-- ordered list of guide keys
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

-- load a guide (resets to chapter 1, step 1)
function QuestShell.LoadGuide(name)
    if not (QuestShellGuides and QuestShellGuides[name]) then
        QS_Warn("Guide not found: "..tostring(name)); return
    end
    QuestShell.activeGuide = name
    QS_EnsureDB()
    local st = QuestShellDB.guides[name]
    st.currentChapter = 1
    st.currentStep    = 1
    st.completedByChapter = st.completedByChapter or {}

    local meta = QS_GuideMeta(name)
    local lv = ""
    if meta.minLevel or meta.maxLevel then
        lv = " ("..tostring(meta.minLevel or "?").."-"..tostring(meta.maxLevel or "?")..")"
    end
    QS_Print("Loaded guide: "..(meta.title or name)..lv)
    QS_UI_RefreshAll()
end

-- advance to next guide in list, if any
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

-- jump to step within current chapter
function QuestShell.JumpToStep(idx)
    local d = QS_GuideData(); if not d then return end
    if idx < 1 then idx = 1 end
    local n = table.getn(d); if idx > n then idx = n end
    QS_GuideState().currentStep = idx
    QS_Print("Jumped to step "..idx..": "..(d[idx].type or "?").." "..(d[idx].title or ""))
    QS_UI_RefreshAll()
end

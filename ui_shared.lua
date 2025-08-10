-- =========================
-- QuestShell UI — shared helpers
-- =========================
QuestShellUI = QuestShellUI or {}

-- one-line short label for a step (concise: Title + gray note)
function QS_UI_ShortStepLine(step)
    if not step then return "" end
    local t = (step.title or "")
    if step.note and step.note ~= "" then
        t = t.."  |cffaaaaaa"..step.note.."|r"
    end
    return t
end

-- full body (note + coords + optional progress)
function QS_UI_FullBody(step, progressText)
    if not step then return "" end
    local lines = {}
    if step.note and step.note ~= "" then lines[table.getn(lines)+1] = "|cffaaaaaa"..step.note.."|r" end
    if step.coords and step.coords.x and step.coords.y then
        local zone = step.coords.map or ""
        lines[table.getn(lines)+1] = string.format("|cff66ccff(%.1f, %.1f %s)|r", step.coords.x, step.coords.y, zone)
    end
    if progressText and progressText ~= "" then
        lines[table.getn(lines)+1] = progressText
    end
    if table.getn(lines) == 0 then return "" end
    return table.concat(lines, "\n")
end

-- ===== unified toggle logic (tracker + steps) =====
local function QS_UI_GetState()
    if not (QuestShell and QuestShell.activeGuide and QuestShellDB and QuestShellDB.guides and QuestShellDB.guides[QuestShell.activeGuide]) then
        return nil
    end
    local st = QuestShellDB.guides[QuestShell.activeGuide]
    st.completedByChapter = st.completedByChapter or {}
    local ch = st.currentChapter or 1
    local arr = st.completedByChapter[ch] or {}
    return st, ch, arr
end

local function QS_UI_StepsNow()
    if QS_GuideData then return QS_GuideData() or {} end
    return {}
end

local function QS_UI_SetFromArray(arr)
    local set = {}
    local i = 1
    while i <= table.getn(arr) do set[arr[i]] = true; i = i + 1 end
    return set
end

function QS_UI_IsStepCompleted(index)
    local st, ch, arr = QS_UI_GetState()
    if not st then return false end
    local set = QS_UI_SetFromArray(arr)
    return set[index] and true or false
end

-- Toggle/set completion for any index, then recompute currentStep
function QS_UI_SetStepCompleted(index, completed)
    local st, ch, arr = QS_UI_GetState()
    if not st then return end

    local steps = QS_UI_StepsNow()
    local n = table.getn(steps)
    if index < 1 or index > n then return end

    local set = QS_UI_SetFromArray(arr)
    if completed then set[index] = true else set[index] = nil end

    -- write back ascending
    local out = {}
    local i = 1
    while i <= n do if set[i] then out[table.getn(out)+1] = i end i = i + 1 end
    st.completedByChapter[ch] = out

    -- first not-completed becomes current
    local cur = 1
    while cur <= n and set[cur] do cur = cur + 1 end
    st.currentStep = cur

    if QuestShellUI.UpdateList then QuestShellUI.UpdateList(steps, st.currentStep, set) end
    if QuestShellUI_UpdateAll then QuestShellUI_UpdateAll() end
end
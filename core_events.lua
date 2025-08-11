-- =========================
-- QuestShell Core — Events / Automation
-- Turtle/Vanilla (1.12) safe
-- =========================

-- Expect these from other files:
-- QS_GuideData(), QS_GuideState(), QS_CurrentStep(), QS_CurrentChapterIndex(),
-- QS_ChapterCount(), QS_LoadNextGuideIfAny(), QuestShell.SetChapter,
-- QS_UI_IsStepCompleted(i), QS_UI_SetStepCompleted(i, bool),
-- QS_Print(msg), QS_D(msg)
-- + From utils: QS_CountItemInBags, QS_FindItemInBags, QS_IsQuestObjectivesCompleteByIndex

-- ------------------------------------------------------------

-- ------------------------------------------------------------
-- Local helpers / state
-- ------------------------------------------------------------
-- Item usage tracker (for USE_ITEM behavior); survives across events and is reset on advance
local itemTrack = { itemId = nil, prevCount = nil, lastChangeTime = 0 }

local awaitingAcceptTitle = nil
local travelUpdateAccum = 0

-- Behavior hook state
local _qsArrivedForStepIdx = nil     -- remember which step we've already "arrived" at (for arrow suppression)
local _qsLastStepIdx = nil           -- last seen step index
local _qsStepState = {}              -- ephemeral per-current-step state (cleared when step changes)

local function Now() return GetTime and GetTime() or 0 end
local function Safe(t) return t or "" end
local function tlen(t) local n=0; if type(t)=="table" then for _ in pairs(t) do n=n+1 end end; return n end

-- Helpers passed to behaviors
local function _WithinTravelRadius(step)
    if not step or not step.coords or not step.coords.x or not step.coords.y then return false end
    if not UnitPosition then return false end
    local px, py = UnitPosition("player")
    if not px or not py then return false end
    local tx = (step.coords.x or 0) / 100.0
    local ty = (step.coords.y or 0) / 100.0
    local dx, dy = tx - px, ty - py
    local dist = math.sqrt(dx*dx + dy*dy) * 100.0
    local r = step.radius or 0.3
    if r < 0.05 then r = 0.05 end
    return dist <= r
end

local function _BehaviorFor(step)
    if not step or not step.type or not QS_BehaviorFor then return nil end
    return QS_BehaviorFor(step.type)
end

-- Internal: get per-step state (resets on step change)
local function _StateFor(idx)
    if not idx then return nil end
    _qsStepState[idx] = _qsStepState[idx] or {}
    return _qsStepState[idx]
end


-- --- NPC gating: only act when we're talking to the intended NPC ----------
local function QS_GetCurrentNpcName()
    if UnitName and UnitName("target") then return UnitName("target") end
    if GossipFrame and GossipFrame:IsShown() and GossipFrameNpcNameText and GossipFrameNpcNameText:GetText() then
        return GossipFrameNpcNameText:GetText()
    end
    if QuestFrame and QuestFrame:IsShown() and QuestFrameNpcNameText and QuestFrameNpcNameText:GetText() then
        return QuestFrameNpcNameText:GetText()
    end
    return nil
end

local function QS_ShouldAutoHandleNpcForStep(step)
    if not step or not step.npc or not step.npc.name then return true end
    local need = string.lower(step.npc.name or "")
    local cur  = string.lower(QS_GetCurrentNpcName() or "")
    return (cur ~= "" and need ~= "" and cur == need)
end
-- --------------------------------------------------------------------------

-- Optional questID helpers (use if server exposes them)
local function QS__LogQuestID(logIndex)
    if GetQuestLogQuestID then return GetQuestLogQuestID(logIndex) end
    if C_QuestLog and C_QuestLog.GetQuestIDForLogIndex then
        return C_QuestLog.GetQuestIDForLogIndex(logIndex)
    end
    return nil
end

-- Collect expected labels for an ACCEPT step (used to disambiguate)
local function QS__CollectExpectedLabelsForStep(stepIndex, steps)
    local labels, s = {}, (steps and steps[stepIndex]) or nil
    if not s then return labels end
    local function push(v) if v and v ~= "" then labels[table.getn(labels)+1] = v end end

    if s.acceptLabels and type(s.acceptLabels) == "table" then
        local k = 1
        while s.acceptLabels[k] do push(s.acceptLabels[k]); k = k + 1 end
        return labels
    end

    if s.objectives and type(s.objectives) == "table" then
        local k = 1
        while s.objectives[k] do local o=s.objectives[k]; push(o and (o.label or o.text)); k = k + 1 end
        return labels
    end

    local i, n, lim = stepIndex + 1, table.getn(steps or {}), stepIndex + 8
    if lim > n then lim = n end
    while i <= lim do
        local t = steps[i]
        if t and t.type == "COMPLETE" and t.title == s.title and t.objectives then
            local k = 1
            while t.objectives[k] do local o=t.objectives[k]; push(o and (o.label or o.text)); k = k + 1 end
            break
        end
        i = i + 1
    end
    return labels
end

-- Score a log quest against labels (rough disambiguator for ACCEPT)
local function QS__ScoreLogIndexAgainstLabels(logIndex, labels)
    if not logIndex or not labels or table.getn(labels) == 0 then return 0 end
    local n = GetNumQuestLeaderBoards(logIndex) or 0
    local score, j = 0, 1
    while j <= n do
        local txt = GetQuestLogLeaderBoard(j, logIndex)
        if txt then
            local low = string.lower(txt)
            local k = 1
            while labels[k] do
                local lab = string.lower(labels[k] or "")
                if lab ~= "" and string.find(low, lab, 1, true) then score = score + 1 end
                k = k + 1
            end
        end
        j = j + 1
    end
    return score
end

-- REPLACE the whole QS__BestAcceptStepForLogIndex(...) with this version
-- REPLACE: QS__BestAcceptStepForLogIndex
local function QS__BestAcceptStepForLogIndex(logIndex)
    if not logIndex then return nil end
    local title, qLevel = GetQuestLogTitle(logIndex)
    if not title then return nil end

    local steps = QS_GuideData() or {}
    local qid   = (QS__LogQuestID and QS__LogQuestID(logIndex)) or nil

    local matches = {}
    local i = 1
    while steps[i] do
        local s = steps[i]
        local ok = s and s.type == "ACCEPT" and s.title == title
        if ok and (not QS_UI_IsStepCompleted or not QS_UI_IsStepCompleted(i)) then
            if (not QS_StepIsEligible) or QS_StepIsEligible(s) then
                matches[table.getn(matches)+1] = { idx=i, lvl=s.level, qid=s.questId }
            end
        end
        i = i + 1
    end

    local count = table.getn(matches)
    if count == 0 then return nil end
    if count == 1 then return matches[1].idx end

    if qid then
        i = 1
        while matches[i] do
            if matches[i].qid and matches[i].qid == qid then return matches[i].idx end
            i = i + 1
        end
    end

    if qLevel then
        i = 1
        while matches[i] do
            if matches[i].lvl and matches[i].lvl == qLevel then return matches[i].idx end
            i = i + 1
        end
    end

    local st = QS_GuideState and QS_GuideState() or nil
    local cur = st and st.currentStep or nil
    if cur then
        i = 1
        while matches[i] do
            if matches[i].idx == cur then return cur end
            i = i + 1
        end
    end

    return matches[1].idx
end

-- REPLACE: QS__BestLogIndexForAcceptStep
local function QS__BestLogIndexForAcceptStep(stepIndex)
    local steps = QS_GuideData() or {}
    local s = steps[stepIndex]; if not s or not s.title then return nil end

    local wantTitle = s.title
    local wantLevel = s.level
    local wantID    = s.questId

    local n = GetNumQuestLogEntries() or 0
    local cands = {}
    local i = 1
    while i <= n do
        local t, qLevel, _, _, isHeader = GetQuestLogTitle(i)
        if not isHeader and t == wantTitle then
            cands[table.getn(cands)+1] = {
                idx = i,
                lvl = qLevel,
                qid = (QS__LogQuestID and QS__LogQuestID(i)) or nil
            }
        end
        i = i + 1
    end

    local count = table.getn(cands)
    if count == 0 then return nil end

    -- If the step specifies a questId, require that exact id.
    if wantID then
        i = 1
        while cands[i] do
            if cands[i].qid and cands[i].qid == wantID then return cands[i].idx end
            i = i + 1
        end
        return nil
    end

    -- If the step specifies a level, require an exact level match.
    if wantLevel then
        i = 1
        while cands[i] do
            if cands[i].lvl and cands[i].lvl == wantLevel then return cands[i].idx end
            i = i + 1
        end
        return nil
    end

    -- No disambiguators provided → first candidate by title.
    return cands[1].idx
end

local function QS__SelectAvailableIndexForAccept(step)
    if not step or step.type ~= "ACCEPT" or not step.title then return nil end
    local wantTitle  = step.title
    local wantLevel  = step.level
    local n = GetNumAvailableQuests() or 0

    local firstMatch, matchCount, chosen = nil, 0, nil
    local i = 1
    while i <= n do
        local t = GetAvailableTitle(i)
        if t == wantTitle then
            matchCount = matchCount + 1
            if not firstMatch then firstMatch = i end
            if wantLevel then
                local lvl = GetAvailableLevel(i)
                if lvl and lvl == wantLevel then
                    chosen = i; break
                end
            end
        end
        i = i + 1
    end
    if chosen then return chosen end
    if matchCount == 1 then return firstMatch end
    return nil
end

-- Find the next step index > fromIndex that is NOT completed and IS eligible.
local function QS__FindNextEligibleIncomplete(steps, completedSet, fromIndex)
    local n = table.getn(steps or {})
    local i = (fromIndex or 0) + 1
    while i <= n do
        local s = steps[i]
        local eligible = (not QS_StepIsEligible) or QS_StepIsEligible(s)
        if s and eligible and (not completedSet or not completedSet[i]) then
            return i
        end
        i = i + 1
    end
    return n + 1 -- sentinel: past the end
end

-- ------------------------------------------------------------
-- Step advancement that skips steps already checked
-- ------------------------------------------------------------
function QS_AdvanceStep(markCurrentComplete)
    -- state
    if not QuestShellDB or not QuestShellDB.guides or not QuestShell.activeGuide then return end
    local st = QuestShellDB.guides[QuestShell.activeGuide]; if not st then return end

    local chapter = (QS_CurrentChapterIndex and QS_CurrentChapterIndex()) or 1
    st.completedByChapter = st.completedByChapter or {}

    -- saved shape is an ARRAY of completed indices → build a SET for work
    local arr = st.completedByChapter[chapter] or {}
    local set = {}
    local i = 1
    while arr and arr[i] do set[arr[i]] = true; i = i + 1 end

    local steps = (QS_GuideData and QS_GuideData()) or {}
    local n = table.getn(steps or {})
    if n == 0 then return end

    local cur = st.currentStep or 1
    if QS_D then QS_D("Current Step (Cur) "..(cur or "")) end
    if cur < 1 then cur = 1 end
    if cur > n then cur = n end

    -- mark current as completed unless explicitly told not to
    if markCurrentComplete ~= false then
        set[cur] = true
    end

    -- clear transient trackers
    if QuestShellUI and QuestShellUI.ArrowClear then QuestShellUI.ArrowClear() end
    if itemTrack then itemTrack.itemId, itemTrack.prevCount, itemTrack.lastChangeTime = nil, nil, 0 end

    -- find next eligible, incomplete step AFTER current (class-gated aware)
    local nextIdx = QS__FindNextEligibleIncomplete and QS__FindNextEligibleIncomplete(steps, set, cur) or (cur + 1)
    st.currentStep = nextIdx

    -- WRITE BACK as ARRAY (ascending) — this is what UIs expect
    local out = {}
    i = 1
    while i <= n do if set[i] then out[table.getn(out)+1] = i end i = i + 1 end
    st.completedByChapter[chapter] = out

    -- refresh all UI + (re)prime arrow/behaviors through your normal path
    if QuestShellUI_UpdateAll then QuestShellUI_UpdateAll() end
end

-- ------------------------------------------------------------
-- Global UI aggregator (called by other modules and on boot)
-- Also primes arrows + item tracking when applicable.
-- ------------------------------------------------------------
local function QS__MaybePrimeTravelAndArrow()
    
    local steps = QS_GuideData and QS_GuideData() or {}
    local st    = QS_GuideState and QS_GuideState() or {}
    local idx   = st and st.currentStep or 1
    local step  = steps[idx]
    if not step then return end

    -- Step change?
    if _qsLastStepIdx ~= idx then
        _qsArrivedForStepIdx = nil
        _qsLastStepIdx = idx
        _qsStepState = {} -- clear per-step state
        local beh = _BehaviorFor(step)
        if beh and beh.onEnter then
            local state = _StateFor(idx)
            pcall(beh.onEnter, step, state)
        end
    end

    -- Ask behavior for waypoint
    local beh = _BehaviorFor(step)
    local wantArrow, c = false, nil
    local suppressOnArrive = false
    if beh and beh.waypoint then
        local wp = beh.waypoint(step) or nil
        if wp and wp.x and wp.y then
            c = wp
            suppressOnArrive = (wp.suppressAfterArrival and true or false)
            wantArrow = true
        end
    elseif step.coords and step.coords.x and step.coords.y then
        c = step.coords; wantArrow = true
    end

    -- Suppress if requested and we've already arrived on this step
    if wantArrow and suppressOnArrive and _qsArrivedForStepIdx == idx then
        wantArrow = false
    end

    if wantArrow and QuestShellUI and QuestShellUI.ArrowSet and (QuestShellDB and QuestShellDB.ui and QuestShellDB.ui.arrowEnabled ~= false) then
        QuestShellUI.ArrowSet(c.map or "", c.x, c.y, step.title or "Waypoint")
    else
        if QuestShellUI and QuestShellUI.ArrowClear then QuestShellUI.ArrowClear() end
    end

end

function QuestShellUI_UpdateAll()
    -- Skip normalization once after a manual click/jump
    local skip = QuestShell and QuestShell._skipNormalizeOnce
    if QuestShell then QuestShell._skipNormalizeOnce = nil end
    if (not skip) and QS_NormalizeCurrentStep then QS_NormalizeCurrentStep() end

    local steps = (QS_GuideData and QS_GuideData()) or {}
    local st = (QS_GuideState and QS_GuideState()) or {}
    local ch = (QS_CurrentChapterIndex and QS_CurrentChapterIndex()) or 1

    -- completed set for current chapter
    local set = {}
    local arr = (st.completedByChapter and st.completedByChapter[ch]) or {}
    local i=1; while arr and arr[i] do set[arr[i]] = true; i=i+1 end

    if QuestShellUI and QuestShellUI.UpdateList then
        QuestShellUI.UpdateList(steps, st.currentStep or 1, set)
    end

    if QuestShellUI and QuestShellUI.Update then
        local step = steps[st.currentStep or 1]
        local title = (step and step.title) or "QuestShell"
        local typ   = (step and step.type)  or ""
        QuestShellUI.Update(title, typ, "")
    end

    QS__MaybePrimeTravelAndArrow()
end

-- ------------------------------------------------------------
-- Event frame
-- ------------------------------------------------------------
local ev = CreateFrame("Frame", "QuestShellCoreEvents")
ev:RegisterEvent("GOSSIP_SHOW")
ev:RegisterEvent("QUEST_GREETING")
ev:RegisterEvent("QUEST_DETAIL")
ev:RegisterEvent("QUEST_PROGRESS")
ev:RegisterEvent("QUEST_COMPLETE")
ev:RegisterEvent("QUEST_ACCEPTED")
ev:RegisterEvent("QUEST_LOG_UPDATE")
ev:RegisterEvent("VARIABLES_LOADED")
ev:RegisterEvent("BAG_UPDATE")
ev:RegisterEvent("BAG_UPDATE_COOLDOWN")
ev:RegisterEvent("PLAYER_ENTERING_WORLD")
ev:RegisterEvent("CONFIRM_BINDER")

-- ------------------------------------------------------------
-- Helpers: TRAVEL + USE_ITEM + arrival check
-- ------------------------------------------------------------
local function QS__CompleteCurrentStep()
    if QS_AdvanceStep then QS_AdvanceStep() end
end

local function _WithinTravelRadius(step)
    if not step or not step.coords or not step.coords.x or not step.coords.y then return false end

    -- Target coords normalized to 0..1
    local tx = (step.coords.x or 0) / 100.0
    local ty = (step.coords.y or 0) / 100.0

    -- Prefer UnitPosition if present (later clients)
    if UnitPosition then
        local px, py = UnitPosition("player")
        if not px or not py then return false end
        local dx, dy = tx - px, ty - py
        local dist = math.sqrt(dx*dx + dy*dy)
        local r = (step.radius or 0.3) / 100.0   -- keep your existing radius semantics
        if r < 0.0005 then r = 0.0005 end
        return dist <= r
    end

    -- Vanilla/Turtle fallback: map-based position
    if SetMapToCurrentZone and GetPlayerMapPosition then
        SetMapToCurrentZone()
        local px, py = GetPlayerMapPosition("player")
        if not px or not py then return false end
        local dx, dy = tx - px, ty - py
        local dist = math.sqrt(dx*dx + dy*dy)
        local r = (step.radius or 0.3) / 100.0   -- radius still in “percent of map”
        if r < 0.0005 then r = 0.0005 end
        return dist <= r
    end

    return false
end

local function QS__UseItemSatisfied(step)
    if not step then return false end

    -- optional target gate
    if step.npc and step.npc.name and step.npc.name ~= "" then
        local tgt = UnitName and UnitName("target") or nil
        if not tgt or string.lower(tgt) ~= string.lower(step.npc.name) then
            return false
        end
    end

    -- two ways to detect:
    --  (1) item enters cooldown soon after a bag cooldown update
    --  (2) stack/count decreases
    local id = step.itemId
    if not id then return false end

    -- detect cooldown starting
    local bag, slot = QS_FindItemInBags and QS_FindItemInBags(id)
    if bag and slot then
        local start, duration, enable = GetContainerItemCooldown(bag, slot)
        if enable and duration and duration > 1 and start and start > 0 then
            return true
        end
    end

    -- detect count drop (BAG_UPDATE sets lastChangeTime)
    if itemTrack.itemId == id and itemTrack.lastChangeTime and (Now() - itemTrack.lastChangeTime) <= 2.0 then
        return true
    end

    return false
end

-- ------------------------------------------------------------
-- Handlers
-- ------------------------------------------------------------
ev:SetScript("OnEvent", function()
    local event = event -- vanilla arg
    -- Behavior dispatch (early)
    -- REPLACE ONLY the Behavior dispatch block at the top of the handler with this:

    -- Behavior dispatch (early)
    local step = QS_CurrentStep and QS_CurrentStep() or nil
    if step then
        local st = QS_GuideState and QS_GuideState() or {}
        local idx = st and st.currentStep or 1
        local beh = _BehaviorFor(step)
        if beh and beh.onEvent then
            local state = _StateFor(idx)
            local ok, ret = pcall(beh.onEvent, step, event, { arg1=arg1, arg2=arg2, arg3=arg3 }, state)
            if ok and ret then
                if ret.advance then
                    if QS_D then QS_D("Behavior requested advance for "..(step.type or "")) end
                    -- Do NOT pre-mark here; QS_AdvanceStep will mark+advance once.
                    if QS_AdvanceStep then QS_AdvanceStep() end
                    return
                end
                if ret.reprime then
                    if QS__MaybePrimeTravelAndArrow then QS__MaybePrimeTravelAndArrow() end
                end
                if ret.handled then return end
            end
        end
    end

    if event == "VARIABLES_LOADED" or event == "PLAYER_ENTERING_WORLD" then
        if QuestShellUI_UpdateAll then QuestShellUI_UpdateAll() end
        return

    elseif event == "BAG_UPDATE" then
        local step = QS_CurrentStep and QS_CurrentStep() or nil
        if step and string.upper(step.type or "") == "USE_ITEM" and step.itemId and QS_CountItemInBags then
            local cur = QS_CountItemInBags(step.itemId)
            if itemTrack.prevCount ~= nil and cur ~= itemTrack.prevCount then
                itemTrack.lastChangeTime = Now()
            end
            itemTrack.prevCount = cur
        end
        return

    elseif event == "BAG_UPDATE_COOLDOWN" then
        local step = QS_CurrentStep and QS_CurrentStep() or nil
        if step and string.upper(step.type or "") == "USE_ITEM" then
            if QS__UseItemSatisfied(step) then
                if QS_D then QS_D("USE_ITEM satisfied; advancing step.") end
                QS__CompleteCurrentStep()
            end
        end
        return

    elseif event == "GOSSIP_SHOW" then
        local step = QS_CurrentStep and QS_CurrentStep() or nil
        if step and not QS_ShouldAutoHandleNpcForStep(step) then
            if QS_D then QS_D("GOSSIP_SHOW other NPC; ignoring.") end
            return
        end

        -- bridge gossip -> greeting when possible
        if step and (step.type == "ACCEPT" or step.type == "TURNIN") then
            if TryOpenGreetingFromGossip and TryOpenGreetingFromGossip() then
                if QS_D then QS_D("Opened QUEST_GREETING from gossip.") end
                return
            end

            -- Fallback: select directly when unambiguous
            if QS_HaveGossip and QS_HaveGossip() then
                if step.type == "ACCEPT" and QS_GossipAvailEntries then
                    local avail = QS_GossipAvailEntries()
                    local idx, count, i = nil, 0, 1
                    while avail[i] do
                        if avail[i].title == step.title then
                            count = count + 1
                            if not idx then idx = avail[i].idx end
                        end
                        i = i + 1
                    end
                    if idx and count == 1 then
                        if QS_D then QS_D("Selecting gossip available quest: "..tostring(step.title)) end
                        SelectGossipAvailableQuest(idx)
                        return
                    elseif QS_D then
                        QS_D("Gossip available ambiguous for "..tostring(step.title).." (matches="..tostring(count)..")")
                    end
                elseif step.type == "TURNIN" and QS_GossipActiveEntries then
                    local active = QS_GossipActiveEntries()
                    local i = 1
                    while active[i] do
                        if active[i].title == step.title then
                            if QS_D then QS_D("Selecting gossip active quest: "..tostring(step.title)) end
                            SelectGossipActiveQuest(active[i].idx)
                            return
                        end
                        i = i + 1
                    end
                end
            end
        end
        return

    elseif event == "QUEST_GREETING" then
        local step = QS_CurrentStep and QS_CurrentStep() or nil
        if not step then return end
        if not QS_ShouldAutoHandleNpcForStep(step) then
            if QS_D then QS_D("QUEST_GREETING other NPC; ignoring.") end
            return
        end

        if step.type == "ACCEPT" then
            local idx = QS__SelectAvailableIndexForAccept(step)
            if idx then
                if QS_D then QS_D("Selecting available quest #"..tostring(idx).." for "..tostring(step.title)) end
                SelectAvailableQuest(idx)
                return
            else
                if QS_D then QS_D("ACCEPT ambiguous for "..(step.title or "").."; add step.level or acceptLabels.") end
                return
            end

        elseif step.type == "TURNIN" then
            local n = GetNumActiveQuests() or 0
            local i = 1
            while i <= n do
                local t = GetActiveTitle(i)
                if t == step.title then
                    if QS_D then QS_D("Selecting active quest #"..tostring(i).." for "..tostring(step.title)) end
                    SelectActiveQuest(i)
                    return
                end
                i = i + 1
            end
        end
        return

    elseif event == "QUEST_DETAIL" then
        local step = QS_CurrentStep and QS_CurrentStep() or nil
        if not step then return end
        if not QS_ShouldAutoHandleNpcForStep(step) then
            if QS_D then QS_D("QUEST_DETAIL other NPC; ignoring.") end
            return
        end

        local title = GetTitleText and GetTitleText() or ""
        if step.type == "ACCEPT" and title == step.title then
            awaitingAcceptTitle = title
            if QS_D then QS_D("Accepting quest: "..tostring(title)) end
            AcceptQuest()
            return
        end
        return

    elseif event == "QUEST_PROGRESS" then
        local step = QS_CurrentStep and QS_CurrentStep() or nil
        if not step then return end
        if not QS_ShouldAutoHandleNpcForStep(step) then
            if QS_D then QS_D("QUEST_PROGRESS other NPC; ignoring.") end
            return
        end

        if step.type == "TURNIN" then
            if IsQuestCompletable and IsQuestCompletable() then
                if QS_D then QS_D("Completing quest (progress).") end
                CompleteQuest()
            end
            return
        end
        return

    elseif event == "QUEST_COMPLETE" then
        local step = QS_CurrentStep and QS_CurrentStep() or nil
        if not step then return end
        if not QS_ShouldAutoHandleNpcForStep(step) then
            if QS_D then QS_D("QUEST_COMPLETE other NPC; ignoring.") end
            return
        end

        if step.type == "TURNIN" then
            if QS_D then QS_D("Picking first reward and advancing step.") end
            GetQuestReward(1)
            QS_AdvanceStep()
            return
        end
        return

    elseif event == "QUEST_ACCEPTED" then
        local logIndex = arg1
        if QS_D then QS_D("QUEST_ACCEPTED idx="..tostring(logIndex)) end

        local st    = QS_GuideState and QS_GuideState() or nil
        local steps = QS_GuideData and QS_GuideData() or {}
        local cur   = st and st.currentStep or 1
        local curStep = steps[cur]

        -- Title at the accepted log index
        local acceptedTitle = nil
        if GetQuestLogTitle and logIndex then
            acceptedTitle = select(1, GetQuestLogTitle(logIndex))
        end

        -- 1) Easy path: title match to current ACCEPT step (case-insensitive)
        if curStep and string.upper(curStep.type or "") == "ACCEPT" and curStep.title and acceptedTitle then
            if string.lower(curStep.title) == string.lower(acceptedTitle) then
                if QS_D then QS_D("ACCEPT matched current step by title → advance") end
                QS_AdvanceStep()
                return
            end
        end

        -- 2) Existing scoring path (labels/IDs) as fallback
        local currentMatchIdx = nil
        local bestForCurrent = QS__BestLogIndexForAcceptStep and QS__BestLogIndexForAcceptStep(cur) or nil
        if bestForCurrent and bestForCurrent == logIndex then
            currentMatchIdx = cur
        end

        local matchIdx = currentMatchIdx or (QS__BestAcceptStepForLogIndex and QS__BestAcceptStepForLogIndex(logIndex))

        if matchIdx then
            if matchIdx == cur then
                if QS_Print then QS_Print("Accepted: "..(acceptedTitle or "<title>")) end
                QS_AdvanceStep()
            else
                if QS_Print then QS_Print("Accepted out of order (step "..tostring(matchIdx)..") — marking complete") end
                if QS_UI_SetStepCompleted then QS_UI_SetStepCompleted(matchIdx, true) end
            end
        else
            if QS_D then QS_D("ACCEPT could not match step for "..tostring(acceptedTitle or "<nil>")) end
        end
        return

    elseif event == "QUEST_LOG_UPDATE" then
        -- confirm accepts (legacy path)
        if awaitingAcceptTitle then
            local st = QS_GuideState and QS_GuideState() or nil
            local cur = st and st.currentStep or 1
            local steps = QS_GuideData and QS_GuideData() or {}
            local curStep = steps[cur]

            local entries = GetNumQuestLogEntries() or 0
            local i = 1
            while i <= entries do
                local t, qLevel, _, _, isHeader = GetQuestLogTitle(i)
                if not isHeader and t == awaitingAcceptTitle then
                    local bestForCurrent = QS__BestLogIndexForAcceptStep and QS__BestLogIndexForAcceptStep(cur) or nil
                    if (bestForCurrent and bestForCurrent == i) then
                        awaitingAcceptTitle = nil
                        if QS_D then QS_D("Confirmed accepted (level-aware): "..t) end
                        QS_AdvanceStep()
                        break
                    end

                    if curStep and curStep.level and qLevel and curStep.level == qLevel then
                        awaitingAcceptTitle = nil
                        if QS_D then QS_D("Confirmed accepted (exact level): "..t) end
                        QS_AdvanceStep()
                        break
                    end
                end
                i = i + 1
            end
        end

        -- NEW: auto-advance COMPLETE steps when all objectives are done
        do
            local st = QS_GuideState and QS_GuideState() or nil
            local cur = st and st.currentStep or 1
            local steps = QS_GuideData and QS_GuideData() or {}
            local s = steps[cur]
            if s and string.upper(s.type or "") == "COMPLETE" and s.title then
                local idx = QS_FindQuestLogIndexByTitle and QS_FindQuestLogIndexByTitle(s.title) or nil
                if idx and QS_IsQuestObjectivesCompleteByIndex and QS_IsQuestObjectivesCompleteByIndex(idx) then
                    if QS_D then QS_D("Objectives complete for '"..(s.title or "").."'; advancing step.") end
                    QS_AdvanceStep()
                end
            end
        end

        -- Passive scan: mark any ACCEPT steps already in the log (eligible-only, strict match)
        do
            local steps2 = QS_GuideData and QS_GuideData() or {}
            local ii = 1
            while steps2[ii] do
                local s2 = steps2[ii]
                if s2 and s2.type == "ACCEPT" and s2.title then
                    local notDone = (not QS_UI_IsStepCompleted) or (not QS_UI_IsStepCompleted(ii))
                    local eligible = (not QS_StepIsEligible) or QS_StepIsEligible(s2)
                    if notDone and eligible then
                        local best = QS__BestLogIndexForAcceptStep(ii)
                        if best then
                            if QS_Print then QS_Print("Detected already accepted: "..(s2.title or "").." (step "..tostring(ii)..")") end
                            if QS_UI_SetStepCompleted then QS_UI_SetStepCompleted(ii, true) end
                        end
                    end
                end
                ii = ii + 1
            end
        end

        if QuestShellUI_UpdateAll then QuestShellUI_UpdateAll() end
        return
    end
end)

-- ------------------------------------------------------------
-- TRAVEL/COMPLETE OnUpdate poller (lightweight; 0.2s)
-- ------------------------------------------------------------

-- ------------------------------------------------------------
-- OnUpdate poller (0.2s): delegate to step behavior
-- ------------------------------------------------------------
-- REPLACE the entire travelPoll:SetScript("OnUpdate", ...) with this
local travelPoll = CreateFrame("Frame", "QuestShellTravelPoll")
travelPoll:SetScript("OnUpdate", function()
    travelUpdateAccum = travelUpdateAccum + (arg1 or 0)
    if travelUpdateAccum < 0.2 then return end
    travelUpdateAccum = 0

    local step = QS_CurrentStep and QS_CurrentStep() or nil
    if not step then return end
    local st = QS_GuideState and QS_GuideState() or {}
    local idx = st and st.currentStep or 1
    local beh = _BehaviorFor(step)
    if not beh or not beh.onUpdate then return end

    local state = _StateFor(idx)
    local ok, ret = pcall(beh.onUpdate, step, { dt=0.2, helpers={ WithinRadius=_WithinTravelRadius } }, state)
    if not ok then return end

    if ret and ret.arrived then
        _qsArrivedForStepIdx = idx
        if QuestShellUI and QuestShellUI.ArrowClear then QuestShellUI.ArrowClear() end
        return
    end

    if ret and ret.advance then
        if QS_D then QS_D("Behavior requested advance for "..(step.type or "")) end
        -- Do NOT pre-mark here; QS_AdvanceStep will mark+advance once.
        if QS_AdvanceStep then QS_AdvanceStep() end
        return
    end
end)
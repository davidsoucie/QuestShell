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
-- Local helpers / state
-- ------------------------------------------------------------
local awaitingAcceptTitle = nil
local travelUpdateAccum = 0
local itemTrack = { itemId=nil, prevCount=nil, lastChangeTime=0 }

-- NEW: suppression + step-change tracker
local _qsArrivedForStepIdx = nil     -- if set to current step index, don't re-prime arrow for COMPLETE
local _qsLastStepIdx = nil           -- remember last seen step index to detect any step change

local function Now() return GetTime and GetTime() or 0 end

local function Safe(t) return t or "" end
local function tlen(t) local n=0; if type(t)=="table" then for _ in pairs(t) do n=n+1 end end; return n end

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

local function QS__BestAcceptStepForLogIndex(logIndex)
    if not logIndex then return nil end
    local title, qLevel = GetQuestLogTitle(logIndex)
    if not title then return nil end

    local qid = QS__LogQuestID(logIndex)
    local steps = QS_GuideData() or {}

    local bestIdx, bestScore, bestLabels = nil, -1, 0
    local secondBest = -1

    local i = 1
    while steps[i] do
        local s = steps[i]
        if s and s.type == "ACCEPT" and s.title == title and not (QS_UI_IsStepCompleted and QS_UI_IsStepCompleted(i)) then
            if qid and s.questId and s.questId == qid then
                return i
            end
            if s.level and qLevel and s.level == qLevel then
                return i
            end
            local labels = QS__CollectExpectedLabelsForStep(i, steps)
            local need = table.getn(labels)
            local sc = QS__ScoreLogIndexAgainstLabels(logIndex, labels)
            if sc > bestScore then
                secondBest = bestScore
                bestScore, bestIdx, bestLabels = sc, i, need
            elseif sc > secondBest then
                secondBest = sc
            end
        end
        i = i + 1
    end

    if bestIdx and bestScore >= bestLabels and bestScore > secondBest then
        return bestIdx
    end
    return nil
end

local function QS__BestLogIndexForAcceptStep(stepIndex)
    local steps = QS_GuideData() or {}
    local s = steps[stepIndex]; if not s or not s.title then return nil end
    local n = GetNumQuestLogEntries() or 0

    local wantID = s.questId
    local wantLevel = s.level
    local labels = QS__CollectExpectedLabelsForStep(stepIndex, steps)
    local need = table.getn(labels)

    local bestIdx, bestScore, i = nil, -1, 1
    while i <= n do
        local t, qLevel, _, _, isHeader = GetQuestLogTitle(i)
        if not isHeader and t == s.title then
            local qid = QS__LogQuestID(i)
            if wantID and qid and wantID == qid then return i end
            if wantLevel and qLevel and wantLevel == qLevel then return i end
            local sc = QS__ScoreLogIndexAgainstLabels(i, labels)
            if sc > bestScore then bestScore, bestIdx = sc, i end
        end
        i = i + 1
    end
    if bestIdx and bestScore >= need and need > 0 then return bestIdx end
    return nil
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

-- ------------------------------------------------------------
-- Step advancement that skips steps already checked
-- ------------------------------------------------------------
function QS_AdvanceStep()
    local steps = QS_GuideData()
    local st = QS_GuideState()
    if not steps or not st then return end

    st.completedByChapter = st.completedByChapter or {}
    local ch = QS_CurrentChapterIndex()
    local arr = st.completedByChapter[ch] or {}
    arr[table.getn(arr)+1] = st.currentStep
    st.completedByChapter[ch] = arr

    -- set of completed indices
    local set = {}
    local i = 1
    while i <= table.getn(arr) do set[arr[i]] = true; i = i + 1 end

    local n = table.getn(steps or {})
    local nextIdx = st.currentStep + 1
    while nextIdx <= n and set[nextIdx] do
        nextIdx = nextIdx + 1
    end
    st.currentStep = nextIdx

    -- clear trackers on advance; reset COMPLETE suppression for new step
    itemTrack.itemId, itemTrack.prevCount, itemTrack.lastChangeTime = nil, nil, 0
    _qsArrivedForStepIdx = nil
    _qsLastStepIdx = nil
    if QuestShellUI and QuestShellUI.ArrowClear then QuestShellUI.ArrowClear() end

    -- within current chapter?
    if st.currentStep <= n then
        if QuestShellUI_UpdateAll then QuestShellUI_UpdateAll() end
        return
    end

    -- next chapter?
    local nCh = QS_ChapterCount and QS_ChapterCount() or 1
    if QS_CurrentChapterIndex() < nCh and QuestShell and QuestShell.SetChapter then
        QuestShell.SetChapter(QS_CurrentChapterIndex() + 1)
        if QuestShellUI_UpdateAll then QuestShellUI_UpdateAll() end
        return
    end

    -- or next guide
    if QS_LoadNextGuideIfAny and QS_LoadNextGuideIfAny() then
        if QuestShellUI_UpdateAll then QuestShellUI_UpdateAll() end
        return
    end
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

    -- Detect ANY step change (forward/back/jump) → reset suppression
    if _qsLastStepIdx ~= idx then
        _qsArrivedForStepIdx = nil
        _qsLastStepIdx = idx
    end

    local typ  = string.upper(step.type or "")
    local hasC = step.coords and step.coords.x and step.coords.y

    -- Show arrow for:
    --  - TRAVEL (if coords)
    --  - COMPLETE (if coords) ONLY until first arrival (suppressed afterwards)
    --  - ACCEPT (if coords)
    --  - TURNIN (if coords)
    local wantArrow =
        (typ == "TRAVEL"   and hasC) or
        (typ == "COMPLETE" and hasC and _qsArrivedForStepIdx ~= idx) or
        (typ == "ACCEPT"   and hasC) or
        (typ == "TURNIN"   and hasC)

    if wantArrow and QuestShellUI and QuestShellUI.ArrowSet then
        local c = step.coords
        QuestShellUI.ArrowSet(c.map or "", c.x, c.y, step.title or "Waypoint")
    else
        if QuestShellUI and QuestShellUI.ArrowClear then
            QuestShellUI.ArrowClear()
        end
    end

    -- USE_ITEM: prepare counters for detection
    if typ == "USE_ITEM" then
        local id = step.itemId
        if id and QS_CountItemInBags then
            itemTrack.itemId = id
            itemTrack.prevCount = QS_CountItemInBags(id)
            itemTrack.lastChangeTime = 0
        end
    else
        itemTrack.itemId, itemTrack.prevCount, itemTrack.lastChangeTime = nil, nil, 0
    end
end

function QuestShellUI_UpdateAll()
    local steps = QS_GuideData and QS_GuideData() or {}
    local st = QS_GuideState and QS_GuideState() or {}
    local ch = QS_CurrentChapterIndex and QS_CurrentChapterIndex() or 1

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

-- ------------------------------------------------------------
-- Helpers: TRAVEL + USE_ITEM + arrival check
-- ------------------------------------------------------------
local function QS__CompleteCurrentStep()
    if QS_AdvanceStep then QS_AdvanceStep() end
end

local function QS__WithinTravelRadius(step)
    if not step or not step.coords or not step.coords.x or not step.coords.y then return false end
    local playerZone = GetRealZoneText() or GetZoneText() or ""
    local wantMap = step.coords.map or ""

    if wantMap ~= "" and string.lower(playerZone) ~= string.lower(wantMap) then
        return false
    end

    SetMapToCurrentZone()
    local px, py = GetPlayerMapPosition("player")
    if not px or not py or (px == 0 and py == 0) then return false end

    local tx = (step.coords.x or 0) / 100.0
    local ty = (step.coords.y or 0) / 100.0
    local dx = tx - px
    local dy = ty - py
    local dist = math.sqrt(dx*dx + dy*dy) * 100.0  -- same scale used by arrow

    local r = step.radius or 0.3   -- default small radius in "map percent" units
    if r < 0.05 then r = 0.05 end
    return dist <= r
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
        if QS_D then QS_D("QUEST_ACCEPTED index "..tostring(logIndex)) end

        local st = QS_GuideState and QS_GuideState() or nil
        local cur = st and st.currentStep or 1

        local currentMatchIdx = nil
        local bestForCurrent = QS__BestLogIndexForAcceptStep and QS__BestLogIndexForAcceptStep(cur) or nil
        if bestForCurrent and bestForCurrent == logIndex then
            currentMatchIdx = cur
        end

        local matchIdx = currentMatchIdx or QS__BestAcceptStepForLogIndex(logIndex)

        if matchIdx then
            if matchIdx == cur then
                awaitingAcceptTitle = nil
                if QS_Print then
                    local t = select(1, GetQuestLogTitle(logIndex)) or ""
                    QS_Print("Accepted: "..t)
                end
                QS_AdvanceStep()
            else
                if QS_Print then QS_Print("Accepted out of order (step "..tostring(matchIdx)..") — marking complete") end
                if QS_UI_SetStepCompleted then QS_UI_SetStepCompleted(matchIdx, true) end
                awaitingAcceptTitle = nil
            end
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

        -- Passive scan: mark any ACCEPT steps already in the log (duplicate-safe)
        local steps2 = QS_GuideData and QS_GuideData() or {}
        local ii = 1
        while steps2[ii] do
            local s2 = steps2[ii]
            if s2 and s2.type == "ACCEPT" and s2.title then
                if QS_UI_IsStepCompleted and not QS_UI_IsStepCompleted(ii) then
                    local best = QS__BestLogIndexForAcceptStep(ii)
                    if best then
                        if QS_Print then QS_Print("Detected already accepted: "..(s2.title or "").." (step "..tostring(ii)..")") end
                        if QS_UI_SetStepCompleted then QS_UI_SetStepCompleted(ii, true) end
                    end
                end
            end
            ii = ii + 1
        end

        if QuestShellUI_UpdateAll then QuestShellUI_UpdateAll() end
        return
    end
end)

-- ------------------------------------------------------------
-- TRAVEL/COMPLETE OnUpdate poller (lightweight; 0.2s)
-- ------------------------------------------------------------
local travelPoll = CreateFrame("Frame", "QuestShellTravelPoll")
travelPoll:SetScript("OnUpdate", function()
    travelUpdateAccum = travelUpdateAccum + (arg1 or 0)
    if travelUpdateAccum < 0.2 then return end
    travelUpdateAccum = 0

    local step = QS_CurrentStep and QS_CurrentStep() or nil
    if not step then return end

    local stype = string.upper(step.type or "")
    if stype == "TRAVEL" then
        if QS__WithinTravelRadius(step) then
            if QS_D then QS_D("TRAVEL arrived within radius; advancing step.") end
            QS__CompleteCurrentStep()
            return
        end

    elseif stype == "COMPLETE" then
        -- Only trigger once, the first time we arrive for this step
        if step.coords and step.coords.x and step.coords.y then
            local st = QS_GuideState and QS_GuideState() or nil
            local cur = st and st.currentStep
            if cur and _qsArrivedForStepIdx ~= cur and QS__WithinTravelRadius(step) then
                _qsArrivedForStepIdx = cur   -- remember arrival for THIS step
                if QuestShellUI and QuestShellUI.ArrowClear then
                    QuestShellUI.ArrowClear()
                end
                if QS_D then QS_D("COMPLETE arrived; suppressing arrow for this step.") end
                return
            end
        end

    elseif stype == "USE_ITEM" then
        -- secondary check in case cooldown event missed
        if QS__UseItemSatisfied(step) then
            if QS_D then QS_D("USE_ITEM satisfied (poll); advancing step.") end
            QS__CompleteCurrentStep()
            return
        end
    end
end)

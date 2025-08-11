-- =========================
-- QuestShell core_stepbehave.lua
-- Behavior registry for step types (arrow, completion, events)
-- Vanilla/Turtle (Lua 5.0)
-- =========================

-- Public:
--   QS_RegisterStepBehavior(name, spec)
--   QS_BehaviorFor(stepType) -> spec or nil
--
-- Spec fields (all optional):
--   waypoint(step) -> { map, x, y, title?, suppressAfterArrival?, radius? } or nil
--   onEnter(step, state)
--   onUpdate(step, ctx, state) -> { advance=true } or { arrived=true } or nil
--   onEvent(step, event, args, state) -> { advance?, handled?, reprime? } or nil
--   isComplete(step) -> boolean (polled elsewhere if needed)

local REG = {}

function QS_RegisterStepBehavior(name, spec)
    if not name or not spec then return end
    REG[string.upper(name)] = spec
end

function QS_BehaviorFor(stepType)
    if not stepType then return nil end
    return REG[string.upper(stepType)]
end

-- ---------------- Built-in helpers (use only base API) ----------------
local function _hasCoords(step)
    return step and step.coords and step.coords.x and step.coords.y
end

-- ---------------- Built-in behaviors ----------------

-- TRAVEL: advance when within radius, show arrow to coords
QS_RegisterStepBehavior("TRAVEL", {
    waypoint = function(step)
        if _hasCoords(step) then
            return { map=step.coords.map, x=step.coords.x, y=step.coords.y, title=step.title }
        end
        return nil
    end,
    onUpdate = function(step, ctx, state)
        if ctx and ctx.helpers and ctx.helpers.WithinRadius and ctx.helpers.WithinRadius(step) then
            return { advance = true }
        end
        return nil
    end
})

-- COMPLETE: show arrow to coords until first arrival (UI hint), do NOT auto-advance
QS_RegisterStepBehavior("COMPLETE", {
    waypoint = function(step)
        if _hasCoords(step) then
            return { map=step.coords.map, x=step.coords.x, y=step.coords.y, title=step.title, suppressAfterArrival=true }
        end
        return nil
    end,
    onUpdate = function(step, ctx, state)
        if ctx and ctx.helpers and ctx.helpers.WithinRadius and ctx.helpers.WithinRadius(step) then
            return { arrived = true }
        end
        return nil
    end
})

-- ACCEPT/TURNIN: arrow only, rest handled by core quest events
QS_RegisterStepBehavior("ACCEPT", {
    waypoint = function(step)
        if _hasCoords(step) then
            return { map=step.coords.map, x=step.coords.x, y=step.coords.y, title=step.title }
        end
    end
})
QS_RegisterStepBehavior("TURNIN", {
    waypoint = function(step)
        if _hasCoords(step) then
            return { map=step.coords.map, x=step.coords.x, y=step.coords.y, title=step.title }
        end
    end
})

-- USE_ITEM: detect via bag cooldown or count drop
QS_RegisterStepBehavior("USE_ITEM", {
    onEnter = function(step, state)
        state = state or {}
        local id = step and step.itemId
        if id and QS_CountItemInBags then
            state.itemId = id
            state.prevCount = QS_CountItemInBags(id)
            state.lastChangeTime = 0
        end
    end,
    onEvent = function(step, event, args, state)
        state = state or {}
        local id = state.itemId or (step and step.itemId)
        if not id then return nil end

        if event == "BAG_UPDATE" then
            if QS_CountItemInBags then
                local cur = QS_CountItemInBags(id)
                if state.prevCount ~= nil and cur ~= state.prevCount then
                    state.lastChangeTime = (GetTime and GetTime()) or 0
                end
                state.prevCount = cur
            end
            return { handled = true }

        elseif event == "BAG_UPDATE_COOLDOWN" then
            -- detect cooldown starting soon after BAG_UPDATE
            if QS_FindItemInBags then
                local bag, slot = QS_FindItemInBags(id)
                if bag and slot then
                    local s, dur = GetContainerItemCooldown(bag, slot)
                    if s and dur and dur > 0 then
                        if state.lastChangeTime and ((GetTime and GetTime()) or 0) - state.lastChangeTime <= 2.0 then
                            return { advance = true, handled = true }
                        end
                    end
                end
            end
            -- also detect count drop within 2s of BAG_UPDATE
            if state.lastChangeTime and ((GetTime and GetTime()) or 0) - state.lastChangeTime <= 2.0 then
                return { advance = true, handled = true }
            end
            return { handled = true }
        end
        return nil
    end,
    onUpdate = function(step, ctx, state)
        -- secondary poll in case events were missed
        if not state then return nil end
        local id = state.itemId or (step and step.itemId)
        if not id then return nil end
        if QS_FindItemInBags then
            local bag, slot = QS_FindItemInBags(id)
            if bag and slot then
                local s, dur = GetContainerItemCooldown(bag, slot)
                if s and dur and dur > 0 then
                    if state.lastChangeTime and ((GetTime and GetTime()) or 0) - state.lastChangeTime <= 2.0 then
                        return { advance = true }
                    end
                end
            end
        end
        return nil
    end
})

-- SET_HEARTH: auto-confirm binder (optional) and complete when bind location changes
QS_RegisterStepBehavior("SET_HEARTH", {
    waypoint = function(step)
        if _hasCoords(step) then
            return { map=step.coords.map, x=step.coords.x, y=step.coords.y, title=step.title }
        end
    end,
    onEnter = function(step, state)
        state.oldBind = (GetBindLocation and GetBindLocation()) or ""
        state.autoConfirm = (step and step.autoconfirm ~= false) and true or false
    end,
    onEvent = function(step, event, args, state)
        if event == "CONFIRM_BINDER" then
            if state and state.autoConfirm and ConfirmBinder then
                ConfirmBinder()
                return { handled = true }
            end
        end
        return nil
    end,
    onUpdate = function(step, ctx, state)
        local cur = (GetBindLocation and GetBindLocation()) or ""
        if state and state.oldBind and cur ~= "" and cur ~= state.oldBind then
            return { advance = true }
        end
        return nil
    end
})

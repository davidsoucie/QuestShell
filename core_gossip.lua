-- =========================
-- QuestShell core_gossip.lua
-- Gossip availability/active parsing + greeting bridge
-- =========================

function QS_HaveGossip()
    return (type(GetGossipAvailableQuests) == "function") and
           (type(SelectGossipAvailableQuest) == "function") and
           (type(GetGossipOptions) == "function") and
           (type(SelectGossipOption) == "function")
end

-- Entries as { idx = realQuestIndex, title = "..." }
function QS_GossipAvailEntries()
    if not QS_HaveGossip() then return {} end
    local raw = { GetGossipAvailableQuests() }
    local out, q = {}, 0
    local i = 1
    while i <= table.getn(raw) do
        local v = raw[i]
        if type(v) == "string" and (i == 1 or type(raw[i-1]) ~= "string") then
            q = q + 1
            out[table.getn(out)+1] = { idx = q, title = v }
        end
        i = i + 1
    end
    return out
end

function QS_GossipActiveEntries()
    if not QS_HaveGossip() then return {} end
    local raw = { GetGossipActiveQuests() }
    local out, q = {}, 0
    local i = 1
    while i <= table.getn(raw) do
        local v = raw[i]
        if type(v) == "string" and (i == 1 or type(raw[i-1]) ~= "string") then
            q = q + 1
            out[table.getn(out)+1] = { idx = q, title = v }
        end
        i = i + 1
    end
    return out
end

function TryOpenGreetingFromGossip()
    if not QS_HaveGossip() then return false end
    local opt = { GetGossipOptions() }  -- pairs: text, type, text, type...
    if table.getn(opt) == 0 then return false end
    local idx, i = 1, 1
    while opt[i] do
        local text, typ = opt[i], opt[i+1]
        local lower = string.lower(text or "")
        if string.find(lower, "quest") or (typ and string.lower(typ) == "available") then
            SelectGossipOption(idx)
            return true
        end
        idx = idx + 1; i = i + 2
    end
    return false
end

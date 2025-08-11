-- =========================
-- QuestShell core_debug_commands.lua
-- /qsd on|off   -> toggle debug logs
-- =========================
SLASH_QSDEBUG1 = "/qsd"
SlashCmdList = SlashCmdList or {}
SlashCmdList["QSDEBUG"] = function(msg)
    local m = (msg or ""):lower()
    if m == "on" or m == "1" or m == "true" then
        QuestShell = QuestShell or {}; QuestShell.debug = true
        if DEFAULT_CHAT_FRAME then DEFAULT_CHAT_FRAME:AddMessage("|cffcc66ff[QuestShell:DBG]|r ON") end
    elseif m == "off" or m == "0" or m == "false" then
        QuestShell = QuestShell or {}; QuestShell.debug = false
        if DEFAULT_CHAT_FRAME then DEFAULT_CHAT_FRAME:AddMessage("|cffcc66ff[QuestShell:DBG]|r OFF") end
    else
        local state = (QuestShell and QuestShell.debug) and "ON" or "OFF"
        if DEFAULT_CHAT_FRAME then DEFAULT_CHAT_FRAME:AddMessage("|cffcc66ff[QuestShell:DBG]|r "..state.."  (use /qsd on|off)") end
    end
end

-- NEW: /qsresync to manually re-mark accepted quests
SLASH_QSRESYNC1 = "/qsresync"
SlashCmdList.QSRESYNC = function()
    if QS_PassiveResyncAccepts then QS_PassiveResyncAccepts() end
    if QuestShellUI_UpdateAll then QuestShellUI_UpdateAll() end
    QS_Print("QuestShell: resynced ACCEPT steps.")
end

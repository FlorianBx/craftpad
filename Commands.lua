-- Slash Commands
SLASH_CRAFTPAD1 = "/craftpad"
SLASH_CRAFTPAD2 = "/cp"

SlashCmdList["CRAFTPAD"] = function(msg)
    msg = string.lower(msg or "")

    if msg == "" then
        -- Toggle main frame
        Craftpad.UI.ToggleMainFrame()
    elseif msg == "help" then
        print("Craftpad Commands:")
        print("/craftpad or /cp - Toggle housing items list")
        print("/craftpad help - Show this help")
    else
        print("Craftpad: Unknown command. Type /craftpad help for available commands")
    end
end

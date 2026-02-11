-- Craftpad Core
-- Global namespace
Craftpad = {}
Craftpad.Version = "1.0.0"
Craftpad.Data = {}
Craftpad.UI = {}
Craftpad.Search = {}

-- Event Frame
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_LOGIN")

eventFrame:SetScript("OnEvent", function(self, event, addonName)
    if event == "ADDON_LOADED" and addonName == "Craftpad" then
        print("Craftpad: Addon loaded (v" .. Craftpad.Version .. ")")
    elseif event == "PLAYER_LOGIN" then
        print("Craftpad: Type /cp to open housing items list")
    end
end)

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
        
        -- Create the inventory event frame (after addon is fully loaded)
        local success, err = pcall(function()
            Craftpad.InventoryEventFrame = CreateFrame("Frame")
            
            -- Register inventory events
            Craftpad.InventoryEventFrame:RegisterEvent("BAG_UPDATE_DELAYED")
            Craftpad.InventoryEventFrame:RegisterEvent("BAG_UPDATE")
            
            -- Try to register bank event (may not exist in all versions)
            pcall(function()
                Craftpad.InventoryEventFrame:RegisterEvent("PLAYERBANKSLOTS_CHANGED")
            end)
            
            -- Warband bank bag IDs (TWW)
            local WARBAND_BANK_START = Enum.BagIndex.AccountBankTab_1 or 13
            local WARBAND_BANK_END = WARBAND_BANK_START + 4
            
            Craftpad.InventoryEventFrame:SetScript("OnEvent", function(self, event, bagID)
                -- BAG_UPDATE includes a bagID parameter - check if it's warband bank
                if event == "BAG_UPDATE" then
                    if not bagID or bagID < WARBAND_BANK_START or bagID > WARBAND_BANK_END then
                        return -- Not a warband bank bag, ignore
                    end
                end
                
                -- Don't update during combat
                if UnitAffectingCombat("player") then 
                    return 
                end
                
                -- Only update if frame exists, is shown, and has selected item
                if Craftpad.UI.MainFrame and Craftpad.UI.MainFrame:IsShown() and Craftpad.UI.MainFrame.selectedItemData then
                    Craftpad.UI.UpdateDetailPanel(Craftpad.UI.MainFrame.selectedItemData)
                end
            end)
        end)
        
        if not success then
            print("Craftpad ERROR: Failed to create inventory event frame: " .. tostring(err))
        end
        
    elseif event == "PLAYER_LOGIN" then
        print("Craftpad: Type /cp to open housing items list")
    end
end)

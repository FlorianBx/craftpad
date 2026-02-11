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
        print("Craftpad: Creating inventory event frame...")
        
        -- NOW create the inventory event frame (after addon is fully loaded)
        local success, err = pcall(function()
            Craftpad.InventoryEventFrame = CreateFrame("Frame")
            print("Craftpad: Frame created, registering events...")
            
            -- Register only events that actually exist in WoW
            Craftpad.InventoryEventFrame:RegisterEvent("BAG_UPDATE_DELAYED")
            print("Craftpad: BAG_UPDATE_DELAYED registered")
            
            -- Try to register bank event (may not exist in all versions)
            local bankSuccess = pcall(function()
                Craftpad.InventoryEventFrame:RegisterEvent("PLAYERBANKSLOTS_CHANGED")
            end)
            if bankSuccess then
                print("Craftpad: PLAYERBANKSLOTS_CHANGED registered")
            else
                print("Craftpad: PLAYERBANKSLOTS_CHANGED not available, skipping")
            end
            
            print("Craftpad: Setting event script...")
            
            Craftpad.InventoryEventFrame:SetScript("OnEvent", function(self, event)
                print("Craftpad: Event received: " .. event)
                
                -- Don't update during combat
                if UnitAffectingCombat("player") then 
                    print("Craftpad: In combat, skipping update")
                    return 
                end
                
                -- Debug checks
                print("Craftpad: MainFrame exists?", Craftpad.UI.MainFrame ~= nil)
                if Craftpad.UI.MainFrame then
                    print("Craftpad: MainFrame shown?", Craftpad.UI.MainFrame:IsShown())
                    print("Craftpad: selectedItemData exists?", Craftpad.UI.MainFrame.selectedItemData ~= nil)
                end
                
                -- Only update if frame exists, is shown, and has selected item
                if Craftpad.UI.MainFrame and Craftpad.UI.MainFrame:IsShown() and Craftpad.UI.MainFrame.selectedItemData then
                    print("Craftpad: Updating detail panel!")
                    Craftpad.UI.UpdateDetailPanel(Craftpad.UI.MainFrame.selectedItemData)
                end
            end)
            
            print("Craftpad: Inventory event frame setup complete!")
        end)
        
        if not success then
            print("Craftpad ERROR: Failed to create inventory event frame: " .. tostring(err))
        end
        
    elseif event == "PLAYER_LOGIN" then
        print("Craftpad: Type /cp to open housing items list")
    end
end)

local addonName = "Craftpad"

local frame = CreateFrame("Frame", "CraftpadMainFrame", UIParent, "BackdropTemplate")
frame:SetSize(300, 150)
frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
frame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
    tile = true,
    tileSize = 32,
    edgeSize = 32,
    insets = { left = 11, right = 12, top = 12, bottom = 11 }
})
frame:SetBackdropColor(0, 0, 0, 0.8)

local text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
text:SetPoint("CENTER", frame, "CENTER", 0, 0)
text:SetText("Hello World")

frame:Hide()

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" then
        frame:Show()
        print(addonName .. " loaded! Hello World window displayed.")
    end
end)

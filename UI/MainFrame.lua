-- Main UI Frame with scrollable list
local FRAME_WIDTH = 400
local FRAME_HEIGHT = 500
local ROW_HEIGHT = 20

function Craftpad.UI.CreateMainFrame()
    -- Main Frame
    local frame = CreateFrame("Frame", "CraftpadMainFrame", UIParent, "BackdropTemplate")
    frame:SetSize(FRAME_WIDTH, FRAME_HEIGHT)
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 32,
        edgeSize = 32,
        insets = { left = 11, right = 12, top = 12, bottom = 11 }
    })
    frame:SetBackdropColor(0, 0, 0, 0.9)
    frame:EnableMouse(true)
    frame:SetMovable(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
    frame:SetClampedToScreen(true)
    frame:Hide()

    -- Title
    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", frame, "TOP", 0, -20)
    title:SetText("Craftpad - Housing Items")

    -- Close Button
    local closeBtn = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -5, -5)
    closeBtn:SetScript("OnClick", function()
        frame:Hide()
    end)

    -- Item Count
    local itemCount = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    itemCount:SetPoint("TOP", title, "BOTTOM", 0, -5)
    local count = Craftpad.Data.GetItemCount()
    itemCount:SetText(count .. " items available")

    -- Scroll Frame
    local scrollFrame = CreateFrame("ScrollFrame", "CraftpadScrollFrame", frame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -70)
    scrollFrame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 20)

    -- Scroll Child (content container)
    local scrollChild = CreateFrame("Frame", nil, scrollFrame)
    scrollFrame:SetScrollChild(scrollChild)
    scrollChild:SetSize(FRAME_WIDTH - 60, ROW_HEIGHT * count)

    -- Populate list
    local items = Craftpad.Data.GetHousingItems()
    for i, item in ipairs(items) do
        local row = CreateFrame("Frame", nil, scrollChild, "BackdropTemplate")
        row:SetSize(FRAME_WIDTH - 60, ROW_HEIGHT)
        row:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, -(i-1) * ROW_HEIGHT)
        row:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8x8",
        })
        
        -- Alternate row colors
        if i % 2 == 0 then
            row:SetBackdropColor(0.1, 0.1, 0.1, 0.3)
        else
            row:SetBackdropColor(0.2, 0.2, 0.2, 0.3)
        end

        local text = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        text:SetPoint("LEFT", row, "LEFT", 10, 0)
        text:SetText(item.name .. " (" .. item.category .. ")")
    end

    Craftpad.UI.MainFrame = frame
    return frame
end

function Craftpad.UI.ToggleMainFrame()
    if not Craftpad.UI.MainFrame then
        Craftpad.UI.CreateMainFrame()
    end
    
    if Craftpad.UI.MainFrame:IsShown() then
        Craftpad.UI.MainFrame:Hide()
    else
        Craftpad.UI.MainFrame:Show()
    end
end

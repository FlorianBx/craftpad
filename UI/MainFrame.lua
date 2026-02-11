-- Main UI Frame with split-view: list + detail panel

local FRAME_WIDTH = 800
local FRAME_HEIGHT = 500
local LIST_WIDTH = 350
local DETAIL_WIDTH = 400
local ROW_HEIGHT = 24
local ICON_SIZE = 20

local selectedRow = nil
local selectedItemData = nil
local currentSearchText = ""
local itemRows = {}
local searchBox = nil
local listPanel = nil
local scrollFrame = nil
local scrollChild = nil
local itemCount = nil

-- Quality colors (WoW standard)
local QUALITY_COLORS = {
    [0] = {r = 0.62, g = 0.62, b = 0.62}, -- Poor (gray)
    [1] = {r = 1.0, g = 1.0, b = 1.0},    -- Common (white)
    [2] = {r = 0.12, g = 1.0, b = 0.0},   -- Uncommon (green)
    [3] = {r = 0.0, g = 0.44, b = 0.87},  -- Rare (blue)
    [4] = {r = 0.64, g = 0.21, b = 0.93}, -- Epic (purple)
}

-- Filter items based on search text (delegates to Search module)
local function FilterItems(searchText)
    local allItems = Craftpad.Data.GetHousingItems()
    return Craftpad.Search.search_items(allItems, searchText)
end

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
    itemCount = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    itemCount:SetPoint("TOP", title, "BOTTOM", 0, -5)
    local count = Craftpad.Data.GetItemCount()
    itemCount:SetText(count .. " items available - Click an item to view crafting details")

    -- LEFT PANEL: List of items
    listPanel = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    listPanel:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, -70)
    listPanel:SetSize(LIST_WIDTH, FRAME_HEIGHT - 100)
    listPanel:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        tile = false,
        edgeSize = 1,
        insets = { left = 0, right = 0, top = 0, bottom = 0 }
    })
    listPanel:SetBackdropColor(0.05, 0.05, 0.05, 0.8)
    listPanel:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)

    -- Search Box
    searchBox = CreateFrame("EditBox", nil, listPanel, "InputBoxTemplate")
    searchBox:SetSize(LIST_WIDTH - 70, 30)
    searchBox:SetPoint("TOPLEFT", listPanel, "TOPLEFT", 10, -10)
    searchBox:SetAutoFocus(false)
    searchBox:SetMaxLetters(50)
    searchBox:SetFontObject("GameFontNormal")
    searchBox:SetTextInsets(8, 8, 0, 0)
    
    -- Placeholder text
    local placeholderText = searchBox:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    placeholderText:SetPoint("LEFT", searchBox, "LEFT", 8, 0)
    placeholderText:SetText("Search items...")
    placeholderText:SetTextColor(0.5, 0.5, 0.5, 1)
    
    searchBox:SetScript("OnEditFocusGained", function(self)
        placeholderText:Hide()
    end)
    
    searchBox:SetScript("OnEditFocusLost", function(self)
        if self:GetText() == "" then
            placeholderText:Show()
        end
    end)
    
    searchBox:SetScript("OnTextChanged", function(self)
        local text = self:GetText()
        if text == "" then
            placeholderText:Show()
        else
            placeholderText:Hide()
        end
        currentSearchText = text
        RebuildItemList()
    end)
    
    -- Clear Button
    local clearBtn = CreateFrame("Button", nil, listPanel)
    clearBtn:SetSize(20, 20)
    clearBtn:SetPoint("LEFT", searchBox, "RIGHT", 5, 0)
    clearBtn:SetNormalTexture("Interface\\FriendsFrame\\ClearBroadcastIcon")
    clearBtn:SetHighlightTexture("Interface\\FriendsFrame\\ClearBroadcastIcon")
    clearBtn:SetScript("OnClick", function()
        searchBox:SetText("")
        searchBox:ClearFocus()
        placeholderText:Show()
        currentSearchText = ""
        RebuildItemList()
    end)
    clearBtn:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("Clear search")
        GameTooltip:Show()
    end)
    clearBtn:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    -- Scroll Frame for list
    scrollFrame = CreateFrame("ScrollFrame", "CraftpadScrollFrame", listPanel, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", listPanel, "TOPLEFT", 5, -50)
    scrollFrame:SetPoint("BOTTOMRIGHT", listPanel, "BOTTOMRIGHT", -25, 5)

    -- Scroll Child
    scrollChild = CreateFrame("Frame", nil, scrollFrame)
    scrollFrame:SetScrollChild(scrollChild)
    scrollChild:SetSize(LIST_WIDTH - 40, FRAME_HEIGHT - 150)

    -- RIGHT PANEL: Detail panel
    local detailPanel = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    detailPanel:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -20, -70)
    detailPanel:SetSize(DETAIL_WIDTH, FRAME_HEIGHT - 100)
    detailPanel:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        tile = false,
        edgeSize = 1,
        insets = { left = 0, right = 0, top = 0, bottom = 0 }
    })
    detailPanel:SetBackdropColor(0.05, 0.05, 0.05, 0.8)
    detailPanel:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)

    -- Detail panel content (initially empty)
    local detailContent = CreateFrame("ScrollFrame", nil, detailPanel)
    detailContent:SetPoint("TOPLEFT", detailPanel, "TOPLEFT", 5, -5)
    detailContent:SetPoint("BOTTOMRIGHT", detailPanel, "BOTTOMRIGHT", -5, 5)
    
    local detailScrollChild = CreateFrame("Frame", nil, detailContent)
    detailContent:SetScrollChild(detailScrollChild)
    detailScrollChild:SetSize(DETAIL_WIDTH - 10, FRAME_HEIGHT - 100)
    
    local defaultText = detailScrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    defaultText:SetPoint("CENTER", detailScrollChild, "CENTER", 0, 0)
    defaultText:SetText("Select an item to view\ncrafting details")
    defaultText:SetTextColor(0.6, 0.6, 0.6, 1)

    -- Function to update detail panel
    local function UpdateDetailPanel(itemData)
        -- Completely recreate the scroll child to clear all content
        detailScrollChild:Hide()
        detailScrollChild:SetParent(nil)
        detailScrollChild = CreateFrame("Frame", nil, detailContent)
        detailContent:SetScrollChild(detailScrollChild)
        detailScrollChild:SetSize(DETAIL_WIDTH - 10, FRAME_HEIGHT - 100)
        
        if not itemData then
            local newDefaultText = detailScrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            newDefaultText:SetPoint("CENTER", detailScrollChild, "CENTER", 0, 0)
            newDefaultText:SetText("Select an item to view\ncrafting details")
            newDefaultText:SetTextColor(0.6, 0.6, 0.6, 1)
            return
        end
        
        local yOffset = -15
        
        -- Item icon (large)
        local itemIcon = detailScrollChild:CreateTexture(nil, "ARTWORK")
        itemIcon:SetSize(48, 48)
        itemIcon:SetPoint("TOP", detailScrollChild, "TOP", 0, yOffset)
        if itemData.icon and itemData.icon ~= "N/A" then
            itemIcon:SetTexture(tonumber(itemData.icon))
        else
            itemIcon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
        end
        yOffset = yOffset - 55
        
        -- Item name
        local itemName = detailScrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
        itemName:SetPoint("TOP", detailScrollChild, "TOP", 0, yOffset)
        itemName:SetText(itemData.name)
        itemName:SetWidth(DETAIL_WIDTH - 20)
        itemName:SetWordWrap(true)
        yOffset = yOffset - 30
        
        -- Category
        local categoryText = detailScrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        categoryText:SetPoint("TOP", detailScrollChild, "TOP", 0, yOffset)
        categoryText:SetText(itemData.category)
        categoryText:SetTextColor(0.7, 0.7, 0.7, 1)
        yOffset = yOffset - 20
        
        -- Check if craftable
        if not itemData.profession or not itemData.reagents then
            local noCraftText = detailScrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            noCraftText:SetPoint("TOP", detailScrollChild, "TOP", 0, yOffset - 20)
            noCraftText:SetText("No crafting recipe available")
            noCraftText:SetTextColor(0.8, 0.5, 0.5, 1)
            return
        end
        
        -- Separator
        yOffset = yOffset - 10
        local separator1 = detailScrollChild:CreateTexture(nil, "ARTWORK")
        separator1:SetTexture("Interface\\Buttons\\WHITE8x8")
        separator1:SetSize(DETAIL_WIDTH - 30, 1)
        separator1:SetPoint("TOP", detailScrollChild, "TOP", 0, yOffset)
        separator1:SetColorTexture(0.4, 0.4, 0.4, 1)
        yOffset = yOffset - 15
        
        -- Profession section
        local profLabel = detailScrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        profLabel:SetPoint("TOPLEFT", detailScrollChild, "TOPLEFT", 15, yOffset)
        profLabel:SetText("Profession Required:")
        profLabel:SetTextColor(1, 0.82, 0, 1)
        yOffset = yOffset - 25
        
        -- Profession icon
        local profIcon = detailScrollChild:CreateTexture(nil, "ARTWORK")
        profIcon:SetSize(24, 24)
        profIcon:SetPoint("TOPLEFT", detailScrollChild, "TOPLEFT", 20, yOffset)
        profIcon:SetTexture("Interface\\Icons\\" .. itemData.profession.icon)
        
        -- Profession name and rank
        local profText = detailScrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        profText:SetPoint("LEFT", profIcon, "RIGHT", 10, 0)
        profText:SetText(itemData.profession.name .. " (Rank " .. itemData.profession.rank .. ")")
        yOffset = yOffset - 35
        
        -- Separator
        local separator2 = detailScrollChild:CreateTexture(nil, "ARTWORK")
        separator2:SetTexture("Interface\\Buttons\\WHITE8x8")
        separator2:SetSize(DETAIL_WIDTH - 30, 1)
        separator2:SetPoint("TOP", detailScrollChild, "TOP", 0, yOffset)
        separator2:SetColorTexture(0.4, 0.4, 0.4, 1)
        yOffset = yOffset - 15
        
        -- Materials section
        local matLabel = detailScrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        matLabel:SetPoint("TOPLEFT", detailScrollChild, "TOPLEFT", 15, yOffset)
        matLabel:SetText("Materials Required:")
        matLabel:SetTextColor(1, 0.82, 0, 1)
        yOffset = yOffset - 25
        
        -- Reagents list
        for _, reagent in ipairs(itemData.reagents) do
            -- Reagent icon
            local reagentIcon = detailScrollChild:CreateTexture(nil, "ARTWORK")
            reagentIcon:SetSize(20, 20)
            reagentIcon:SetPoint("TOPLEFT", detailScrollChild, "TOPLEFT", 25, yOffset)
            reagentIcon:SetTexture("Interface\\Icons\\" .. reagent.icon)
            
            -- Get current item count (bags + bank)
            local currentCount = GetItemCount(reagent.name, true) or 0
            local requiredCount = reagent.quantity
            
            -- Reagent name and quantity with current/required format
            local reagentText = detailScrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            reagentText:SetPoint("LEFT", reagentIcon, "RIGHT", 8, 0)
            reagentText:SetText(reagent.name .. " " .. currentCount .. "/" .. requiredCount)
            reagentText:SetWidth(DETAIL_WIDTH - 80)
            reagentText:SetJustifyH("LEFT")
            
            -- Apply color based on availability (green if enough, red if insufficient)
            if currentCount >= requiredCount then
                reagentText:SetTextColor(0.0, 1.0, 0.0, 1) -- Green
            else
                reagentText:SetTextColor(1.0, 0.3, 0.3, 1) -- Red
            end
            
            yOffset = yOffset - 25
        end
    end
    
    -- Function to create a single item row
    local function CreateItemRow(item, index)
        local row = CreateFrame("Button", nil, scrollChild, "BackdropTemplate")
        row:SetSize(LIST_WIDTH - 40, ROW_HEIGHT)
        row:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, -(index-1) * ROW_HEIGHT)
        row:SetBackdrop({
            bgFile = "Interface\\Buttons\\WHITE8x8",
        })
        
        -- Alternate row colors
        if index % 2 == 0 then
            row:SetBackdropColor(0.1, 0.1, 0.1, 0.3)
        else
            row:SetBackdropColor(0.2, 0.2, 0.2, 0.3)
        end
        
        row.normalColor = {row:GetBackdropColor()}
        row.hoverColor = {0.3, 0.3, 0.4, 0.5}
        row.selectedColor = {0.2, 0.4, 0.6, 0.7}
        row.itemData = item

        -- Icon
        local icon = row:CreateTexture(nil, "ARTWORK")
        icon:SetSize(ICON_SIZE, ICON_SIZE)
        icon:SetPoint("LEFT", row, "LEFT", 5, 0)
        
        if item.icon and item.icon ~= "N/A" then
            icon:SetTexture(tonumber(item.icon))
        else
            icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
        end

        -- Name text
        local text = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        text:SetPoint("LEFT", icon, "RIGHT", 8, 0)
        text:SetText(item.name)
        text:SetJustifyH("LEFT")
        text:SetWidth(LIST_WIDTH - 100)

        -- Hover effect
        row:SetScript("OnEnter", function(self)
            if self ~= selectedRow then
                self:SetBackdropColor(unpack(self.hoverColor))
            end
        end)
        
        row:SetScript("OnLeave", function(self)
            if self ~= selectedRow then
                self:SetBackdropColor(unpack(self.normalColor))
            end
        end)
        
        -- Click handler
        row:SetScript("OnClick", function(self)
            -- Deselect previous row
            if selectedRow then
                selectedRow:SetBackdropColor(unpack(selectedRow.normalColor))
            end
            
            -- Select this row
            selectedRow = self
            selectedItemData = item
            self:SetBackdropColor(unpack(self.selectedColor))
            
            -- Update detail panel
            UpdateDetailPanel(item)
        end)
        
        -- Re-select if this was the previously selected item
        if selectedItemData and selectedItemData.id == item.id then
            selectedRow = row
            row:SetBackdropColor(unpack(row.selectedColor))
        end
        
        return row
    end
    
    -- Function to rebuild the item list based on search
    function RebuildItemList()
        -- Clear existing rows
        for _, row in ipairs(itemRows) do
            row:Hide()
            row:SetParent(nil)
        end
        itemRows = {}
        selectedRow = nil
        
        -- Get filtered items
        local items = FilterItems(currentSearchText)
        
        -- Update item count
        local totalCount = Craftpad.Data.GetItemCount()
        if currentSearchText ~= "" then
            itemCount:SetText(#items .. " of " .. totalCount .. " items - Click an item to view crafting details")
        else
            itemCount:SetText(totalCount .. " items available - Click an item to view crafting details")
        end
        
        -- Handle no results
        if #items == 0 then
            scrollChild:SetSize(LIST_WIDTH - 40, 100)
            local noResultsText = scrollChild:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            noResultsText:SetPoint("CENTER", scrollChild, "CENTER", 0, 0)
            noResultsText:SetText("No items found")
            noResultsText:SetTextColor(0.6, 0.6, 0.6, 1)
            table.insert(itemRows, noResultsText)
            return
        end
        
        -- Update scroll child size
        scrollChild:SetSize(LIST_WIDTH - 40, ROW_HEIGHT * #items)
        
        -- Create rows for filtered items
        for i, item in ipairs(items) do
            local row = CreateItemRow(item, i)
            table.insert(itemRows, row)
        end
    end

    -- Initial population of the list
    RebuildItemList()

    Craftpad.UI.MainFrame = frame
    Craftpad.UI.UpdateDetailPanel = UpdateDetailPanel
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

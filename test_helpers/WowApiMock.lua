-- WoW API Mock for testing outside the game environment
-- This file mocks the essential WoW API functions needed for unit tests

local WowApiMock = {}

-- Mock global functions
_G.CreateFrame = function(frameType, name, parent, template)
    return {
        SetSize = function() end,
        SetPoint = function() end,
        SetBackdrop = function() end,
        SetBackdropColor = function() end,
        SetBackdropBorderColor = function() end,
        EnableMouse = function() end,
        SetMovable = function() end,
        RegisterForDrag = function() end,
        SetScript = function() end,
        StartMoving = function() end,
        StopMovingOrSizing = function() end,
        SetClampedToScreen = function() end,
        Hide = function() end,
        Show = function() end,
        IsShown = function() return false end,
        CreateFontString = function()
            return {
                SetPoint = function() end,
                SetText = function() end,
                SetTextColor = function() end,
                SetWidth = function() end,
                SetWordWrap = function() end,
                SetJustifyH = function() end,
            }
        end,
        CreateTexture = function()
            return {
                SetSize = function() end,
                SetPoint = function() end,
                SetTexture = function() end,
                SetColorTexture = function() end,
            }
        end,
        GetBackdropColor = function() return 0, 0, 0, 0 end,
    }
end

_G.UIParent = {}
_G.GameTooltip = {
    SetOwner = function() end,
    SetText = function() end,
    Show = function() end,
    Hide = function() end,
}

-- Mock print function for tests
_G.print = function(...) end

-- Mock item info functions
_G.GetItemInfo = function(itemID)
    return nil  -- Default returns nil, tests can override
end

_G.GetItemCount = function(itemNameOrID, includeBank)
    return 0
end

_G.C_Item = {
    GetItemCount = function(itemNameOrID, includeBank, includeUses, includeReagentBank, includeAccountBank)
        return 0
    end,
    GetItemInfo = function(itemID)
        return nil
    end,
}

-- Mock localization
_G.GetLocale = function()
    return "enUS"
end

return WowApiMock

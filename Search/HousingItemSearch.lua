-- Housing Item Search
-- Searches items by name, category, or profession (case-insensitive)

-- Create namespace
if not Craftpad then Craftpad = {} end
if not Craftpad.Search then Craftpad.Search = {} end

-- Case-insensitive substring search
local function _text_contains(text, search_text)
    if not text or not search_text then
        return false
    end

    local normalized_text = string.lower(text)
    local normalized_search = string.lower(search_text)
    return string.find(normalized_text, normalized_search, 1, true) ~= nil
end

-- Check if item matches search query
local function is_item_matching_query(item, query)
    if _text_contains(item.name, query) then
        return true
    end

    if _text_contains(item.category, query) then
        return true
    end

    if item.profession and _text_contains(item.profession.name, query) then
        return true
    end

    return false
end

-- Public API: search items by text
-- Empty query returns all items
function Craftpad.Search.search_items(items, query)
    if not query or query == "" then
        return items
    end

    local matching_items = {}

    for _, item in ipairs(items) do
        if is_item_matching_query(item, query) then
            table.insert(matching_items, item)
        end
    end

    return matching_items
end


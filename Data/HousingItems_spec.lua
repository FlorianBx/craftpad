-- Tests for Data/HousingItems.lua
-- Tests the data layer which is already exposed via public API

describe("HousingItems Data Layer", function()
    before_each(function()
        -- Initialize Craftpad global namespace (must be done before loading HousingItems.lua)
        _G.Craftpad = {}
        _G.Craftpad.Data = {}

        -- Load the actual HousingItems module (which populates Craftpad.Data.HousingItems)
        dofile("Data/HousingItems.lua")
    end)

    describe("GetHousingItems", function()
        it("returns an array", function()
            local items = Craftpad.Data.GetHousingItems()
            assert.is_table(items)
        end)

        it("returns items with correct structure", function()
            local items = Craftpad.Data.GetHousingItems()
            assert.is_true(#items > 0, "Should have at least one item")

            local firstItem = items[1]
            assert.is_not_nil(firstItem.id)
            assert.is_not_nil(firstItem.name)
            assert.is_not_nil(firstItem.icon)
            assert.is_not_nil(firstItem.category)
        end)

        it("returns items with profession data", function()
            local items = Craftpad.Data.GetHousingItems()

            -- Find an item with profession
            local itemWithProf = nil
            for _, item in ipairs(items) do
                if item.profession then
                    itemWithProf = item
                    break
                end
            end

            assert.is_not_nil(itemWithProf, "Should have at least one item with profession")
            assert.is_not_nil(itemWithProf.profession.name)
            assert.is_not_nil(itemWithProf.profession.icon)
            assert.is_not_nil(itemWithProf.profession.rank)
        end)

        it("returns items with reagents data", function()
            local items = Craftpad.Data.GetHousingItems()

            -- Find an item with reagents
            local itemWithReagents = nil
            for _, item in ipairs(items) do
                if item.reagents and #item.reagents > 0 then
                    itemWithReagents = item
                    break
                end
            end

            assert.is_not_nil(itemWithReagents, "Should have at least one item with reagents")

            local firstReagent = itemWithReagents.reagents[1]
            assert.is_not_nil(firstReagent.name)
            assert.is_not_nil(firstReagent.icon)
            assert.is_not_nil(firstReagent.quantity)
            assert.is_not_nil(firstReagent.quality)
        end)
    end)

    describe("GetItemCount", function()
        it("returns a number", function()
            local count = Craftpad.Data.GetItemCount()
            assert.is_number(count)
        end)

        it("matches the array length", function()
            local items = Craftpad.Data.GetHousingItems()
            local count = Craftpad.Data.GetItemCount()
            assert.are.equal(#items, count)
        end)

        it("returns a positive number", function()
            local count = Craftpad.Data.GetItemCount()
            assert.is_true(count > 0, "Should have at least one item")
        end)
    end)

    describe("Data Integrity", function()
        it("all items have unique IDs", function()
            local items = Craftpad.Data.GetHousingItems()
            local ids = {}

            for _, item in ipairs(items) do
                assert.is_nil(ids[item.id], "Duplicate ID found: " .. item.id)
                ids[item.id] = true
            end
        end)

        it("all items have required fields", function()
            local items = Craftpad.Data.GetHousingItems()

            for _, item in ipairs(items) do
                assert.is_number(item.id, "Item missing id: " .. (item.name or "unknown"))
                assert.is_string(item.name, "Item missing name")
                assert.is_string(item.icon, "Item " .. item.name .. " missing icon")
                assert.is_string(item.category, "Item " .. item.name .. " missing category")
            end
        end)

        it("all reagents have valid quality values", function()
            local items = Craftpad.Data.GetHousingItems()
            local validQualities = {[0]=true, [1]=true, [2]=true, [3]=true, [4]=true}

            for _, item in ipairs(items) do
                if item.reagents then
                    for _, reagent in ipairs(item.reagents) do
                        assert.is_true(
                            validQualities[reagent.quality],
                            "Invalid quality for reagent " .. reagent.name .. ": " .. tostring(reagent.quality)
                        )
                    end
                end
            end
        end)

        it("all items with professions have valid rank", function()
            local items = Craftpad.Data.GetHousingItems()

            for _, item in ipairs(items) do
                if item.profession then
                    assert.is_number(item.profession.rank, "Profession rank must be a number for " .. item.name)
                    assert.is_true(item.profession.rank >= 0, "Profession rank must be >= 0 for " .. item.name)
                end
            end
        end)
    end)
end)

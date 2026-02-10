-- Tests for HousingItemSearch module

describe("HousingItemSearch", function()
    local TestFixtures
    
    before_each(function()
        -- Initialize Craftpad global namespace
        _G.Craftpad = {}
        _G.Craftpad.Search = {}
        
        -- Load test fixtures
        TestFixtures = require("test_helpers.TestFixtures")
        
        -- Load the search module (which populates Craftpad.Search)
        dofile("Search/HousingItemSearch.lua")
    end)
    
    describe("search_items", function()
        it("returns all items when query is empty string", function()
            local result = Craftpad.Search.search_items(TestFixtures.sampleItems, "")
            assert.are.equal(#TestFixtures.sampleItems, #result)
        end)
        
        it("returns all items when query is nil", function()
            local result = Craftpad.Search.search_items(TestFixtures.sampleItems, nil)
            assert.are.equal(#TestFixtures.sampleItems, #result)
        end)
        
        it("finds items by name case-insensitively", function()
            local result = Craftpad.Search.search_items(TestFixtures.sampleItems, "POSTBOX")
            assert.is_true(#result > 0)
            assert.is_true(string.find(string.lower(result[1].name), "postbox") ~= nil)
        end)
        
        it("finds items by partial name match", function()
            local result = Craftpad.Search.search_items(TestFixtures.sampleItems, "Drape")
            assert.is_true(#result > 0)
            for _, item in ipairs(result) do
                assert.is_true(string.find(string.lower(item.name), "drape") ~= nil)
            end
        end)
        
        it("finds items by category", function()
            local result = Craftpad.Search.search_items(TestFixtures.sampleItems, "Wall Hangings")
            assert.is_true(#result > 0)
            for _, item in ipairs(result) do
                assert.are.equal("Wall Hangings", item.category)
            end
        end)
        
        it("finds items by partial category", function()
            local result = Craftpad.Search.search_items(TestFixtures.sampleItems, "Wall")
            assert.is_true(#result > 0)
            for _, item in ipairs(result) do
                assert.is_true(string.find(string.lower(item.category), "wall") ~= nil)
            end
        end)
        
        it("finds items by profession name", function()
            local result = Craftpad.Search.search_items(TestFixtures.sampleItems, "Tailoring")
            assert.is_true(#result > 0)
            for _, item in ipairs(result) do
                assert.is_not_nil(item.profession)
                assert.is_true(string.find(string.lower(item.profession.name), "tailoring") ~= nil)
            end
        end)
        
        it("finds items by partial profession name", function()
            local result = Craftpad.Search.search_items(TestFixtures.sampleItems, "Tailor")
            assert.is_true(#result > 0)
        end)
        
        it("returns empty array when no items match", function()
            local result = Craftpad.Search.search_items(TestFixtures.sampleItems, "xyz123notfound")
            assert.are.equal(0, #result)
            assert.is_table(result)
        end)
        
        it("handles special characters without crashing", function()
            assert.has_no.errors(function()
                Craftpad.Search.search_items(TestFixtures.sampleItems, "!@#$%^&*()")
            end)
        end)
        
        it("handles empty items array", function()
            local result = Craftpad.Search.search_items({}, "test")
            assert.are.equal(0, #result)
        end)
        
        it("is case-insensitive for all fields", function()
            local result_lower = Craftpad.Search.search_items(TestFixtures.sampleItems, "gilnean")
            local result_upper = Craftpad.Search.search_items(TestFixtures.sampleItems, "GILNEAN")
            local result_mixed = Craftpad.Search.search_items(TestFixtures.sampleItems, "GiLnEaN")
            
            assert.are.equal(#result_lower, #result_upper)
            assert.are.equal(#result_lower, #result_mixed)
        end)
    end)
end)

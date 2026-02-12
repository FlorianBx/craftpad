-- Test fixtures: Sample housing items data for testing
-- This mirrors the structure of real housing items but with minimal data

local TestFixtures = {}

TestFixtures.sampleItems = {
    {
        id = 1,
        name = "Gilnean Postbox",
        icon = "7493997",
        category = "Miscellaneous",
        profession = {
            name = "Cataclysm Inscription",
            icon = "ui_profession_inscription",
            rank = 60
        },
        reagents = {
            { name = "Ashwood Lumber", icon = "ui_resourcelumbercataclysm", quantity = 35, quality = 2 },
            { name = "Elementium Bar", icon = "inv_misc_pyriumbar", quantity = 12, quality = 1 },
        }
    },
    {
        id = 2,
        name = "Grand Drape of the Exiles",
        icon = "7472222",
        category = "Wall Hangings",
        profession = {
            name = "Outland Tailoring",
            icon = "ui_profession_tailoring",
            rank = 60
        },
        reagents = {
            { name = "Olemba Lumber", icon = "ui_resourcelumberburningcrusade", quantity = 18, quality = 2 },
        }
    },
    {
        id = 3,
        name = "Kirin Tor Skyline Banner",
        icon = "7467933",
        category = "Wall Hangings",
        profession = {
            name = "Northrend Tailoring",
            icon = "ui_profession_tailoring",
            rank = 60
        },
        reagents = {
            { name = "Spellweave", icon = "inv_fabric_spellweave", quantity = 8, quality = 3 },
        }
    },
    {
        id = 4,
        name = "Jade Temple Dragon Fountain",
        icon = "7423240",
        category = "Large Structures",
        profession = {
            name = "Pandaria Jewelcrafting",
            icon = "ui_profession_jewelcrafting",
            rank = 60
        },
        reagents = {
            { name = "Trillium Bar", icon = "inv_ingot_trillium", quantity = 30, quality = 2 },
        }
    },
    {
        id = 5,
        name = "Simple Chair",
        icon = "123456",
        category = "Furniture",
        profession = {
            name = "Carpentry",
            icon = "ui_profession_carpentry",
            rank = 1
        },
        reagents = {
            { name = "Wood", icon = "inv_wood", quantity = 10, quality = 1 },
        }
    },
}

-- Item without profession (edge case)
TestFixtures.itemWithoutProfession = {
    id = 99,
    name = "Mystery Box",
    icon = "999999",
    category = "Mystery",
}

return TestFixtures

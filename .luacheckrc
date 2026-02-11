-- Luacheck configuration for Craftpad WoW addon
std = "lua51"
codes = true
max_line_length = 120

-- WoW API globals (read-only)
read_globals = {
    "CreateFrame", "UIParent", "GameTooltip", "GameTooltip_SetDefaultAnchor",
    "Minimap", "GetCursorPosition",
    "GetItemCount", "C_Item",
    "UnitAffectingCombat",
    "Enum",
    "unpack",
}

-- Craftpad addon globals (writable)
globals = {
    "Craftpad",
    "SLASH_CRAFTPAD1", "SLASH_CRAFTPAD2", "SLASH_CP1",
    "SlashCmdList",
}

-- Ignore only genuinely acceptable warnings
ignore = {
    "211/TestFixtures",  -- Unused in test - might be used later
}

-- Test files
files["**/*_spec.lua"] = {
    read_globals = {"describe", "it", "before_each", "after_each", "assert", "spy", "stub", "mock"}
}

-- Test helpers can define globals
files["test_helpers/**/*.lua"] = {
    allow_defined_top = true,
    ignore = {"212"},  -- Unused arguments in mocks is OK
}

-- Auto-generated data - relax line length only
files["Data/HousingItems.lua"] = {
    max_line_length = 200,
}

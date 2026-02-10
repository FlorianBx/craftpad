# Craftpad - Copilot Instructions

## Project Overview

Craftpad is a World of Warcraft addon that provides a searchable database of housing items with crafting details. It displays items in a split-view UI: a filterable list on the left and detailed crafting information on the right.

## Code Style

Follow the `/lua-clean` command principles:

**Priority:** PRAGMATIC > KISS > GOOD PRACTICES > CLEAN CODE > WET > DRY > SOLID

- Comments only on complex code
- Self-documenting code preferred
- Accept duplication up to 2 times, extract only if > 2

### Naming (Domain-Specific)

Use names that reveal intention:

- ❌ Avoid: `FilterLogic`, `DataAccess`, `Manager`, `Helper`
- ✅ Prefer: `HousingItemSearch`, `HousingItemCollection`
- ❌ Avoid: `FilterItems()`, `ItemMatches()`
- ✅ Prefer: `SearchItems()`, `IsItemMatchingQuery()`

### Module Organization

- **Local functions** for internal implementation
- **Namespace functions** for public API (e.g., `Craftpad.UI.CreateMainFrame`)
- **Constants** in SCREAMING_SNAKE_CASE at top of file
- **Private state** as local variables (closures)

---

## Architecture

### Global Namespace Pattern

Single global namespace `Craftpad` with sub-namespaces:

- `Craftpad.Data` - Data access layer
- `Craftpad.UI` - UI components
- `Craftpad.Version` - Version string

```lua
-- Core.lua pattern
Craftpad = {}
Craftpad.SubNamespace = {}
```

### File Load Order (Craftpad.toc)

Files load in this order:

1. `Core.lua` - Global namespace and event handlers
2. `Data\HousingItems.lua` - Auto-generated data (~5000 lines)
3. `UI\MainFrame.lua` - Main UI with search and detail panels
4. `UI\MinimapButton.lua` - Minimap button
5. `Commands.lua` - Slash command handlers

**Critical:** New files must be added to `Craftpad.toc` in correct dependency order.

### Data Layer

`Data/HousingItems.lua` is **auto-generated from data.json** - do not edit manually.

```lua
Craftpad.Data.HousingItems      -- Array of items
Craftpad.Data.GetHousingItems() -- Returns full array
Craftpad.Data.GetItemCount()    -- Returns count
```

Item structure:

```lua
{
    id = number,
    name = string,
    icon = string,
    category = string,
    profession = { name, icon, rank },
    reagents = { { name, icon, quantity, quality }, ... }
}
```

### UI Architecture

`UI/MainFrame.lua` contains:

- **FilterItems(searchText)** - Filters by name, category, or profession
- **CreateMainFrame()** - Builds split-view UI
- **RebuildItemList()** - Rebuilds visible items based on search

Components:

- Left panel: Scrolling item list with search
- Right panel: Selected item's crafting details
- Search box with real-time filtering and clear button

---

## WoW API Conventions

- `CreateFrame()` for all UI elements
- Event handlers via `SetScript("OnEvent", ...)`
- Quality colors: 0-4 scale (Poor, Common, Uncommon, Rare, Epic)

### Event Registration

```lua
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(self, event, addonName)
    if event == "ADDON_LOADED" and addonName == "craftpad" then
        -- Initialize
    end
end)
```

### Slash Commands

```lua
SLASH_COMMANDNAME1 = "/command"
SlashCmdList["COMMANDNAME"] = function(msg)
    -- Handle command
end
```

### Search Pattern

```lua
-- Case-insensitive literal substring match
string.find(string.lower(text), string.lower(query), 1, true)
```

---

## Testing Strategy

Test-first, refactor-after approach using **Busted** (Lua BDD framework).

### Infrastructure

- Test files: `*_spec.lua` (colocated with source)
- Test helpers: `test_helpers/` for WoW API mocks
- Config: `.busted`

### Critical Functions to Test

- `FilterItems()` - Search logic
- `Craftpad.Data.GetHousingItems()` - Data retrieval
- `Craftpad.Data.GetItemCount()` - Item counting
- Edge cases: empty search, no matches, special characters

### WoW API Mocking

Mock `CreateFrame()`, `UIParent`, `GameTooltip`. Focus tests on **pure business logic**, not UI rendering.

### Commands

```bash
# Install
luarocks install busted

# Run
busted
```

### In-Game Testing

```bash
/reload        # Reload UI after changes
/craftpad      # Open addon (or /cp)
```

---

## Planned Refactoring

Extract search logic after tests are in place:

```
Search/
  HousingItemSearch.lua
  HousingItemSearch_spec.lua
```

Current `FilterItems()` in `MainFrame.lua` will move to a testable `Search` module.
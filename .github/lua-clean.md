# Lua Clean Code

Write clean, pragmatic Lua code following these principles (in priority order):

1. **PRAGMATIC** - Solve the problem effectively
2. **KISS** - Keep it simple
3. **GOOD PRACTICES** - Follow Lua conventions
4. **CLEAN CODE** - Readable and maintainable
5. **WET** - Accept duplication up to 2 times
6. **DRY** - Extract only if repeated > 2 times
7. **SOLID** - Apply with discernment, not dogmatically

## Comments

Only comment complex code that is hard to understand. Prefer self-documenting code.

```lua
-- ❌ BAD: Obvious
-- Increment counter
counter = counter + 1

-- ✅ GOOD: Explains WHY
-- Binary search needed: list is sorted with 10k+ items
local index = binary_search(sorted_items, target)
```

## Naming

- Variables/functions: `snake_case`
- Constants: `SCREAMING_SNAKE_CASE`
- Modules/Classes: `PascalCase`
- Private: `_underscore_prefix`

## Rules

- ALWAYS use `local`
- Early return over nested `if`
- Functions < 30 lines
- Max 2 levels of nesting
- Use `ipairs` for arrays, `pairs` for dictionaries
- Return `nil, error_message` for errors
- Use `pcall` for risky operations
- Named constants over magic numbers

## Module Pattern

```lua
local M = {}

local CONSTANT = 100

local function _private()
end

function M.public()
end

return M
```

## Class Pattern

```lua
local Player = {}
Player.__index = Player

function Player.new(name)
    local self = setmetatable({}, Player)
    self.name = name or "Unknown"
    return self
end

function Player:method()
end

return Player
```

## Avoid

- Implicit globals
- Complex one-liners
- Deep nesting (> 2 levels)
- Magic numbers
- Strings as structured data
- Dead/commented-out code
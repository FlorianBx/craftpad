# Craftpad

[![Tests](https://github.com/florianbx/Craftpad/actions/workflows/test.yml/badge.svg)](https://github.com/florianbx/Craftpad/actions/workflows/test.yml)

A World of Warcraft addon that provides a searchable database of housing items with crafting details.

## Features

- **Real-time search** - Filter items by name, category, or profession
- **Split-view UI** - Browse items on the left, see crafting details on the right
- **Quality colors** - Items and reagents use WoW's standard quality colors
- **Fast filtering** - Instant results as you type

## Usage

In-game commands:
```
/craftpad  or  /cp     - Toggle the addon window
/craftpad help         - Show help
```

## Development

### Running Tests

```bash
make test
```

Tests are automatically run on every push via GitHub Actions.

### Project Structure

```
Craftpad/
├── Core.lua              - Global namespace and event handlers
├── Data/
│   ├── HousingItems.lua  - Auto-generated from data.json
│   └── HousingItems_spec.lua
├── UI/
│   ├── MainFrame.lua     - Main UI with search and detail panels
│   └── MinimapButton.lua
├── Commands.lua          - Slash command handlers
└── test_helpers/         - Test mocks and fixtures
```

## License

MIT

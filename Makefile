.PHONY: test test-watch lint help

# Default target
help:
	@echo "Craftpad Makefile"
	@echo ""
	@echo "Available targets:"
	@echo "  make test        - Run all tests"
	@echo "  make lint        - Run luacheck linter"
	@echo "  make check       - Run both linter and tests"
	@echo "  make test-watch  - Run tests in watch mode"
	@echo "  make help        - Show this help"

# Run linter (strict mode: fail on warnings)
lint:
	@echo "Running luacheck..."
	@luacheck . --no-color

# Run all tests
test:
	@echo "Running Craftpad Tests..."
	@busted --verbose

# Run both linter and tests
check: lint test
	@echo "✓ All checks passed!"

# Run tests in watch mode (requires entr or similar)
test-watch:
	@echo "Watching for changes..."
	@find . -name "*_spec.lua" -o -name "*.lua" | entr -c make test

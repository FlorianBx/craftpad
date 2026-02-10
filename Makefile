.PHONY: test test-watch help

# Default target
help:
	@echo "Craftpad Makefile"
	@echo ""
	@echo "Available targets:"
	@echo "  make test        - Run all tests"
	@echo "  make test-watch  - Run tests in watch mode"
	@echo "  make help        - Show this help"

# Run all tests
test:
	@echo "Running Craftpad Tests..."
	@busted --verbose

# Run tests in watch mode (requires entr or similar)
test-watch:
	@echo "Watching for changes..."
	@find . -name "*_spec.lua" -o -name "*.lua" | entr -c make test

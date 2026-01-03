# Lean 4 Workshop Makefile
SHELL := /usr/local/bin/bash

.PHONY: help deps check build clean

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

deps: ## Check Lean 4 toolchain dependencies
	@echo "=== Lean 4 Toolchain Dependencies ==="
	@echo ""
	@echo "lean:"
	@which lean 2>/dev/null && lean --version || echo "  NOT FOUND - Install via elan or package manager"
	@echo ""
	@echo "lake:"
	@which lake 2>/dev/null && lake --version || echo "  NOT FOUND - Comes with Lean 4"
	@echo ""
	@echo "elan (optional version manager):"
	@which elan 2>/dev/null && elan --version || echo "  NOT FOUND - Install from https://github.com/leanprover/elan"
	@echo ""
	@echo "=== Editor Support ==="
	@echo "VS Code + lean4 extension recommended"
	@echo "Emacs + lean4-mode available"
	@echo ""

check: ## Verify Lean installation works
	@echo 'def main : IO Unit := IO.println "Hello, Lean 4"' | lean --stdin

build: ## Build the project with Lake
	lake build

clean: ## Clean build artifacts
	lake clean

.PHONY: help check build test update clean install run

help: ## Show this help message
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

check: ## Check flake validity
	NIXPKGS_ALLOW_UNFREE=1 nix flake check --impure

build: ## Build the package
	NIXPKGS_ALLOW_UNFREE=1 nix build --impure

test: build ## Build and test the binary
	@echo "Testing Antigravity binary..."
	./result/bin/antigravity --version
	./result/bin/antigravity --help | head -20

update: ## Run update script to check for new versions
	./scripts/update.sh

clean: ## Clean build artifacts
	rm -rf result result-*

install: ## Install to user profile
	NIXPKGS_ALLOW_UNFREE=1 nix profile install . --impure

run: ## Run antigravity directly
	NIXPKGS_ALLOW_UNFREE=1 nix run . --impure

shell: ## Enter development shell
	NIXPKGS_ALLOW_UNFREE=1 nix develop --impure

fmt: ## Format Nix files
	nix fmt

lint: ## Lint shell scripts
	shellcheck scripts/*.sh

all: check build test ## Run check, build, and test

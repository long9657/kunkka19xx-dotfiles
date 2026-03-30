.PHONY: brew-update brew-lock brew-install brew-check brew-clean

BREWFILE := $(dir $(lastword $(MAKEFILE_LIST)))Brewfile
LOCKFILE := $(dir $(lastword $(MAKEFILE_LIST)))Brewfile.lock.json

brew-update: ## Update Brewfile with current packages
	@echo "Updating Brewfile..."
	brew bundle dump --force --file=$(BREWFILE)
	@echo "Brewfile updated at $(BREWFILE)"

brew-lock: ## Create lock file with exact versions
	@echo "Creating lock file..."
	brew bundle dump --force --file=$(BREWFILE)
	@echo "Lock file created at $(LOCKFILE)"

brew-install: ## Install packages from lock file
	@echo "Installing packages from lock file..."
	brew bundle install --file=$(LOCKFILE)

brew-check: ## Check if packages match lock file
	@echo "Checking packages against lock file..."
	brew bundle check --file=$(LOCKFILE) || true

brew-clean: ## Remove packages not in Brewfile
	@echo "Removing packages not in Brewfile..."
	brew bundle cleanup --force --file=$(BREWFILE)

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

# Makefile for literate-monero
# Selective org-mode tangling with dependency tracking

ORG_DIR := org
ANSIBLE_DIR := ansible
FRAGMENTS_DIR := $(ANSIBLE_DIR)/fragments
GROUP_VARS_DIR := $(ANSIBLE_DIR)/group_vars

# Phase org files that create fragments (10-98, excluding 99)
PHASE_ORGS := $(filter-out $(ORG_DIR)/99-%.org,$(wildcard $(ORG_DIR)/[1-9][0-9]-*.org))

# Generated fragments (same names as org files)
FRAGMENTS := $(patsubst $(ORG_DIR)/%.org,$(FRAGMENTS_DIR)/%.yml,$(PHASE_ORGS))

# Special files that don't follow the pattern
CONFIG_ORG := $(ORG_DIR)/00-configuration.org
VALIDATE_ORG := $(ORG_DIR)/01-validation.org

CONFIGS := $(ANSIBLE_DIR)/ansible.cfg \
           $(ANSIBLE_DIR)/inventory.yml \
           $(GROUP_VARS_DIR)/all.yml

VALIDATE := $(ANSIBLE_DIR)/validate.yml

# Final playbook
PLAYBOOK := $(ANSIBLE_DIR)/playbook.yml

.PHONY: all clean show

all: $(PLAYBOOK)

# Tangle phase org files to fragments
$(FRAGMENTS_DIR)/%.yml: $(ORG_DIR)/%.org | $(FRAGMENTS_DIR)
	@echo "Tangling $< to $@..."
	@emacs --batch \
		--eval "(setq org-src-preserve-indentation t)" \
		--eval "(require 'org)" \
		--eval "(find-file \"$<\")" \
		--eval "(org-babel-tangle)"

# Tangle configuration from 00-configuration.org
$(CONFIGS): $(CONFIG_ORG) | $(GROUP_VARS_DIR)
	@echo "Tangling configuration..."
	@emacs --batch \
		--eval "(setq org-src-preserve-indentation t)" \
		--eval "(require 'org)" \
		--eval "(find-file \"$<\")" \
		--eval "(org-babel-tangle)"

# Tangle validation from 01-validation.org
$(VALIDATE): $(VALIDATE_ORG)
	@echo "Tangling validation..."
	@emacs --batch \
		--eval "(setq org-src-preserve-indentation t)" \
		--eval "(require 'org)" \
		--eval "(find-file \"$<\")" \
		--eval "(org-babel-tangle)"

# Ensure directories exist
$(FRAGMENTS_DIR) $(GROUP_VARS_DIR):
	@mkdir -p $@

# Assemble playbook from all fragments
$(PLAYBOOK): $(FRAGMENTS) $(CONFIGS)
	@echo "Assembling playbook..."
	@$(ANSIBLE_DIR)/assemble-playbook.sh

clean:
	rm -f $(FRAGMENTS_DIR)/*.yml
	rm -f $(PLAYBOOK)
	rm -f $(CONFIGS)
	rm -f $(VALIDATE)

show:
	@echo "Phase orgs: $(PHASE_ORGS)"
	@echo ""
	@echo "Fragments: $(FRAGMENTS)"
	@echo ""
	@echo "Config org: $(CONFIG_ORG)"
	@echo "Validate org: $(VALIDATE_ORG)"

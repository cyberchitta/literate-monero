# Makefile for literate-monero
# Selective org-mode tangling with dependency tracking

ORG_DIR := org
ANSIBLE_DIR := ansible
FRAGMENTS_DIR := $(ANSIBLE_DIR)/fragments
CONFIGS_DIR := configs/templates
GROUP_VARS_DIR := $(ANSIBLE_DIR)/group_vars

# All org source files
ORG_FILES := $(wildcard $(ORG_DIR)/*.org)

# Generated fragment files (one per phase org file)
# Exclude install.org and 99-appendix.org (they don't generate fragments)
PHASE_ORGS := $(filter-out $(ORG_DIR)/install.org $(ORG_DIR)/99-appendix.org,$(ORG_FILES))
FRAGMENTS := $(patsubst $(ORG_DIR)/%.org,$(FRAGMENTS_DIR)/%.yml,$(PHASE_ORGS))

# Configuration files generated from 00-configuration.org
CONFIGS := $(ANSIBLE_DIR)/ansible.cfg \
           $(ANSIBLE_DIR)/inventory.yml \
           $(GROUP_VARS_DIR)/all.yml

# Final playbook
PLAYBOOK := $(ANSIBLE_DIR)/playbook.yml

.PHONY: all clean playbook fragments

all: $(PLAYBOOK)

# Tangle specific org file to its fragment
$(FRAGMENTS_DIR)/%.yml: $(ORG_DIR)/%.org | $(FRAGMENTS_DIR)
	@echo "Tangling $<..."
	@emacs --batch \
		--eval "(setq org-src-preserve-indentation t)" \
		--eval "(require 'org)" \
		--eval "(find-file \"$<\")" \
		--eval "(org-babel-tangle)"

# Tangle configuration files from 00-configuration.org
$(CONFIGS): $(ORG_DIR)/00-configuration.org | $(GROUP_VARS_DIR)
	@echo "Tangling configuration from $<..."
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

# For debugging: show what would be built
show:
	@echo "Org files: $(ORG_FILES)"
	@echo "Phase orgs: $(PHASE_ORGS)"
	@echo "Fragments: $(FRAGMENTS)"
	@echo "Configs: $(CONFIGS)"

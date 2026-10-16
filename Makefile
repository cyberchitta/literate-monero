# Makefile for literate-monero
# Selective org-mode tangling with dependency tracking.
#
# This is the one tangle entry point: tangle.sh and the update scripts call
# `make clean all`. Each org file is tangled as a unit (it can write a
# fragment, config files and configs/templates/*), and a stamp under
# $(STAMP_DIR) records when, so an org edit re-tangles only that file.

ORG_DIR := org
ANSIBLE_DIR := ansible
FRAGMENTS_DIR := $(ANSIBLE_DIR)/fragments
GROUP_VARS_DIR := $(ANSIBLE_DIR)/group_vars
TEMPLATES_DIR := configs/templates
STAMP_DIR := .tangled

# Every org file with tangle targets: 00-98 (99 is reference only) + install
TANGLE_ORGS := $(filter-out $(ORG_DIR)/99-%.org,$(wildcard $(ORG_DIR)/[0-9][0-9]-*.org)) \
               $(ORG_DIR)/install.org
STAMPS := $(patsubst $(ORG_DIR)/%.org,$(STAMP_DIR)/%.stamp,$(TANGLE_ORGS))

PLAYBOOK := $(ANSIBLE_DIR)/playbook.yml
DEV_IMAGE := literate-monero-dev

.PHONY: all clean show check check-drift docker-image docker-check

all: $(PLAYBOOK)

# Tangle one org file. The only place Emacs is invoked.
$(STAMP_DIR)/%.stamp: $(ORG_DIR)/%.org | $(STAMP_DIR) $(FRAGMENTS_DIR) $(GROUP_VARS_DIR) $(TEMPLATES_DIR)
	@echo "Tangling $<..."
	@emacs --batch \
		--eval "(setq org-src-preserve-indentation t)" \
		--eval "(require 'org)" \
		--eval "(find-file \"$<\")" \
		--eval "(org-babel-tangle)"
	@touch $@

# Assemble playbook.yml from the phase fragments. config.yml is not read here,
# but the playbook is useless without it, so its absence stops the build.
$(PLAYBOOK): $(STAMPS) | config.yml
	@echo "Assembling playbook..."
	@$(ANSIBLE_DIR)/assemble-playbook.sh

config.yml:
	@echo "config.yml is missing: cp config.yml.example config.yml, then edit it"
	@exit 1

$(STAMP_DIR) $(FRAGMENTS_DIR) $(GROUP_VARS_DIR) $(TEMPLATES_DIR):
	@mkdir -p $@

# Static checks on the generated files: Ansible syntax, yamllint, shellcheck
# on rendered templates (linters are skipped with a warning if not installed)
check: all
	@dev/check.sh

# Re-tangle into a scratch copy and diff against this tree's generated files
check-drift:
	@dev/check-drift.sh

# Tangle + check inside the dev container (dev/Dockerfile), for non-Linux hosts.
# The repo is mounted read-only and the run has no network.
docker-image:
	docker build -t $(DEV_IMAGE) dev

docker-check: docker-image
	docker run --rm --network none -v "$(CURDIR)":/src:ro $(DEV_IMAGE) /src/dev/container-check.sh

clean:
	rm -rf $(STAMP_DIR)
	rm -f $(FRAGMENTS_DIR)/*.yml
	rm -f $(PLAYBOOK) $(ANSIBLE_DIR)/validate.yml
	rm -f $(ANSIBLE_DIR)/ansible.cfg $(ANSIBLE_DIR)/inventory.yml $(GROUP_VARS_DIR)/all.yml
	rm -f $(ANSIBLE_DIR)/assemble-playbook.sh
	rm -f $(TEMPLATES_DIR)/*.j2
	rm -f $(ANSIBLE_DIR)/tangle-all.sh .config-tangled  # left by older builds

show:
	@echo "Tangled orgs: $(TANGLE_ORGS)"

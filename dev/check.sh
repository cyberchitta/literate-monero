#!/bin/bash
# Static checks on the generated files (`make check`, after `make all`):
#   1. ansible-playbook --syntax-check on playbook.yml and validate.yml
#   2. yamllint on the assembled YAML (.yamllint)
#   3. every configs/templates/*.j2 rendered with the real variables
#      (dev/render-templates.yml), then shellcheck on the shell scripts
# yamllint and shellcheck are skipped with a warning when not installed
# (the box has neither; the dev container has both). Nothing touches the
# network or the system: rendering writes only under $RENDER_DIR.

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

cd "$(dirname "${BASH_SOURCE[0]}")/.."
RENDER_DIR=/tmp/literate-monero-rendered
export ANSIBLE_CONFIG="$PWD/ansible/ansible.cfg"

step() { echo -e "\n${GREEN}== $1${NC}"; }
skip() { echo -e "${YELLOW}skipped: $1 not installed${NC}"; }

step "Ansible syntax-check"
(cd ansible && ansible-playbook playbook.yml --syntax-check)
(cd ansible && ansible-playbook validate.yml --syntax-check)

step "yamllint"
if command -v yamllint >/dev/null; then
    yamllint -c .yamllint ansible/playbook.yml ansible/validate.yml \
        ansible/inventory.yml ansible/group_vars/all.yml
    echo "ok"
else
    skip yamllint
fi

step "Render templates"
ansible-playbook -i localhost, dev/render-templates.yml -e "render_dir=$RENDER_DIR" > /tmp/literate-monero-render.log \
    || { cat /tmp/literate-monero-render.log; echo -e "${RED}template rendering failed${NC}"; exit 1; }
echo "rendered $(find "$RENDER_DIR" -type f | wc -l) templates"

step "shellcheck (warning and above)"
if command -v shellcheck >/dev/null; then
    scripts=()
    for f in "$RENDER_DIR"/*; do
        head -1 "$f" | grep -qE '^#!.*\b(ba)?sh\b' && scripts+=("$f")
    done
    shellcheck -S warning "${scripts[@]}"
    echo "ok: ${#scripts[@]} scripts"
else
    skip shellcheck
fi

echo -e "\n${GREEN}All checks passed${NC}"

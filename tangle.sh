#!/bin/bash
# Tangle org files and assemble Ansible playbook

set -euo pipefail

echo "=== Tangling install.org to generate build scripts ==="
emacs --batch \
  --eval "(setq org-src-preserve-indentation t)" \
  --eval "(require 'org)" \
  --eval "(find-file \"org/install.org\")" \
  --eval "(org-babel-tangle)"

echo ""
echo "=== Tangling all org files to generate Ansible fragments ==="
ansible/tangle-all.sh

echo ""
echo "=== Assembling final playbook ==="
ansible/assemble-playbook.sh

echo ""
echo "=== Generation complete ==="
echo "Next: ansible-playbook ansible/validate.yml"
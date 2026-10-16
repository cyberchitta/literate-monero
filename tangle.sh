#!/bin/bash
# Regenerate everything from the org sources: a full `make clean all`.
# The Makefile is the one tangle entry point; this wrapper is kept for the
# update scripts and for habit.

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"
make clean
make all

echo ""
echo "=== Generation complete ==="
echo "Next: make check, then ansible-playbook ansible/validate.yml"

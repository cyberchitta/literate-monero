#!/bin/bash
# Does this tree's generated output still match its org sources?
# Re-tangles a scratch copy from scratch and diffs ansible/ and
# configs/templates/ against the files here. Run it on the box before a
# deploy: what Ansible is about to apply should be what the org files say.
# Differences mean a hand edit to a generated file, a stale leftover, or an
# org edit that was never re-tangled. Read-only for this tree.

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRATCH="$(mktemp -d)"
trap 'rm -rf "$SCRATCH"' EXIT

tar -C "$ROOT" \
    --exclude=./_notes --exclude=./ansible --exclude=./configs --exclude=./scripts \
    --exclude=./.git --exclude=./.tangled \
    -cf - . | tar -C "$SCRATCH" -xf -
mkdir -p "$SCRATCH/ansible"
[ -f "$SCRATCH/config.yml" ] || cp "$SCRATCH/config.yml.example" "$SCRATCH/config.yml"

make -C "$SCRATCH" all > "$SCRATCH/tangle.log" 2>&1 \
    || { cat "$SCRATCH/tangle.log"; echo -e "${RED}re-tangle failed${NC}"; exit 1; }

status=0
for dir in ansible configs/templates; do
    diff -r --exclude=.gitkeep "$SCRATCH/$dir" "$ROOT/$dir" || status=1
done

if [ "$status" = 0 ]; then
    echo -e "${GREEN}No drift: generated files match the org sources${NC}"
else
    echo -e "${RED}Drift: the files above differ from a fresh tangle (left: fresh, right: this tree)${NC}"
fi
exit "$status"

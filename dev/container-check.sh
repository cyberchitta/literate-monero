#!/bin/bash
# Runs inside the dev container (see dev/Dockerfile, `make docker-check`).
# The repo is mounted read-only at /src; everything is tangled into a scratch
# copy so no generated file lands in the working tree.

set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

SRC=/src
WORK=/work/repo

rm -rf "$WORK"
mkdir -p "$WORK"
# Copy sources only: generated dirs are rebuilt, _notes is a dangling symlink here.
tar -C "$SRC" \
    --exclude=./_notes --exclude=./ansible --exclude=./configs --exclude=./scripts \
    --exclude=./.git \
    -cf - . | tar -C "$WORK" -xf -
mkdir -p "$WORK/ansible" "$WORK/configs/templates" "$WORK/scripts"

# config.yml is gitignored and lives on the box; test against the example.
cp "$WORK/config.yml.example" "$WORK/config.yml"

cd "$WORK"
echo "ansible: $(ansible --version | head -1)"
echo "emacs:   $(emacs --version | head -1)"

if make all && make check; then
  echo -e "${GREEN}docker-check: passed${NC}"
else
  echo -e "${RED}docker-check: FAILED${NC}"
  exit 1
fi

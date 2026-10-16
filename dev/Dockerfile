# Dev/test container: tangle the org sources and check the generated
# Ansible on a machine that is not the box (e.g. a Mac).
#
# Debian, not Arch: nothing here executes the playbook. Tangling, Ansible
# syntax-check and the linters are distro-independent, and the official
# Debian image runs natively on arm64 (the official Arch image is amd64-only).
# Runtime behaviour (pacman, systemd, Tor) is still verified on the box.
#
# Network: only at build time (image pull + apt). Checks run with
# --network none — see `make docker-check`.
#
# The base is pinned by digest (multi-arch index, 2026-10-05). apt packages
# float within trixie; record `ansible --version` from a run when it matters.
FROM debian:trixie-slim@sha256:a29215f6a35e51e22adffa17f89e9d2ef06214e64a2bad10d765c46aea49f11f

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      emacs-nox ansible yamllint shellcheck make python3 ca-certificates \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /work

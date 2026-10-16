# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

### Added

- **Exchange (opt-in, off by default)**: RetoSwap (Haveno) as a signed, GPG-verified AppImage, run on demand under bubblewrap, never as a service
- **Interop tier (opt-in, off by default)**: `cast` (Foundry) EVM CLI, cosign-verified and confined to a Tor-only network namespace; Rabby browser extension as a dapp-UI fallback on the fail-closed Mullvad path
- **Sandboxed remote operations**: an `ops` user reached over WireGuard SSH, with a propose/approve signer: `ops` stages transactions, only the operator signs and broadcasts
- **Stablecoin wrappers**: `stable-bal` and `stable-send` over the signer, plus the `operate-stablecoin` skill
- **Monero wallet RPC**: `monero-wallet-rpc` service with runtime wallet switching
- **Mullvad WireGuard**: fallback VPN path for the privacy browser, with exit verification and a kill switch on tunnel drop
- **KeePassXC**: git credential storage
- **Release records**: rollbacks now restore `config.yml` to the rolled-back version (and its XMRig commit pin), so the next playbook run no longer silently re-upgrades
- **Checks**: `make check` (Ansible syntax-check, yamllint, shellcheck on templates rendered with real variables), `make check-drift` (do generated files match the org sources?), and `make docker-check` (both, in a Debian dev container with no network, for non-Linux hosts)

### Changed

- **Updates go through Tor**: version checks, downloads and the weekly check no longer touch clearnet, with no clearnet fallback
- **Update scripts**: keep the checkout and `config.yml` owned by its user, refuse malformed version strings, and never install a "latest" release that sorts below the current pin
- **XMRig** is built from a pinned, verified commit cloned over Tor, and every mining run re-checks the checkout against the pin
- **Monerod** runs as a dedicated `monero` user
- **Backups** are encrypted with age; plaintext archives are refused
- **Downloads** are GPG-verified against pinned maintainer keys (`keys/`)
- **Build**: the Makefile is the single tangle entry point (`tangle.sh` is `make clean all`); templates are tracked build outputs; `ansible/tangle-all.sh` is gone
- **Docs**: deploy phase by phase; scope framed as sovereign private crypto, Monero-anchored
- Huge pages doubled so monerod and XMRig both fit their RandomX datasets; P2Pool pinned to v4.16 for its consensus fix

### Fixed

- Haveno release tags with a `v` prefix (upstream changed format at v1.10.0-reto)
- Security audit fixes: sandbox secret overlays, Tor DNS for git/SSH proxies, ban-list signature check, restore-path whitelist, MSR access gating, pinned yay AUR commit, and a low-severity hardening batch
- Playbook assembly uses only fragments that match a current org file
- Tag-filtered runs define the registered variables their tasks read
- Monerod I2P startup, address discovery and verification; RPC polling during updates
- WireGuard/Mullvad DNS (systemd-resolved) and wrapper privilege handling
- `make check` runs as an ordinary user on the box (per-run scratch dir, in-memory fact cache); `make clean` removes leftovers from older builds

## [0.0.3] - 2026-01-29

### Added

- **Build system**: Makefile for selective org-mode tangling with dependency tracking
- **Application sandboxing**: Bubblewrap-based sandbox with secrets isolation for sensitive apps
- **Browser dispatch**: Domain-based browser routing (Chromium for KYC domains, Tor Browser for everything else)
- **Privacy wrappers**: Git operations routed through Tor by default, Tor Browser set as default browser
- **Sandbox**: Native Claude Code installation support
- **Localsend**: Wrapper script to manage WiFi and firewall around app lifecycle

### Changed

- Renumbered org phases for logical grouping (sandbox/secrets-isolation between privacy and monerod)
- Split privacy config into separate infrastructure and wrappers phases
- Replaced Brave browser with Chromium for KYC domains
- Consolidated redundant notes, threat models, design rationale, and troubleshooting into appendices (F, G, H)
- Removed unused and privacy-conflicting apps from base system

### Fixed

- Makefile: added config.yml as fragment dependency, prevented redundant config tangling
- Sandbox: properly verify Claude Code installation, relaxed sandbox to allow home directory access
- Browser dispatch: use standard Chromium profiles with display name lookup, focus existing Tor Browser window
- Secrets isolation: made migration task idempotent, atomic symlink creation, correct sandbox isolation test
- Privacy wrappers: persistent Tor Browser prefs via user.js, prevent control port conflict, disable Tor Launcher startup prompts
- WireGuard: removed peer backup complexity and ifconfig.me hang, preserve peer configs across runs
- Backup: correct Feather wallet file locations
- KeePassXC: preserve user preferences on reinstall
- Monerod: use get_info RPC method in status script
- Firewall and fragment filenames updated to match renumbered phases

## [0.0.2] - 2026-01-22

### Added

- **Update Management System**: Comprehensive software version management
  - `check-updates.sh` - Query GitHub for latest releases of Monerod, P2Pool, XMRig
  - `update-<component>.sh` - Safe atomic updates with automatic rollback on failure
  - `rollback-<component>.sh` - Interactive rollback to previous versions
  - Version pinning in config.yml with support for multiple installed versions
  - Atomic updates via symlink switches (instant rollback capability)
  - Optional weekly automated update checking (logs available updates, never auto-applies)
  - Preserved old versions in `/opt/<component>-<version>/` directories
  - Full verification after each update (service health, RPC connectivity, mining performance)

## [0.0.1] - 2026-01-20

### Added

- Initial release
- Monero full node (monerod) with I2P privacy
- Monero wallet tools (CLI/RPC, Feather GUI, Trezor support)
- KeePassXC for password/TOTP management
- Tor integration for git operations and web browsing
- WireGuard secure remote access
- Optional P2Pool + XMRig mining
- Literate programming infrastructure (Org-mode → Ansible)
- Comprehensive monitoring and backup systems
- Complete installation and verification documentation

[Unreleased]: https://github.com/cyberchitta/literate-monero/compare/v0.0.3...HEAD
[0.0.3]: https://github.com/cyberchitta/literate-monero/compare/v0.0.2...v0.0.3
[0.0.2]: https://github.com/cyberchitta/literate-monero/compare/v0.0.1...v0.0.2
[0.0.1]: https://github.com/cyberchitta/literate-monero/releases/tag/v0.0.1

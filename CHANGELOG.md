# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

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

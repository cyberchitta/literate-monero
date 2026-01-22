# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

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

[Unreleased]: https://github.com/cyberchitta/literate-monero/compare/v0.0.2...HEAD
[0.0.1]: https://github.com/cyberchitta/literate-monero/releases/tag/v0.0.2
[0.0.1]: https://github.com/cyberchitta/literate-monero/releases/tag/v0.0.1

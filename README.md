# Literate Monero

**Privacy-first Monero full node with trustless validation and network anonymity**

Run your own Monero infrastructure with complete sovereignty—no trusted third parties, no custodial services, no remote APIs. Network-level anonymity via I2P + Tor ensures transactions cannot be linked to your IP address.

Built using literate programming: the documentation IS the source code. Understand every component, customize any behavior, reproduce the entire system. Infrastructure as narrative.

> **Note**: This project was developed in collaboration with several LLMs, primarily Claude Sonnet 4.5, but with contributions from Claude Opus 4.5 and Grok 4.1. AI collaboration facilitated by [llm-context](https://github.com/cyberchitta/llm-context.py).

## Who This Is For

**Privacy-focused users** (human or AI agent): Verify transactions locally, broadcast anonymously. No intermediaries between you and the blockchain. The literate approach means you can audit exactly what your node does.

**Monero developers**: Full node access for wallet integrations, payment systems, or agent infrastructure. The narrative codebase is easier to customize and build upon than traditional config-heavy deployments.

## What You Get

Full Monero node infrastructure with defense-in-depth privacy:

- **monerod**: Trustless blockchain validation
- **Monero wallet tools**: CLI/RPC wallets + Feather GUI + optional Trezor support
- **KeePassXC**: Encrypted password and TOTP manager (no cloud, clipboard auto-clears)
- **I2P**: Peer-to-peer network anonymity for Monero traffic
- **Tor**: Anonymous git operations and web browsing
- **Browser dispatch**: Domain-based routing (Tor Browser by default, Chromium for KYC-required sites)
- **Application sandboxing**: Bubblewrap isolation with secrets separation for sensitive apps
- **WireGuard**: Secure remote access
- **Optional**: P2Pool decentralized mining + XMRig CPU miner

All documented as executable narrative in `org/*.org` files.

## Prerequisites

> **Portability:** Built and tested on Omarchy Linux. The Ansible playbooks assume systemd and pacman but should adapt to other distros with minor modifications.

- **Omarchy Linux** - Arch-based distro with full-disk encryption ([installation guide](https://learn.omacom.io/2/the-omarchy-manual/50/getting-started))
  - Install this FIRST (complete wipe of target drive)
  - Create user `dev` during install (or adjust `config.yml`)
- Monero wallet address (get from getmonero.org or Cake Wallet)

## Installation

1. **Clone repository:**

   ```bash
   git clone https://github.com/cyberchitta/literate-monero
   cd literate-monero
   ```

2. **Bootstrap:** (installs Emacs, Ansible, tmux)

   ```bash
   ./bootstrap.sh
   ```

   _Tip: Run installation in tmux (`tmux new -s monero-install`) to survive SSH disconnects._

3. **Configure:**

   ```bash
   nano config.yml  # Set monero_wallet_address, ssh keys, etc.
   ```

4. **Generate and deploy:**

   ```bash
   ./tangle.sh  # Extract Ansible playbooks from org files
   ansible-playbook ansible/validate.yml  # Check configuration
   ansible-playbook ansible/playbook.yml --tags base -K  # Run first phase
   # Continue with remaining phases (see org/install.org for order)
   ```

   Total time: 30-60min + 6-24hr blockchain sync. Full phase list in `org/install.org`.

## How It Works

This is a literate programming system - documentation and code are the same files.

**Source files:** `org/*.org` (narrative documentation with embedded code)

**Generated:** Ansible playbooks, systemd services, config files, shell scripts (idempotent deployment)

**Initial setup:** Follow Installation steps above.

**Making changes:**

1. Edit `config.yml` for simple settings, or edit `org/*.org` files directly for deeper changes
2. Tangle: `./tangle.sh` extracts Ansible playbooks from Org files
3. Deploy: `ansible-playbook ansible/playbook.yml --tags <phase>`

## Post-Install

Daily operations and monitoring are documented in `org/09-monitoring.org` and `org/99-appendix.org`.

Quick reference:

```bash
sudo system-check.sh      # Full verification
sudo monerod-status.sh    # Node sync status
source /etc/profile.d/log-aliases.sh && logs-all  # Live logs
```

## Resource Requirements

- **Disk:** 250GB blockchain (grows ~40GB/year) + 20GB system/backups (350GB+ recommended, 500GB+ for long-term)
- **Memory:** 2-4GB monerod + 2GB system = 16GB+ recommended
- **Network:** 250GB initial sync, 500MB-1GB/day ongoing

## Documentation

- `org/install.org` - Complete installation guide
- `org/00-configuration.org` - System configuration
- `org/01-11-*.org` - Modular installation phases
- `org/99-appendix.org` - Commands and troubleshooting

**External:** [Monero](https://monerodocs.org) · [I2P](https://geti2p.net/en/docs) · [P2Pool](https://github.com/SChernykh/p2pool)

## License

Apache 2

# Literate Monero

**Privacy-preserving Monero infrastructure for humans and agents**

Infrastructure-as-documentation using literate programming. The org files ARE the source code—Ansible playbooks are extracted from narrative documentation. Change the docs, regenerate the system.

> **Note**: This project was developed in collaboration with several LLMs, primarily Claude Sonnet 4.5, but with contributions from Claude Opus 4.5 and Grok 4.1. AI collaboration facilitated by [llm-context](https://github.com/cyberchitta/llm-context.py).

## Who This Is For

**Humans seeking monetary sovereignty:** Run your own Monero full node with network-level anonymity via I2P + Tor. No trusted third parties. The literate approach ensures you understand every part of your setup.

**AI agents transacting autonomously:** Cryptocurrency enables transactions without institutional dependencies (no banks, KYC, or legal personhood). Privacy coins add network-level anonymity. This repo provides verifiable, modifiable infrastructure that's easy to reason about programmatically.

**Developers learning literate programming:** Real-world infrastructure where configuration, explanation, and code cannot drift apart. Edit Org docs, tangle to generate playbooks, deploy with Ansible.

## What You Get

- **Tor**: Anonymous git operations, web browsing
- **I2P**: Monero P2P network privacy
- **WireGuard**: Secure remote access
- **monerod**: Full node with trustless transaction verification (250+ GB blockchain)
- **Optional**: P2Pool decentralized mining + XMRig CPU miner

## Prerequisites

> **Portability:** Built and tested on Omarchy Linux. The Ansible playbooks assume systemd and pacman but should adapt to other distros with minor modifications.

**Required:**

- **Omarchy Linux** - Arch-based distro with full-disk encryption ([installation guide](INSTALL-OMARCHY.md))
  - Install this FIRST (complete wipe of target drive)
  - Create user `dev` during install (or adjust `config.yml`)
- Monero wallet address (get from getmonero.org or Cake Wallet)

**Hardware:**

- 16GB+ RAM, 500GB+ disk (575GB recommended for blockchain growth)
- Modern x86_64 CPU (AMD Ryzen or Intel Core)
- UEFI firmware (not legacy BIOS)

## Installation

1. **Clone repository:**

   ```bash
   git clone https://github.com/cyberchitta/literate-monero
   cd literate-monero
   ```

2. **Bootstrap:**

   ```bash
   ./bootstrap.sh
   ```

   This installs Emacs, Ansible, tmux, and dependencies.

3. **Start persistent session:**

   ```bash
   tmux new -s monero-install
   ```

   **Tmux quick reference:**
   - Detach: `Ctrl-a d` (work continues in background)
   - Reattach: `tmux attach -t monero-install`
   - Split window: `Ctrl-a |` (vertical) or `Ctrl-a -` (horizontal)

4. **Configure:**

   ```bash
   nano config.yml  # Set dev_user, monero_wallet_address, ssh_public_key, etc.
   ```

5. **Generate playbooks:**

   ```bash
   ./tangle.sh
   ```

6. **Validate and deploy:**

   ```bash
   # Validate configuration first
   ansible-playbook ansible/validate.yml
   
   # Run phases in order (tested approach)
   ansible-playbook ansible/playbook.yml --tags base -K
   ansible-playbook ansible/playbook.yml --tags wireguard -K
   ansible-playbook ansible/playbook.yml --tags privacy -K
   ansible-playbook ansible/playbook.yml --tags i2p -K
   ansible-playbook ansible/playbook.yml --tags monerod -K
   ansible-playbook ansible/playbook.yml --tags users -K
   ansible-playbook ansible/playbook.yml --tags mining -K
   ansible-playbook ansible/playbook.yml --tags firewall -K
   ansible-playbook ansible/playbook.yml --tags monitoring -K
   ansible-playbook ansible/playbook.yml --tags backup -K
   ansible-playbook ansible/playbook.yml --tags verify -K
   ```

   Each phase can be re-run independently. Total time: 30-60min + 6-24hr monerod sync.

   **Alternative (untested):** Run all phases at once:
   ```bash
   ansible-playbook ansible/playbook.yml -K
   ```

## How It Works

**Source files:** `org/*.org` (narrative documentation with embedded code)

**Workflow:**

1. Read `org/install.org` to understand the system
2. Edit configuration in `config.yml` or directly in Org files
3. Tangle: `./tangle.sh` extracts Ansible playbooks from Org files
4. Deploy: `ansible-playbook ansible/playbook.yml`

**Updates:** Edit Org files → re-tangle → re-deploy. Documentation and code stay synchronized because they're the same files.

**Privacy model:**

- Blockchain sync: Clearnet (sybil protection)
- Transaction broadcast: I2P primary, Tor fallback
- P2P connections: I2P hidden service
- Git operations: Tor-routed

## Daily Operations

```bash
tmux new -s monitoring

# Status checks
sudo system-check.sh      # Full verification
sudo monerod-status.sh    # Node sync status
sudo i2p-status.sh        # I2P network

# Live logs
source /etc/profile.d/log-aliases.sh
logs-all    # System logs
logs-tor    # Tor daemon
```

## Resource Requirements

**Disk:** 250GB blockchain + 20GB system + ~15GB backups (575GB total recommended)
**Memory:** 2-4GB monerod + 2GB system = 16GB+ recommended
**Network:** 250GB initial sync, 500MB-1GB/day ongoing

## Documentation

- `org/install.org` - Complete installation guide
- `org/00-configuration.org` - System configuration
- `org/01-11-*.org` - Modular installation phases
- `org/99-appendix.org` - Commands and troubleshooting

**External:** [Monero](https://monerodocs.org) · [I2P](https://geti2p.net/en/docs) · [P2Pool](https://github.com/SChernykh/p2pool)

## License

Apache 2

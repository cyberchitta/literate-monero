# Literate Monero

**Privacy-preserving Monero infrastructure for humans and agents**

Infrastructure-as-documentation using literate programming. The org files ARE the source code—Ansible playbooks are extracted from narrative documentation. Change the docs, regenerate the system.

## Why This Exists

**For humans:** Maximum privacy + monetary sovereignty. Your own Monero full node, no trusted third parties, network-level anonymity via I2P + Tor.

**For agents:** Cryptocurrency lets AI agents transact without institutional dependencies (no bank accounts, KYC, legal personhood). Privacy coins extend this to network-level anonymity. Same infrastructure, different operator.

**The approach:** Literate programming keeps configuration and explanation synchronized. When the system changes, the documentation must change. They cannot drift.

## What You Get

**Privacy stack:**

- Tor: Anonymous git operations, web browsing
- I2P: Monero P2P network privacy
- WireGuard: Secure remote access

**Validation infrastructure:**

- monerod: Monero full node (~230 GB blockchain)
- Trustless transaction verification
- Direct P2P network participation

**Optional (demonstrates complete stack):**

- P2Pool: Decentralized mining pool
- XMRig: CPU mining

## Prerequisites

**Required:**

- **Omarchy Linux** - Arch-based distro with full-disk encryption ([installation guide](INSTALL-OMARCHY.md))
  - Install this FIRST (complete wipe of target drive)
  - Create user `dev` during install (or adjust `config.yml`)
- Monero wallet address (get from getmonero.org or Cake Wallet)

**Hardware:**

- 16GB+ RAM, 500GB+ disk (575GB recommended)
- Modern x86_64 CPU (AMD Ryzen or Intel Core)
- UEFI firmware (not legacy BIOS)

## Install

```bash
# Prerequisites: Omarchy Linux installed (see INSTALL-OMARCHY.md)

git clone https://github.com/cyberchitta/literate-monero
cd literate-monero
./bootstrap.sh

# Configure
nano config.yml  # Set dev_user, monero_wallet_address, ssh_public_key

# Generate playbooks from org files
./tangle.sh

# Deploy
ansible-playbook ansible/validate.yml      # Check configuration
ansible-playbook ansible/playbook.yml -K   # Deploy (30-60min + 6-24hr blockchain sync)
```

## How It Works

**Source files:** `org/*.org` (narrative + embedded code)

**Workflow:**

1. Read `org/install.org` to understand system
2. Edit configuration in `config.yml`
3. Tangle: `cd ansible && ./tangle-all.sh` (extract Ansible)
4. Deploy: `ansible-playbook playbook.yml`

**Updates:** Edit org files → re-tangle → re-deploy. Don't edit generated files.

## Architecture

**Privacy model:**

- Blockchain sync: Clearnet (sybil protection)
- Transaction broadcast: I2P primary, Tor fallback
- P2P connections: I2P hidden service
- Git operations: Tor-routed

**Stack:**

- Base: Omarchy (Arch + encryption)
- Privacy: Tor, I2P, WireGuard
- Validation: monerod full node
- Optional: P2Pool mining

## Daily Operations

```bash
# Status
sudo system-check.sh      # Full verification
sudo monerod-status.sh    # Node sync status
sudo i2p-status.sh        # I2P network

# Logs
source /etc/profile.d/log-aliases.sh
logs-all    # System logs
logs-tor    # Tor daemon
```

## Resource Requirements

**Disk:** 230GB blockchain + 20GB system + ~15GB backups (575GB total recommended)  
**Memory:** 2-4GB monerod + 2GB system = 16GB+ recommended  
**Network:** 230GB initial sync, 500MB-1GB/day ongoing

## Use Cases

**Humans:**

- Monetary sovereignty (verify your own transactions)
- Maximum privacy (I2P + Tor network anonymity)
- No trusted third parties

**AI Agents:**

- Transact without institutional intermediaries
- Network-level anonymity (not just pseudonymity)
- Deterministic validation without external dependencies

**Developers:**

- Literate programming example (real-world infrastructure)
- Privacy-first development environment
- Reproducible system from source

## Documentation

- `org/install.org` - Complete installation guide
- `org/00-configuration.org` - System configuration
- `org/01-11-*.org` - Modular installation phases
- `org/99-appendix.org` - Commands and troubleshooting

**External:**

- [Monero](https://monerodocs.org)
- [I2P](https://geti2p.net/en/docs)
- [P2Pool](https://github.com/SChernykh/p2pool)

## License

Apache 2

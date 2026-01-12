# Literate Monero

**Privacy-preserving Monero infrastructure for humans and agents**

Infrastructure-as-documentation using literate programming. The org files ARE the source code—Ansible playbooks are extracted from narrative documentation. Change the docs, regenerate the system.

> **Note**: This project was developed in collaboration with several LLMs, primarily Claude Sonnet 4.5. AI collaboration facilitated by [llm-context](https://github.com/cyberchitta/llm-context.py).

## Why This Exists

In a world of centralized services and opaque Docker images, Literate Monero provides a transparent, self-documenting way to run privacy-focused cryptocurrency infrastructure.

**For humans:** Achieve maximum privacy and monetary sovereignty with your own Monero full node. No trusted third parties, with network-level anonymity via I2P + Tor. The literate approach ensures you understand every part of your setup.

**For agents:** Cryptocurrency enables AI to transact without institutional dependencies (no banks, KYC, or legal personhood). Privacy coins add network-level anonymity. This repo provides verifiable, modifiable infrastructure that's easy to reason about programmatically.

**The approach:** Literate programming keeps configuration, explanation, and code synchronized. When the system changes, the documentation must change—they cannot drift. This creates a "living document" that's both human-readable and machine-executable.

## Runtime Benefits

The deployed system provides:

- **Privacy:** Tor for git/web, I2P for Monero P2P, WireGuard for access.
- **Sovereignty:** Trustless validation via monerod full node.
- **Decentralization:** Optional P2Pool mining without central pools.
- **No intermediaries:** Direct network participation.

## Installation Benefits

The literate + Ansible setup offers:

- **Transparency:** Code embedded in explanations—understand before deploy.
- **Customizability:** Edit Org docs for tailored setups; tangle to generate.
- **Repeatability:** Ansible idempotency ensures safe, consistent re-runs.
- **Flexibility:** Modular phases for partial/custom installs.

### Why Literate Programming Over Docker?

- **Docker pros:** Quick, isolated.
- **Docker cons:** Opaque images, harder deep customization, supply-chain risks.
- **Literate advantages:** Full visibility, easy mods while keeping docs synced, educational. Ideal for sovereignty and learning; Docker better for "just run it".

## What You Get

**Privacy stack:**

- Tor: Anonymous git operations, web browsing
- I2P: Monero P2P network privacy
- WireGuard: Secure remote access

**Validation infrastructure:**

- monerod: Monero full node (230+ GB blockchain)
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

   This sets up Emacs, Ansible, and dependencies.

3. **Configure:**

   ```bash
   nano config.yml  # Set dev_user, monero_wallet_address, ssh_public_key, etc.
   ```

4. **Generate playbooks:**

   ```bash
   ./tangle.sh
   ```

5. **Validate and deploy:**
   ```bash
   ansible-playbook ansible/validate.yml      # Check configuration
   ansible-playbook ansible/playbook.yml -K   # Deploy (30-60min + 6-24hr blockchain sync)
   ```

## How It Works

**Source files:** `org/*.org` (narrative + embedded code)

**Workflow:**

1. Read `org/install.org` to understand the system.
2. Edit configuration in `config.yml` or directly in Org files.
3. Tangle: `./ansible/tangle-all.sh` (extract Ansible fragments).
4. Assemble: `./ansible/assemble-playbook.sh` (combine into `playbook.yml`).
5. Deploy: `ansible-playbook ansible/playbook.yml`.

**Updates:** Edit Org files → re-tangle → re-deploy. Avoid editing generated files.

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
- Optional: P2Pool + XMRig mining

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

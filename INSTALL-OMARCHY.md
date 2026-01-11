# Installing Omarchy Linux (Prerequisite)

**Complete this before cloning the repository**

This installs Omarchy Linux, which is required to run literate-sovereign. If you already have Omarchy installed, skip to the [main README](README.md).

## ⚠️ Critical Warnings

- **This will COMPLETELY WIPE your selected drive**
- All existing data will be permanently deleted
- Omarchy uses full-disk encryption - no dual-boot on single drive
- **Backup everything important BEFORE starting**

## Hardware Requirements

- 64-bit x86_64 CPU (AMD Ryzen or Intel Core recommended)
- 16GB+ RAM
- 200GB+ disk space (160GB for Monero blockchain + system)
- UEFI firmware (not legacy BIOS)
- Internet connection
- USB drive (8GB+) for installation media

**Tested on:** Beelink SER5, Framework Laptop 13/16, Framework Desktop

## Installation

1. **Download Omarchy ISO:** https://omarchy.org
2. **Create bootable USB** (see Omarchy docs)
3. **Boot from USB and follow installer**
   - Create username: `dev` (recommended for consistency with this repo)
   - Set strong encryption password (**unrecoverable if lost**)
   - Select target disk carefully (**data will be wiped**)

**Detailed installation guide:** https://learn.omacom.io/2/the-omarchy-manual/50/getting-started

## First Boot

1. Enter encryption password (set during installation)
2. System auto-logs in to Hyprland desktop
3. Press `Super + Enter` to open terminal

## Next Steps

1. **Clone this repository:**

```bash
   git clone https://github.com/cyberchitta/literate-monero
   cd literate-monero
```

2. **Run bootstrap:**

```bash
   ./bootstrap.sh
```

3. **Configure (REQUIRED):**

```bash
   nano config.yml
```

Set your Monero wallet address (get from: getmonero.org, Cake Wallet, etc.)

4. **Continue with main installation:**
   - See `README.md` for complete setup
   - Run validation: `ansible-playbook ansible/validate.yml`
   - Run installation: `ansible-playbook ansible/playbook.yml`

## Common Issues

- **BIOS won't appear:** Disable Fast Startup in Windows first
- **Forgot encryption password:** No recovery possible, must reinstall
- **Boot fails:** Check monitor connection, wait 30 seconds

**Troubleshooting:** https://learn.omacom.io/2/the-omarchy-manual/50/getting-started#troubleshooting

---

**Remember:** Encryption password cannot be recovered. Write it down and keep it safe.

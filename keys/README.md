# Pinned maintainer GPG keys

These public keys are the trust anchors for verifying release downloads.
They are committed to the repo (rather than fetched from a keyserver at
install time) so the trust decision is made once, here, and is auditable
in git history. The playbook imports them into a dedicated root-only
keyring (`gpg_verify_home`) and refuses to install unverified artifacts.

| File | Owner | Fingerprint | Verifies |
|------|-------|-------------|----------|
| `binaryfate.asc` | binaryFate <binaryfate@getmonero.org> | `81AC 591F E9C4 B65C 5806 AFC3 F0AF 4D46 2A0B DF92` | getmonero.org `hashes.txt` (monerod release hashes) |
| `schernykh.asc` | SChernykh <sergey.v.chernykh@gmail.com> | `1FCA AB4D 3DC3 310D 16CB D508 C47F 82B5 4DA8 7ADF` | P2Pool release `sha256sums.txt.asc` |
| `featherwallet.asc` | FeatherWallet <dev@featherwallet.org> | `8185 E158 A333 30C7 FD61 BC0D 1F76 E155 CEFB A71C` | Feather Wallet AppImage detached `.asc` |
| `satoshilabs-2021-signing-key.asc` | SatoshiLabs 2021 Signing Key | `EB48 3B26 B078 A4AA 1B6F 425E E21B 6950 A2EC B65C` | Trezor Suite AppImage detached `.asc` |
| `boog900.asc` | Boog900 (monero-ban-list maintainer) | `37AA 6F0F 4776 A897 EEA4 4E5C AD8B 0A2C F759 9219` (signs with ed25519 subkey `A875 F544 CB56 9CB9 6889 791E 42AB 1287 CB00 41C2`) | Monero spy-node ban list `sigs/boog900.sig` |

## Provenance (fetched 2026-06-11)

- `binaryfate.asc`: <https://raw.githubusercontent.com/monero-project/monero/master/utils/gpg_keys/binaryfate.asc>.
  Fingerprint matches the one published in the Monero verification guide
  (<https://www.getmonero.org/resources/user-guides/verification-allos-advanced.html>).
  Checked: gives a Good signature on the live `hashes.txt`.
- `schernykh.asc`: <https://keys.openpgp.org> by fingerprint, after extracting
  the signer key ID from the actual P2Pool v4.12 `sha256sums.txt.asc`.
  Checked: gives a Good signature on that release file.
- `featherwallet.asc`: <https://raw.githubusercontent.com/feather-wallet/feather/master/utils/pubkeys/featherwallet.asc>
  (first-party, in the Feather source tree; same key referenced at
  <https://docs.featherwallet.org/guides/verify-binaries>).
- `satoshilabs-2021-signing-key.asc`: <https://data.trezor.io/security/satoshilabs-2021-signing-key.asc>
  (first-party; referenced from Trezor Suite download page).
- `boog900.asc`: <https://raw.githubusercontent.com/Cuprate/cuprate/7b8756fa80e386fb04173d8220c15c86bf9f9888/misc/gpg_keys/boog900.asc>
  (commit-pinned URL published in the monero-ban-list README).
  Checked: gives a Good signature on the live `ban_list.txt`. The ban
  list is co-signed by four other maintainers (jeffro256, Rucknium,
  SyntheticBird, hinto-janai) if stronger verification is ever wanted.

## Re-verifying these keys

```bash
gpg --show-keys keys/*.asc        # compare fingerprints with the table above
```

Cross-check fingerprints against the upstream sources listed in
Provenance, ideally over more than one network path (clearnet + Tor).
If a key ever changes upstream, treat it as an incident: investigate
before updating the pinned copy, and record the rationale in the commit
message.

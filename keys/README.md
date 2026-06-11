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

## Re-verifying these keys

```bash
gpg --show-keys keys/*.asc        # compare fingerprints with the table above
```

Cross-check fingerprints against the upstream sources listed in
Provenance, ideally over more than one network path (clearnet + Tor).
If a key ever changes upstream, treat it as an incident: investigate
before updating the pinned copy, and record the rationale in the commit
message.

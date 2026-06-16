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
| `torbrowser.asc` | Tor Browser Developers <torbrowser@torproject.org> | `EF6E 286D DA85 EA2A 4BA7 DE68 4E2C 6E87 9329 8290` | Tor Browser `sha256sums-signed-build.txt.asc` |
| `retoswap.asc` | reto (RetoSwap / haveno-reto maintainer) | `DAA2 4D87 8B8D 36C9 0120 A897 CA02 DAC1 2DAE 2D0F` | RetoSwap release `<tag>.hashes.sig` (Haveno AppImage hashes) |

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
- `torbrowser.asc`: Tor Project WKD
  (<https://openpgpkey.torproject.org/.well-known/openpgpkey/torproject.org/hu/kounek7zrdx745qydx6p59t9mqjpuhdf?l=torbrowser>),
  the source the Tor Project documents for signature verification.
  Fingerprint matches the long-published Tor Browser Developers key.
  Checked: gives a Good signature on the live 15.0.15
  `sha256sums-signed-build.txt`.
- `retoswap.asc`: <https://raw.githubusercontent.com/retoaccess1/haveno-reto/master/gpg_keys/reto_public.asc>
  (first-party, in the haveno-reto source tree). ed25519 key, uid "reto".
  Checked: gives a Good signature on the live `1.6.0-reto.hashes`, which in
  turn pins the SHA-256 of `haveno-v1.6.0-linux-x86_64.AppImage`. NOTE: this
  release-signing key is **not** the key that signs the git commits
  (those use RSA `B5690EEEBB952194`); the exchange phase verifies the signed
  hashes of the published AppImage, not a git tag (the tags are unsigned).

## Re-verifying these keys

```bash
gpg --show-keys keys/*.asc        # compare fingerprints with the table above
```

Cross-check fingerprints against the upstream sources listed in
Provenance, ideally over more than one network path (clearnet + Tor).
If a key ever changes upstream, treat it as an incident: investigate
before updating the pinned copy, and record the rationale in the commit
message.

## Non-GPG trust anchor: Foundry `cast` (cosign / Sigstore)

The `interop` phase (`org/30-interop.org`) verifies the `cast` binary, but
**Foundry publishes no GPG key** — so there is no `.asc` file for it here.
Its first-party signature chain is **cosign / Sigstore** instead: each
versioned release ships `foundry_<ver>_linux_amd64.sigstore.json`, a keyless
signature produced by Foundry's release GitHub Actions workflow. The trust
anchor is therefore not a key file but a **pinned certificate identity**,
recorded here for auditability (it lives in `group_vars` as
`foundry_cosign_identity` / `foundry_cosign_issuer`):

| Field | Value |
|-------|-------|
| `--certificate-identity` | `https://github.com/foundry-rs/foundry/.github/workflows/release.yml@refs/tags/<tag>` |
| `--certificate-oidc-issuer` | `https://token.actions.githubusercontent.com` |

The phase checks the release `.sha256`, then runs `cosign verify-blob` over
the `.tar.gz` against that identity, failing closed on any mismatch. We pin a
**versioned** tag (`vX.Y.Z`); the rolling `stable` tag omits the `.sha256` and
`.sigstore.json`. Foundry documents this verification (plus the equivalent
`gh attestation verify --repo foundry-rs/foundry`) in its `SECURITY.md`.

Provenance (confirmed 2026-06-16): the certificate identity above was read
from the actual decoded signing cert in the published
`foundry_v1.7.1_linux_amd64.sigstore.json`, and matches the `release.yml`
workflow at tag `v1.7.1`. `cosign` itself is the official Arch `extra/cosign`
package. If the workflow path or issuer ever changes upstream, treat it as an
incident (as with the GPG keys above) before updating the pinned identity.

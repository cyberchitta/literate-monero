---
name: operate-stablecoin
description: >-
  Use when the user wants to check a stablecoin (USDC / ERC-20) balance on the
  box, or send/transfer stablecoins from the box's EVM account. Drives the cast
  interop wrappers (stable-bal for reads, stable-send to stage transfers).
  STAGES transfers offline for the operator to approve — it never signs or
  broadcasts.
---

# Operate the stablecoin wallet

This skill operates the EVM stablecoin wallet on the sovereign box through the
`cast` interop tier. A "stablecoin wallet" is just an EVM account (one address,
the same on every chain); the stablecoin is an ERC-20 balance at that address.

> SOURCE: hand-authored, first-class skill (NOT tangle output). It *consumes*
> infrastructure built by `org/30-interop.org` (the `interop` phase). The infra
> is the org's single source of truth; this operational layer is portable and
> lives on its own. Keep the two in sync by declaration + runtime probe (below),
> not by co-location.

## The hard boundary — never cross it

The interop tier deliberately splits signing into **propose** (untrusted,
offline) and **approve** (trusted operator). This skill is the *proposer*. It:

- MAY run read-only balance checks and MAY *stage* a transfer (offline — staging
  only writes a proposal file; no key, no network, nothing broadcast).
- MUST NOT run `cast-approve`, MUST NOT sign, MUST NOT touch a keystore password
  or a Trezor. Approval is the human operator's exclusive action, on their own
  session. After staging, hand the operator the exact `cast-approve` command and
  stop.

Treat this as a rule, not a guideline: the whole point of the split is that the
authorization decision does not rest on an agent-driven session.

## Preconditions — probe before acting

This skill requires the `interop` phase deployed with `cast_enabled: true`.
Before doing anything, verify on the box:

```bash
command -v stable-send stable-bal && test -r /etc/interop/tokens -a -r /etc/interop/chains
```

If those are missing, the box isn't provisioned for this — tell the user to
enable `cast_enabled` and deploy `--tags interop`, then stop. Do not improvise
with bare `cast`.

Run context matters:
- **Balance reads (`stable-bal`)** go over Tor via `sudo cast-tor`, so they need
  the key-owner/`dev` cast-tor sudo grant. From the sandboxed `ops` front door
  (which lacks that grant), balance reads will fail — only staging works there.
- **Staging (`stable-send`)** is fully offline and works from any context,
  including an `ops` session.

## Reading a balance

```bash
stable-bal <symbol> <address> --chain <name>
```

- `<symbol>` and `<name>` must exist in the registry (`/etc/interop/tokens`,
  `/etc/interop/chains`) — e.g. `usdc` on `base` or `arbitrum`. If the user
  names a token/chain not in the registry, stop and tell them to add it to
  `interop_tokens`/`interop_chains` in `config.yml` (address verified against
  the issuer) and redeploy — never invent a contract address or chain id.
- Output is already decimal-formatted (e.g. `50.000000 USDC (chain base)`).

## Staging a transfer (then hand off)

1. **Confirm in human terms first.** Restate symbol, amount, recipient, and
   chain back to the user and get explicit confirmation — this moves real money.
   Give `stable-send` the *human* amount (e.g. `50` or `12.5`); it does the
   decimal conversion. Never pass raw base units.
2. Stage it (offline):
   ```bash
   stable-send <symbol> <amount> <to-address> --chain <name>
   ```
   This prints a proposal path under the spool and a note carrying the
   approve-time RPC hint.
3. **Hand off.** Surface to the operator: the proposal path, and the exact
   command they run themselves —
   ```
   cast-approve <proposal-path> --rpc-url <that chain's RPC>
   ```
   The chain id travels in the proposal; the RPC does not — so the L2 RPC
   (e.g. `https://1rpc.io/base`) must be passed at approve time. Then state
   plainly that you will not approve or sign it; they review and approve.

## Caveats to surface when relevant

- **Verify the contract before first funding.** The registry address is config;
  confirm it against the issuer (Circle, for USDC) before sending real value.
- **Gas token.** Moving an ERC-20 needs a little native gas (ETH) on the *same*
  address. A send will fail without it.
- **Custody is chosen at approval**, not here: the operator picks
  `cast-approve --custody keystore|trezor`. A funded wallet should use Trezor.
- **Privacy reality.** Tor hides the network origin, not the on-chain trail;
  stablecoins are transparent and issuer-freezable. Don't reuse this address for
  anything you need unlinkable.

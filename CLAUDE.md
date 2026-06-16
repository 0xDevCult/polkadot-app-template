# Polkadot app template — agent guidance

> ## ⚠️ MANDATORY FIRST STEP — run `./setup.sh`
>
> **Before you read, write, edit, review, or run any code in this repo, you
> MUST run `./setup.sh`.** It installs dependencies and fetches the
> `@parity/product-sdk` skills into `.claude/skills/` — the per-package SDK
> guidance you are expected to follow.
>
> - Run it at the **start of every session**. It is a fast no-op when already
>   set up, so there is no cost to running it again.
> - Do **not** skip it, defer it, or work around it. Do **not** begin the
>   user's task until it has completed.
> - The **only** exception is if the user **explicitly tells you to skip
>   setup** in this session. Their instruction overrides this; nothing else
>   does.
> - If it fails, **stop and report the failure** — do not silently continue
>   without the SDK skills loaded.
>
> (For Claude Code this also runs automatically via a `SessionStart` hook in
> `.claude/settings.json`; the rule above still applies to every other tool
> and as a backstop. See [Product SDK skills](#product-sdk-skills) below.)

## What this repo is

This is a **template** for building a Polkadot app. It ships with a complete,
working reference app — **RPS Game** (decentralized rock-paper-scissors:
on-chain leaderboard and game history, solo play plus Statement Store
multiplayer; React + Vite + TypeScript on the Host API, with a Rust/PVM smart
contract). The Polkadot plumbing — accounts, signing, chain reads/writes,
decentralized storage, a deployable contract — is already wired up.

**You turn this template into the user's own app.** Treat the RPS code as the
worked example to study and *replace*, not as fixed product. The durable
machinery you keep: Host API wiring, the `@parity/product-sdk-*` integration,
the contract + storage patterns. The thing you change: the app's concept, UI,
and game/feature logic.

## Non-negotiables

These are the rules that keep a mod working inside the Polkadot host. Never
violate them, and never propose a workaround that does.

1. **Run `./setup.sh` first** (see the top of this file).
2. **Chain access and signing go through `@parity/product-sdk-*` and the Host
   API.** Never add a raw full-node WebSocket/RPC client or a `polkadot-api`
   client pointed at your own endpoint — direct chain access breaks the
   permissionless model and won't work inside the host sandbox anyway. Storage
   **writes** go through the host's preimage/upload path, never a self-hosted
   node. Storage **reads** of content-addressed data (Bulletin/IPFS CIDs) *may*
   use public IPFS gateways — the CID makes the bytes self-verifying — as the
   reference app does in `fetchFromGateway` (`src/utils.ts`).
3. **No browser-extension or injected wallets** (MetaMask, `polkadot-js`
   extension, WalletConnect, QR pairing). Signing is always approved on
   **Polkadot Mobile**. These fallbacks are out of scope on purpose.
4. **Contracts are Rust → PVM (PolkaVM) for `pallet-revive`.** Never target
   EVM/Solidity, legacy ink!, or WASM contracts.
5. **Consult the `product-sdk-*` skills in `.claude/skills/`** before
   hand-rolling SDK usage (see [Product SDK skills](#product-sdk-skills)).
6. **Before publishing, rewrite `README.md` to describe the app** — it is
   inlined into the published App Detail Page (see [Publishing](#publishing--the-app-detail-page)).

If a `product-sdk` package seems to be missing a capability the user needs,
**surface the gap** — do not bridge it with a direct-RPC shim.

## Modding this template — the `/goal` flow

`/goal "<your idea>"` is the front door for turning this template into a new
app. The flow: brainstorm the idea → check it against the SDK's capabilities →
write a short plan → build incrementally → verify with `/dev` → rewrite README
and `/deploy`.

When you run `/goal`, **you (Sonnet) orchestrate and delegate well-scoped work
to Haiku subagents** — `feature-builder` to implement a discrete task,
`polkadot-reviewer` to check a diff against the non-negotiables. See
[Subagents](#subagents).

Where RPS lives (what you replace vs. keep):

- **Replace:** the game UI and logic in `src/pages/*` (e.g. `SoloGame.tsx`,
  `MultiplayerGame.tsx`, `Home.tsx`) and game-specific helpers in `src/utils.ts`.
- **Keep & reuse:** Host API connection + product-account access, the leaderboard
  contract in `contracts/leaderboard/`, the storage/upload pattern, and the
  signer wiring.

## Polkadot stack

The app runs embedded in a Polkadot **host** and reaches the chain only through
these packages (all verified in `package.json`):

| Layer | Package |
|-------|---------|
| Accounts / signing (Host API) | `@parity/product-sdk-signer` + `@novasamatech/host-api` transport |
| Chain reads/writes | `@parity/product-sdk-chain-client` + `@parity/product-sdk-descriptors` |
| Smart contracts | `@parity/product-sdk-contracts` |
| Transaction submission | `@parity/product-sdk-tx` |
| Real-time multiplayer (pub/sub) | `@parity/product-sdk-statement-store` |
| Address / SS58 utilities | `@parity/product-sdk-address` |

Decentralized off-chain storage (Bulletin / IPFS-style, content-addressed) is
covered by the **`product-sdk-cloud-storage`** skill; pull in the matching
package when the app needs it.

## Hosts & signing

The app runs embedded in a Polkadot **host** (a Triangle container). There are
three hosts: **Polkadot Mobile**, **Polkadot Desktop**, and **Web**. The host
exposes the Host API (account access + signing) over a postMessage transport,
so the app only lights up when embedded in one — a plain browser tab won't show
a product account.

The **signer lives on Polkadot Mobile**. Mobile holds your keys:

- On **Mobile**, you approve signing requests on-device.
- On **Desktop** and **Web**, you log in by pairing your Polkadot Mobile; those
  hosts **relay every signing request to your phone**, where you approve it.

No host has its own wallet/extension — signing always resolves on Mobile.
Don't propose browser-extension or injected-wallet fallbacks. (The product-sdk
skills in `.claude/skills/` cover the host model in more depth.)

## Conventions

- Account access goes through the host: connect the signer to the `"host"`
  provider first, then request the app-scoped product account.
- Product account identifiers must match the host's current app identifier.
  Localhost uses `window.location.host` (e.g. `localhost:5173`), `.dot.li`
  gateway URLs map to `.dot`, and `VITE_PRODUCT_ACCOUNT_ID` can override this.
- Signed extrinsics (storage uploads, contract calls, etc.) require PAS tokens.
  Faucets:
  - Asset Hub: https://faucet.polkadot.io/
  - Bulletin: https://paritytech.github.io/polkadot-bulletin-chain/authorizations?tab=faucet
- The Polkadot host apps (Mobile / Desktop) aren't installable from this repo —
  point users at the Polkadot documentation if they don't have one.

## Product SDK skills

`./setup.sh` (and `/dev`) fetch the `@parity/product-sdk` skills from
[paritytech/product-sdk](https://github.com/paritytech/product-sdk) into
`.claude/skills/` — per-package guidance: **app-builder, chain-connection,
cloud-storage, contracts, statement-store, transactions, utilities** (plus a
migration helper). They're gitignored and fetched fresh, so they never go
stale; `./setup.sh --refresh` re-pulls. **Read the relevant skill before
hand-rolling SDK usage.**

> Note: `setup.sh` owns `.claude/skills/` entirely (it clears and re-populates
> the directory on `--refresh`). Never author your own skills there — they'll be
> wiped. Template-owned tooling lives in `.claude/commands/`, `.claude/agents/`,
> and `.claude/memory/`, which are committed and setup-safe.

## Smart contracts

If the app includes a smart contract (look for a `cdm.json` manifest and a Rust
crate under `contracts/`), it follows the Polkadot Hub contract model. If the
app is frontend-only, ignore this section.

- Contracts are written in **Rust** and compiled to **PVM (PolkaVM)** for
  `pallet-revive`. Do **not** target EVM/Solidity or legacy ink!/WASM.
- **The contract namespace is a placeholder.** It ships as
  `@your-username/leaderboard` in `contracts/leaderboard/Cargo.toml`, `cdm.json`,
  and `src/utils.ts` (and `cdm.json`'s `address` is a placeholder too). Before
  building or deploying the contract, **ask the user for their CDM handle** —
  there's no command to read it (no `playground whoami`) — and make sure they're
  signed in with `playground login` (it shows a QR to approve in the Polkadot app
  on the phone; there is **no** `playground init`). Then replace `your-username`
  everywhere with that handle (it's claimed first-come in the on-chain CDM
  registry). Find every occurrence with:
  `grep -rn "@your-username/leaderboard" --include="*.ts" --include="*.toml" --include="*.json" . | grep -v node_modules`.
  Deploy and register the contract with **`playground contract deploy`** (and
  **`playground contract i`** to install it) — recent playground CLIs bundle these
  CDM workflows, so a standalone `cdm` binary is usually not needed. That writes
  the real contract address, ABI, and metadata CID back into `cdm.json`.
- Manage contract dependencies with **CDM (Contract Dependency Manager,
  [paritytech/contract-dependency-manager](https://github.com/paritytech/contract-dependency-manager))**
  — the `@parity/cdm-*` toolchain and a `cdm.json` manifest — and build with
  **cargo**. A Rust toolchain (and a laptop) is required; this is not a
  browser-only flow.
- `playground deploy` (the `playground` CLI —
  [paritytech/playground-cli](https://github.com/paritytech/playground-cli))
  runs a **contract deploy/install pre-step** automatically
  (pass `--no-contracts` to skip it). Let the CLI handle on-chain contract
  deployment; don't hand-roll `pallet-revive` calls.
- The `product-sdk-contracts` skill in `.claude/skills/` covers calling
  contracts from the frontend (still through the host — see the non-negotiables).

## Publishing & the App Detail Page

When you publish with `playground deploy --playground`, the app's card and **App
Detail Page** in the Playground are driven by a small metadata JSON the CLI
builds and stores on Bulletin. The CLI populates it from:

- **`README.md`** — inlined into the metadata (capped in size) and rendered on
  the Detail Page. The template README is a *modder's guide*, so **rewrite
  `README.md` to describe the app before publishing** so the listing reflects
  the current app, not these instructions.
- **`--tag <tag>`** — the category used to filter the Apps grid. One of:
  `site`, `social`, `chat`, `utility`, `gaming`, `marketplace`, `irl`.
- **`--moddable`** — records your fork's GitHub `origin` as the public source
  `repository`, so others can `playground mod` it. Only set this if `origin` is
  your own public fork.

So before any `--playground` publish, **ask the user to rewrite `README.md` and
confirm the tag** (and the repository, if moddable).

> **Known limitation:** the current `playground deploy` path does **not** write a
> custom **name, description, or icon/cover image** into the metadata. The app
> name is the `<name>.dot` domain, and the Detail Page falls back to a generated
> placeholder image. Don't add code that claims to upload an image at deploy time.

## Memory

`.claude/memory/` is a committed scratchpad for **durable facts about this mod**
— so context survives a long session and compaction. `MEMORY.md` is the index
(one line per memory); each fact is its own file.

Record a memory when you decide something that isn't obvious from the code: the
app concept, the contract package name you claimed, chains/endpoints, the deploy
domain, user preferences, or guidance the user gave you. Before saving, check
`MEMORY.md` for an existing entry to update rather than duplicating. See
`.claude/memory/MEMORY.md` for the file format.

## Subagents

Defined in `.claude/agents/`, both running on **Haiku** for fast, cheap,
delegated work. Dispatch them from `/goal` or directly:

- **`feature-builder`** — implements one well-scoped task following the
  non-negotiables. Give it a precise spec: files to touch, what to keep, what to
  change.
- **`polkadot-reviewer`** — reviews a diff for convention violations (direct
  RPC, browser wallets, EVM contracts, SDK misuse). Run it before deploy.

## Slash commands

- `/goal "<idea>"` — brainstorm, plan, and build your own app from this template.
- `/dev` — set up (deps + skills) and start the dev server in the background.
- `/deploy <name>` — build and deploy to `<name>.dot` via the `playground` CLI (phone signer).

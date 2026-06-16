# AI agent guidance

**MANDATORY FIRST STEP:** Before reading, writing, or changing any code, run `./setup.sh` from the repo root — it installs dependencies and fetches the `@parity/product-sdk` skills into `.claude/skills/`. Run it at the start of every session (a fast no-op when already set up). Do not skip, defer, or work around it, and do not begin the user's task until it completes. The **only** exception is if the user explicitly tells you to skip setup. If it fails, stop and report it.

This is a **template** for building a Polkadot app. It ships with a complete reference app — **RPS** (decentralized rock-paper-scissors: on-chain leaderboard and game history, solo plus Statement Store multiplayer; React + Vite + TypeScript on the Host API, with a Rust/PVM smart contract). You **mod it into the user's own app**: study and replace the RPS game code, keep the Polkadot wiring. Canonical guidance is in [CLAUDE.md](CLAUDE.md) — read it first.

Start a build with `/goal "<idea>"` (brainstorm → plan → build incrementally → `/dev` → rewrite README → `/deploy`).

Non-negotiables:
- Chain access and signing go through `@parity/product-sdk-*` and the Host API — never a raw RPC/WebSocket client or a `polkadot-api` client on your own endpoint, and never write to storage outside the host path. (Content-addressed storage reads via public IPFS gateways are fine — see `fetchFromGateway`.)
- No browser-extension or injected wallets (MetaMask, polkadot-js extension, WalletConnect, QR pairing). Signing is approved on Polkadot Mobile.
- Contracts are Rust → PVM (PolkaVM) for `pallet-revive` — never EVM/Solidity, ink!, or WASM.
- Consult the `product-sdk-*` skills in `.claude/skills/` before hand-rolling SDK usage.

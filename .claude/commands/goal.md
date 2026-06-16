---
description: Brainstorm, plan, and build your own Polkadot app from this template.
---

The user's app idea: $ARGUMENTS

You are turning this template — currently the **RPS reference app** — into the
user's own Polkadot app. Drive the whole flow yourself (Sonnet), and **delegate
well-scoped implementation and review to Haiku subagents**: `feature-builder` to
implement a discrete task, `polkadot-reviewer` to check a diff. Read `CLAUDE.md`
first; its **Non-negotiables** bind everything below.

Before anything: make sure `./setup.sh` has run, and read the relevant
`product-sdk-*` skills in `.claude/skills/` for every SDK area the idea touches.

Work through these phases in order. Don't skip ahead — confirm with the user at
each gate.

1. **Brainstorm (ask, don't assume).** If `$ARGUMENTS` is empty, ask for the
   idea. Then ask focused questions **one at a time** to pin down: what the app
   does, the core user flow, what to keep from RPS (on-chain leaderboard?
   off-chain storage? multiplayer via Statement Store?), and what "done" looks
   like. Keep it to a handful of questions.

2. **Feasibility check.** Map the idea onto the template's capabilities — Host
   API signing, `@parity/product-sdk-*`, a Rust/PVM contract, Bulletin storage,
   Statement Store. If something needs a capability the SDK doesn't have, **say
   so plainly** — never plan a direct-RPC or browser-wallet workaround. Describe
   the plan in plain terms and get a thumbs-up before building.

3. **Plan.** Break the work into small, independently-verifiable tasks (e.g.
   "swap the game UI", "wire result → leaderboard contract", "store history on
   Bulletin"). Record the app concept and the plan to `.claude/memory/` so they
   survive compaction (see `CLAUDE.md` → Memory).

4. **Build incrementally.** For each task, either implement it yourself or
   dispatch a `feature-builder` subagent with a precise spec (exact files, what
   to keep, the conventions). Keep the app runnable between tasks. As you make
   durable decisions (contract package name, chains, domain), record them to
   `.claude/memory/`.

5. **Review.** Dispatch `polkadot-reviewer` on the diff to catch convention
   violations (direct RPC, browser wallets, EVM contracts, SDK misuse). Fix
   every blocker it reports.

6. **Verify.** Run `/dev` and tell the user how to open the app inside a
   Polkadot host (Mobile / Desktop / Web); signing is approved on Polkadot Mobile.

7. **Ship.** Remind the user to **rewrite `README.md` to describe THEIR app**
   (it's inlined into the App Detail Page), then run `/deploy <name>`.

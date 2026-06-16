# Polkadot App Template

A ready-to-mod Polkadot app. Open it in **Claude Code** and turn it into your
own app — on-chain leaderboard, decentralized storage, and mobile signing are
already wired up. It ships as a working **rock-paper-scissors** game you replace
with your idea.

> [!WARNING]
> This is a prototype, reference implementation, and proof-of-concept. The code
> is provided for research, experimentation, and developer education only. It has
> not been audited and may contain bugs or incomplete features. Use at your own
> risk.

## Start building

1. **Open this folder in Claude Code** and pick the **Sonnet 4.6** model.
2. **Run `/goal` with your idea**, for example:
   `/goal Build a Snake game with an on-chain high-score leaderboard`
   Claude brainstorms it with you, plans it, and builds it — installing
   everything it needs on its own (no manual setup).
3. **Preview with `/dev`**, then open the URL inside a Polkadot host (Mobile,
   Desktop, or Web) to log in and play. Signing is approved on Polkadot Mobile.
4. **Publish with `/deploy <name>`** to put it live at `<name>.dot`.

Don't have an idea yet? Open one of these and paste it into `/goal`:

<details>
<summary>💸 Tipping jar</summary>

```
/goal Build a tipping jar. Visitors connect through the Host API and send a PAS tip — preset amounts plus a custom field — to my address, optionally with a short thank-you message. Show a live feed of recent tips and a running total raised.
Keep RPS's wiring: record each tip on-chain via the contract and store the message on Bulletin; signing stays on Polkadot Mobile. No browser wallets, no direct RPC.
Done when: a connected user can send a tip, see it confirm, and watch the feed and total update.
```
</details>

<details>
<summary>🗳️ Decentralized poll</summary>

```
/goal Build a decentralized poll app. A creator posts a question with 2–4 options; any connected account can vote once, and results tally live with vote counts and percentages. Closed polls stay viewable as final results.
Keep RPS's wiring: store the poll on Bulletin and keep votes and tallies on-chain via the contract; enforce one vote per account; signing on Polkadot Mobile. No browser wallets, no direct RPC.
Done when: a user can create a poll, share it, vote once, and see the live tally update.
```
</details>

<details>
<summary>🧾 Group expense splitter</summary>

```
/goal Build a group expense splitter. Members of a group log shared expenses (who paid, the amount, who shares it); the app computes net balances — who owes whom — and lets people record a settle-up payment.
Keep RPS's wiring: store the expense log on Bulletin and keep balances and settlements on-chain via the contract; signing on Polkadot Mobile. No browser wallets, no direct RPC.
Done when: a group can add expenses, see correct net balances, and record a settle-up that updates them.
```
</details>

<details>
<summary>⭕ Tic-tac-toe vs an easy bot</summary>

```
/goal Replace the RPS game with tic-tac-toe against an easy bot that plays random legal moves. Player is X and moves first; detect wins, draws, and a full board, and offer a rematch.
Keep RPS's wiring untouched: each finished game updates the player's score on the on-chain leaderboard and stores the match history on Bulletin, exactly like RPS; signing on Polkadot Mobile. No browser wallets, no direct RPC.
Done when: a player can finish a game against the bot and see their score change on the leaderboard.
```
</details>

<details>
<summary>🐤 Flappy-bird-style game</summary>

```
/goal Replace the RPS game with a Flappy-Bird-style game: tap or press space to flap, gravity pulls down, dodge scrolling pipe gaps, score one point per pipe passed, game over on collision. Show the score live and a game-over screen with restart.
Keep RPS's wiring: when a run ends, submit the score to the on-chain leaderboard and store the run summary on Bulletin, reusing RPS's pattern; signing on Polkadot Mobile. No browser wallets, no direct RPC.
Done when: a player can play a run, crash, and see their best score on the leaderboard.
```
</details>

<details>
<summary>🐍 Snake</summary>

```
/goal Replace the RPS game with Snake: arrow keys steer a snake on a grid, eating food grows it and scores a point, the game ends on a wall or self collision. Speed up slightly as the snake grows; show the score live.
Keep RPS's wiring: on game over, record the score on the on-chain leaderboard and store the run on Bulletin, like RPS; signing on Polkadot Mobile. No browser wallets, no direct RPC.
Done when: a player can play a full run and see their score on the leaderboard.
```
</details>

<details>
<summary>👾 Pac-man-style maze game</summary>

```
/goal Replace the RPS game with a Pac-Man-style maze game: steer with arrow keys to collect every dot while avoiding two or three simple chasing ghosts; clearing the maze wins, getting caught ends the run. Score per dot; show score and lives.
Keep RPS's wiring: submit each run's score to the on-chain leaderboard and store the run on Bulletin, reusing RPS's pattern; signing on Polkadot Mobile. No browser wallets, no direct RPC.
Done when: a player can clear or lose a maze and see their score on the leaderboard.
```
</details>

<details>
<summary>🚢 Battleship vs a simple bot</summary>

```
/goal Replace the RPS game with Battleship against a simple bot: place your ships on a grid, then take turns firing; the bot fires randomly but hunts adjacent cells after a hit. Track hits and misses and declare a winner when one fleet is sunk.
Keep RPS's wiring: on finishing, record the win or loss on the on-chain leaderboard and store the match on Bulletin, like RPS; signing on Polkadot Mobile. No browser wallets, no direct RPC.
Done when: a player can finish a match against the bot and see the result on the leaderboard.
```
</details>

<details>
<summary>🔤 Hangman</summary>

```
/goal Replace the RPS game with Hangman: pick a random word from a word list, the player guesses letters with a limited number of misses, revealing correct letters until they solve it or run out. Show the masked word, used letters, and misses left.
Keep RPS's wiring: record each result (win or loss) on the on-chain leaderboard and store the game on Bulletin, reusing RPS's wiring; signing on Polkadot Mobile. No browser wallets, no direct RPC.
Done when: a player can finish a word (solved or lost) and see the result on the leaderboard.
```
</details>

## What's already set up

- **A working reference app** (rock-paper-scissors) to study and replace.
- **Host API + `@parity/product-sdk` wiring** — accounts, signing, chain
  reads/writes, decentralized storage, and a deployable contract.
- **SDK skills auto-fetched** into `.claude/skills/` by `setup.sh` (Claude reads
  these per-package guides as it builds).
- **Slash commands:** `/goal` (build your app), `/dev` (preview), `/deploy`
  (publish to a `.dot` name).
- **Haiku subagents:** `feature-builder` (implements scoped tasks) and
  `polkadot-reviewer` (enforces the Polkadot conventions) — Sonnet delegates to
  them during `/goal`.
- **A memory scratchpad** (`.claude/memory/`) so Claude remembers your decisions
  across a long session.
- **A smart-contract scaffold** (Rust → PVM) plus a CDM manifest.

## How to prompt well

- Lead with `/goal` and one clear sentence; let Claude ask the follow-ups.
- Say **what to keep** (on-chain leaderboard, storage, host signing) and **what
  to change** (the game/feature). The Idea-pool prompts above show the shape.
- Build one feature at a time and preview with `/dev` between changes.
- This app reaches the chain only through the Host API and `@parity/product-sdk`.
  If Claude ever suggests a browser/MetaMask wallet or a direct RPC endpoint,
  that's wrong for this template — tell it to use the Host API / product-sdk.
- **Before `/deploy`, rewrite this README to describe your app** — it's shown on
  your app's public Detail Page.

## Deploying your own copy

`/deploy <name>` handles the common path. To deploy your **own contract, own
`.dot` name, and a moddable fork** from scratch (forking, funding, CDM,
Playground CLI), follow the step-by-step [DEPLOYMENT.md](./DEPLOYMENT.md).

> Your account needs PAS tokens on Asset Hub
> ([faucet](https://faucet.polkadot.io/)) and a Bulletin storage allowance
> ([faucet](https://paritytech.github.io/polkadot-bulletin-chain/authorizations?tab=faucet)).

## Security

This is a reference proof-of-concept, **not a hardened production build**. Before
deploying it for any real use case, you are responsible for reviewing the code,
keeping dependencies up to date and free of known vulnerabilities, securing your
own fork or deployment (keys, secrets, network config), and tracking the latest
releases for security fixes.

For Parity's security disclosure process and Bug Bounty program, see
[parity.io/bug-bounty](https://parity.io/bug-bounty).

## License

Licensed under the [GNU General Public License v3.0 or later](./LICENSE)
(GPL-3.0-or-later).

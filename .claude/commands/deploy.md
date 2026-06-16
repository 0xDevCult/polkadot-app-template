---
description: Build and deploy the app to a .dot domain.
---

Deploy the app using `playground deploy`. The user's chosen domain name is: $ARGUMENTS

Steps:
1. If no domain name was provided in $ARGUMENTS, ask the user for one before proceeding (e.g. "reinhard" will become "reinhard.dot").
2. **Ensure the user is signed in and the contract namespace is theirs.** Sign-in is `playground login` (it shows a QR to scan and approve in the Polkadot app on the phone — there is **no** `playground init`). If the user isn't logged in, ask them to run `playground login` themselves. There's **no** command to read the handle (no `playground whoami`), so **ask the user for their handle**. If `contracts/leaderboard/Cargo.toml` still reads the placeholder `@your-username/leaderboard`, replace `your-username` with their handle across the repo: `grep -rn "@your-username/leaderboard" --include="*.ts" --include="*.toml" --include="*.json" . | grep -v node_modules`. (Skip the rename if it's already a real handle.)
3. **If the app's smart contract changed since the last deploy** (new or redeployed contract — a changed contract has a new on-chain address), **ask the user whether to publish under a new `<name>.dot` domain** instead of overwriting the existing one. A changed contract is effectively a new app version; re-pointing the old domain at it can strand the previous contract's users and state. If they want a new domain, use that name for the rest of this flow.
4. **Before publishing, ask the user to update what drives the App Detail Page:**
   - **`README.md`** — it's inlined into the published metadata and rendered on the app's Detail Page. Offer to help refresh it so it matches the current app.
   - **the tag** — pick the category that fits via `--tag <tag>` (one of: `site`, `social`, `chat`, `utility`, `gaming`, `marketplace`, `irl`).
   - Note honestly: the CLI publish path does **not** support a custom name/description/icon image — the name is the domain and the Detail Page uses a placeholder image. Don't promise an image upload.
5. Run `npm run build` to ensure a fresh build.
6. Run `playground deploy --no-build --buildDir dist --domain <name>.dot --signer phone --playground --tag <tag>` where `<name>` is the domain the user provided (strip any trailing `.dot` if they included it — the CLI adds it) and `<tag>` is the category chosen in step 4. Use a 5-minute timeout — deploys involve multiple on-chain transactions that wait for phone approval.
7. Show the user the output. There are **no push notifications** — tell the user to **open the Polkadot app on their phone** and approve each request as it appears (expect ~5: reserve domain, finalize domain, link content, link content, publish — the preflight's count and labels can be slightly off). **Tell them to approve promptly:** a request left too long fails with `createTransaction timed out — queue freed`, after which the CLI re-issues it (just approve the new one). Between the first two there's a deliberate ~60s pause (DotNS anti-front-running), not a hang.
8. If it succeeded, remind them to open `<name>.dot` inside a **Polkadot host** (Mobile, Desktop, or Web) to verify the deployment. On Desktop/Web tell them to **hard-refresh** (Cmd+Shift+R / Ctrl+Shift+R) — the browser may serve a cached version of the previous deploy.

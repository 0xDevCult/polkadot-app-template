# Project memory

Durable facts about **this app** as you mod the template — so context survives a
long building session and compaction. One fact per file in `.claude/memory/`,
indexed below (one line each).

**Write a memory** when you decide something that isn't obvious from the code:
the app concept, the contract package name you claimed, chains/endpoints, the
deploy domain, user preferences, or guidance the user gave you. Before adding
one, check this index for an entry to **update** instead of duplicating. Delete a
memory that turns out to be wrong.

Each memory is a file `.claude/memory/<slug>.md` with this shape:

```markdown
---
name: <short-kebab-slug>
description: <one-line summary, used to judge relevance later>
type: project   # user | feedback | project | reference
---

<The fact. For feedback/project, follow with **Why:** and **How to apply:** lines.>
```

Types: `user` (who the user is / preferences) · `feedback` (how you should work,
with the why) · `project` (this app's goals, decisions, constraints) ·
`reference` (URLs, dashboards, docs).

## Index

<!-- one line per memory: - [Title](slug.md) — short hook -->

- _(none yet — add entries here as you record decisions)_

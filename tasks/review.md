# Review

Daily briefing across all projects. Quick scan, not a deep dive.

## Step 1: Scan

Read across all projects in ~/tasks/projects/:
- plan.md — current focus line only
- todos.md — count open items, note #blocked / #deferred tags
- log.md — most recent entry only

Also read:
- ~/tasks/inbox.md
- ~/tasks/ideas.md

Skip dormant projects (no todos, no log entries, no plan set).

## Step 2: Present briefing

Use this exact format:

```
## Daily briefing — YYYY-MM-DD

**Inbox** — N items (list if ≤5, or "empty")

---

**<project>** · <current focus from plan.md>
- N open todos · N #blocked · N #deferred
- Last: <first sentence of most recent log entry>

**<project>** · <current focus from plan.md>
- N open todos · N #blocked · N #deferred
- Last: <first sentence of most recent log entry>

---

**Stale (>14 days)**
- <project>: <task summary> (YYYY-MM-DD)

**Ideas** — N total · N from last 7 days
- <idea summary> (if any recent)

**Quick wins** — tasks tagged #quick-win across all projects
- <project>: <task summary>
```

Omit any section that has nothing to report (e.g. no stale items = skip that section entirely).

## Step 3: Triage stale items

If there are any stale items (>14 days) or inbox items, go through them one at a time before asking about focus. For each one, ask: **keep**, **drop**, or **defer**?

- **Keep** — leave unchanged
- **Drop** — remove the item from the file
- **Defer** — update the date to today (resets the 14-day clock)

Also flag the jnye.blog placeholder task for dropping if it's still there.

## Step 4: Focus

Ask: "What do you want to focus on today?"

If they pick a project, hand off to [start.md](start.md) for that project.

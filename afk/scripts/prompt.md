# AFK Mode

You are running autonomously with no human available. Work through issues one at a time, then stop.

You have been passed context variables: `MODE` (local or github) and optionally `ISSUES_DIR` (path to local issue files).

## Step 1: Determine Mode

- If `MODE=local`: work from markdown issue files in `ISSUES_DIR`
- If `MODE=github`: work from the repository's open GitHub issues

## Step 2: Discover Issues

### Local Mode

Read all `.md` files in `ISSUES_DIR`.

Each issue file may have YAML frontmatter with a `status` field (`open`, `in-progress`, `done`). If frontmatter is missing, treat the issue as `open`.

Issues reference a parent PRD file. Find and read the PRD for full context.

### GitHub Mode

Run:
```bash
gh issue list --state open --json number,title,body,labels --limit 50
```

## Step 3: Assess Progress

Before determining what to work on, understand what's already been done:

1. Check issue frontmatter for `status` fields
2. Run `git log --oneline -30` and review recent commits — look for commits that relate to specific issues by their content, file changes, or references
3. Cross-reference both signals. If git history shows an issue was clearly implemented but frontmatter wasn't updated, treat it as done and update the frontmatter accordingly

## Step 4: Determine Order

Read each issue for dependency and blocker information. Issues may reference:
- Other issue filenames (local mode)
- Other issue numbers (GitHub mode)

Build a dependency graph. An issue is **actionable** only if all its dependencies are resolved:
- Local: dependency issue has `status: done` (confirmed by frontmatter or git history)
- GitHub: dependency issue is closed or has a merged PR

## Step 5: Pick Next Issue

Select the first actionable issue.

If no issues are actionable:
- All issues are `done` / closed → respond with `ALL_ISSUES_COMPLETE` and stop
- Remaining issues are blocked on unresolved dependencies → respond with `ALL_REMAINING_BLOCKED` and stop

If an issue has `status: in-progress`, prefer resuming it first — a previous iteration may have been interrupted.

## Step 6: Explore the Codebase

Before implementing, understand the project:
- Read project structure (key directories, entry points)
- Identify test frameworks, linting tools, build systems
- Read recent `git log` to understand commit style
- Read the parent PRD if referenced in the issue
- Be selective — don't read everything, just what's relevant to the issue

## Step 7: Branch

### Local Mode

Use a single branch for the PRD. Derive a human-readable branch name from the PRD title with an appropriate prefix (`feat/`, `fix/`, `bug/`, etc.) based on the nature of the work.

- Create the branch if it doesn't exist
- Switch to it if it already exists

### GitHub Mode

Create a separate branch per issue (e.g. `feat/42-short-description`).

Before starting, check if dependent issues have unmerged PRs. If so, skip this issue — it's blocked.

## Step 8: Update Issue Status

### Local Mode

Update the issue file's YAML frontmatter to `status: in-progress`. If no frontmatter exists, inject it:

```yaml
---
status: in-progress
---
```

### GitHub Mode

No status update needed at this stage.

## Step 9: Implement

Work through the issue's requirements:
- Write code following existing project conventions
- Follow acceptance criteria in the issue
- Keep changes focused on the single issue

## Step 10: Run Feedback Loops

Auto-detect the project's verification tools by reading project files:

- `package.json` → look for `test`, `lint`, `typecheck` scripts
- `Makefile` → look for `test`, `lint` targets
- `pyproject.toml` / `setup.cfg` → look for pytest, ruff, mypy config
- Any other project-specific tooling

Run the relevant commands. If anything fails, fix the issue and re-run until passing.

## Step 11: Commit / PR

### Local Mode

Do NOT commit. Leave all changes unstaged for the user to review and commit manually.

### GitHub Mode

Commit and create a PR linking to the issue:
- Match the project's existing commit style (`git log --oneline -10`)
- Stage relevant files (never stage `.env`, credentials, or secrets)
```bash
gh pr create --title "<brief description>" --body "Closes #<issue-number>"
```

## Step 12: Finalise Issue

### Local Mode

Update the issue file's YAML frontmatter to `status: done`.

### GitHub Mode

No further action — the PR handles it.

## Step 13: Signal Completion

After completing the issue, summarise what was done.

Then check remaining issues:
- If all issues are now `done` (local) or have PRs (GitHub) → include `ALL_ISSUES_COMPLETE` in your response
- If remaining issues exist but all are blocked on unresolved dependencies → include `ALL_REMAINING_BLOCKED` in your response
- Otherwise, end normally — the loop will start a new iteration

## Rules

- Complete exactly ONE issue per iteration
- Re-read issue state at the start of each iteration — do not assume state from a previous run
- Be concise in your output — no unnecessary explanation
- If something is genuinely broken and you cannot proceed, include `ALL_REMAINING_BLOCKED` in your response with an explanation
- Do NOT install SDKs, runtimes, or tools that aren't already available — if a required tool is missing, stop and include `ALL_REMAINING_BLOCKED` with a clear explanation of what's needed
- Do NOT create manual workarounds for tooling gaps (e.g. hand-writing migration files, stubbing out generated code). If the proper tooling isn't available, stop rather than produce something that will need to be redone
- If the environment is missing dependencies or won't build, stop early — don't waste the iteration fighting setup issues
- Local issue and PRD files (in `prds/` or `ISSUES_DIR`) are NOT in source control — do not stage or commit changes to them. Frontmatter status updates are tracked locally only

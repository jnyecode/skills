---
name: afk
description: Run Claude Code autonomously through a queue of issues. Use when user wants to run AFK, work through issues unattended, or automate issue execution.
argument-hint: [path-to-issues] [--iterations N]
---

Generate the `afk-claude.sh` command for the user based on context.

## Steps

1. **Check conversation context first.** If you've just created a PRD, generated issues, or have been working in a `prds/` directory — you already know the path. Use it.

2. **If no context available**, check `$ARGUMENTS` for a path or `--iterations` value.

3. **If still no path**, scan the current working directory:
   - Glob for `prds/**/*.md`
   - If multiple issue directories exist, ask the user which one
   - If one issue directory exists, use it
   - If no `prds/` directory, check for `.git/` and suggest GitHub mode
   - If neither, tell the user no issues were found

4. Default iterations to 50 unless specified in `$ARGUMENTS`.

5. Output the command for the user to copy and run in their terminal:

```
Run this in your terminal:

afk-claude.sh <path-to-issues> --iterations <N>
```

6. Briefly remind the user this runs with `--dangerously-skip-permissions` and is intended for a Docker sandbox.

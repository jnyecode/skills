# Wrap

Close out a work session cleanly. Infer as much as possible from the conversation history — don't make the user recap what just happened.

## Step 1: Infer the project

Check the current working directory against ~/tasks/projects/ (fuzzy match). If no match, ask.

## Step 2: Build a session summary from context

Review the full conversation history to determine:
- **What was accomplished** — code changes, decisions made, tasks captured, problems solved
- **Where things stand** — what's in progress, what's the immediate next step
- **Blockers** — anything waiting on someone/something else
- **Completed todos** — match accomplished work against open items in ~/tasks/projects/<project>/todos.md

## Step 3: Present the draft for confirmation

Show the user:
1. The proposed log entry
2. Any todos you plan to mark as done
3. The proposed plan.md updates (current focus, next steps, blocked)

Ask: "Does this look right, or anything to adjust?"

Only write to the files after the user confirms.

## Step 4: Write the updates

- Update ~/tasks/projects/<project>/plan.md with the new current focus, next steps, and blocked items
- Prepend a new log entry to ~/tasks/projects/<project>/log.md:

  ## YYYY-MM-DD
  <one sentence: what was accomplished>
  <one sentence: where things stand and what's next>

- Mark completed todos as done in todos.md (change [ ] to [x])

Confirm which files were updated and show the final log entry.

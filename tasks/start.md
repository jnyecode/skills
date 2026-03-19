# Start

Orient at the beginning of a work session.

1. Infer the project from the current working directory. Check if the directory name or repo name matches any project in ~/tasks/projects/ (fuzzy match is fine — e.g. "CarePad" matches "carepad", "castell/CarePad" matches "carepad"). If there's a match, suggest it: "Looks like you're in **carepad** — working on that?" If no match or the user declines, list the directories in ~/tasks/projects/ and ask.

2. Read the following files for that project:
   - ~/tasks/projects/<project>/plan.md
   - ~/tasks/projects/<project>/todos.md
   - ~/tasks/projects/<project>/log.md (most recent entry only)

3. Present a session summary with three sections:
   - **Last session:** one sentence from log.md
   - **Current plan:** current focus and next steps from plan.md
   - **Open todos:** list all unchecked items from todos.md

4. Ask: "Continuing from last session, or starting something new?"

5. Check todos.md for any items with a capture date older than 14 days from today. For each one, ask the user: keep, drop, or defer?
   - Drop: remove the item
   - Defer: update the date to today (resets the 14-day clock)
   - Keep: leave unchanged

Be concise. Do not pad the output. The user wants to get to work quickly.

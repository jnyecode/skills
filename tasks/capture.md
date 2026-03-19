# Capture

Sharpen a vague item into something actionable and put it in the right place.

## Flow

1. Ask: what's the item?
2. Dig into the details. Ask follow-up questions to get specifics — names, URLs, concrete next actions. Each task should be a single atomic action — if what they describe has multiple steps, split them into separate tasks. For example:
   - Vague: "Rebuild a local business website and email the owner" → Two tasks: "Build demo site for www.example.com" and "Email www.example.com owner with link to demo site"
   - Vague: "Look into caching" → Better: "Benchmark API response times and evaluate Redis vs in-memory cache"
3. Decide task or idea yourself based on what they described. Propose your call — they can override.
4. Suggest which project it belongs to. First check if the current working directory matches a project in ~/tasks/projects/ (fuzzy match — e.g. "CarePad" matches "carepad"). If so, default to that project. Otherwise, have an opinion based on the item's content — don't just list options. Use inbox only if it genuinely doesn't fit anywhere. If it sounds like it could become its own project, say so. If a new project is needed, follow the [project.md](project.md) workflow to create the full scaffold before writing the item.
5. Ask: one-line why — why does this matter?

Once you have all the details, propose the final formatted line(s) and ask for confirmation before writing. If you split an item into multiple tasks, show all of them.

If they skip the why, still save the item but append "— ⚠ no context" instead.

## Preserving context

Every URL, filename, tool name, or specific reference the user mentions MUST be recorded. These details are the whole point of capture — without them, the task is useless later.

If there are more details than fit on a single todo line, add them as indented notes beneath the task:

```
- [ ] 2026-03-18 · Build demo site for Chelmsford Club — want to gain new clients #feature
  - Current site: https://www.chelmsfordclub.com
  - Designs: ~/designs/chelmsford-club/v2.fig
```

When creating a new project, also write key references into plan.md under a `## References` section.

If the context is too rich for indented lines (multiple URLs, research, design rationale, competitor notes), suggest creating a standalone note in `~/tasks/projects/<project>/notes/<slug>.md` and link it from the todo line with `→ [[notes/<slug>]]`. Ask the user — don't create notes without confirmation.

## Formats

Tasks (goes in ~/tasks/projects/<project>/todos.md or ~/tasks/inbox.md):
- [ ] YYYY-MM-DD · <task> — <why> #tags

Ideas (goes in ~/tasks/projects/<project>/todos.md or ~/tasks/ideas.md):
- YYYY-MM-DD · <idea> — <why> #tags

Write the item to the correct file, then confirm by showing the exact line that was added.

## Important

This skill is ONLY for recording tasks and ideas. Once the item is written to the file, you are done. Do not offer to start working on the task, build anything, scaffold anything, or take any action beyond saving the item. Your job ends at confirmation.

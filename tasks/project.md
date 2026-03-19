# Project

Create a new project scaffold in the ~/tasks/ system.

Given a project name, create the full scaffold:

1. Create the directory: ~/tasks/projects/<project-name>/
2. Create the `notes/` subdirectory: ~/tasks/projects/<project-name>/notes/
3. Create these three files:

~/tasks/projects/<project-name>/todos.md:
```
# Todos — <project-name>

<!-- Format: - [ ] YYYY-MM-DD · <task> — <why it matters> #tags -->
<!-- Rich context goes in notes/ — link with → [[notes/<slug>]] -->
```

~/tasks/projects/<project-name>/plan.md:
```
# Plan — <project-name>

_Last updated: —_

## Current focus


## Next steps


## Blocked on


## References

```

~/tasks/projects/<project-name>/log.md:
```
# Session Log — <project-name>

<!-- Most recent entry at the top -->

```

4. Confirm by listing the files created.

If the project already exists, say so and do nothing.

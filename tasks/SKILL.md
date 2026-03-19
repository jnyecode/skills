---
name: tasks
description: Manage tasks, ideas, and projects in ~/tasks/. Use when user wants to review their day, start a session, capture a task/idea, wrap up a session, or create a new project. Also triggered by "start", "capture", "wrap", "review", "todo", "idea", or "new project".
argument-hint: <review|start|capture|wrap|project>
---

# Task Management

A file-based task and project management system.

## Step 1: Read system context

Read ~/tasks/SYSTEM.md first. It contains the folder structure, file formats, tagging conventions, Obsidian compatibility rules, and cross-referencing guidelines. All workflows depend on it.

## Step 2: Route to workflow

Determine the workflow from the user's argument or intent:

| Argument / Intent | Workflow file |
|---|---|
| `review` or daily overview | Read [review.md](review.md) |
| `start` or beginning a session | Read [start.md](start.md) |
| `capture` or adding a task/idea | Read [capture.md](capture.md) |
| `wrap` or ending a session | Read [wrap.md](wrap.md) |
| `project` or creating a new project | Read [project.md](project.md) |
| No argument or unclear | Ask: "What would you like to do — **review** your day, **start** a session, **capture** a task or idea, **wrap** up a session, or create a new **project**?" |

User input: $ARGUMENTS

Read the matching workflow file and follow its instructions exactly.

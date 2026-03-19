# AFK Skill — Setup

## Prerequisites

- `claude` CLI installed and on PATH
- `jq` installed (`brew install jq` on macOS)
- `gh` CLI installed and authenticated (`brew install gh` then `gh auth login`) — GitHub mode only
- Docker Desktop (for sandbox mode only)

## Add to PATH

Add the following to your `~/.zshrc` (or `~/.bashrc`):

```bash
export PATH="$HOME/.claude/skills/afk/scripts:$PATH"
```

Then reload your shell:

```bash
source ~/.zshrc
```

## Verify

```bash
afk-claude.sh --help
```

## Usage

```bash
# Local mode: work through issue MDs
afk-claude.sh ./prds/recurring-shifts-issues --iterations 10

# GitHub mode: work through open repo issues
afk-claude.sh --iterations 5
```

## Docker Sandbox (per-project)

For isolated runs with project-specific tooling, add a `.sandbox/` directory to your project.

### 1. Copy templates

```bash
mkdir .sandbox
cp ~/.claude/skills/afk/templates/sandbox/Dockerfile.node .sandbox/Dockerfile   # or Dockerfile.dotnet
cp ~/.claude/skills/afk/templates/sandbox/.env.example .sandbox/.env.example
cp ~/.claude/skills/afk/templates/sandbox/.gitignore .sandbox/.gitignore
cp ~/.claude/skills/afk/templates/sandbox/config.json .sandbox/config.json
```

### 2. Configure auth

```bash
cp .sandbox/.env.example .sandbox/.env
# Fill in CLAUDE_CODE_OAUTH_TOKEN and GH_TOKEN
```

### 3. Customise the Dockerfile

Edit `.sandbox/Dockerfile` for your project's stack. Available templates:
- `Dockerfile.node` — Node 22, pnpm, gh, Claude CLI
- `Dockerfile.dotnet` — .NET SDK 9, EF tools, gh, Claude CLI

### 4. Run

When `afk-claude.sh` detects `.sandbox/Dockerfile` in the current directory, it automatically builds and runs inside the container.

## Project Makefile (optional)

Add a convenience target to your project's Makefile:

```makefile
# Run AFK on a specific PRD's issues
afk:
	afk-claude.sh ./prds/$(PRD)

# Usage: make afk PRD=recurring-shifts-issues
```

Or hardcode a default:

```makefile
afk:
	afk-claude.sh ./prds/recurring-shifts-issues
```

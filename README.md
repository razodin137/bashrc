# bashrc — custom git workflow commands

Custom shell commands for managing git workflows. These are some of the most helpful tools for day-to-day git work.

**Repository:** [razodin137/bashrc](https://github.com/razodin137/bashrc)

## The commands

- **gnew** — create a new project (a new git repo, set up and ready to go). See [commands/gnew.md](./commands/gnew.md).
- **gnew-p** — same as `gnew`, but for private projects. See [commands/gnew-p.md](./commands/gnew-p.md).
- **gconnect** — sync a directory with an existing repo. See [commands/gconnect.md](./commands/gconnect.md).
- **gclone** — pick one of your GitHub repos from a fuzzy-find list and clone it. See [commands/gclone.md](./commands/gclone.md).
- **gtag** — help an AI agent understand your project: logs, project directories, versioning, notes and more, all handled automatically by your usage of git. See [commands/gtag.md](./commands/gtag.md).
- **performance-mode** — set the CPU governor to performance. See [commands/performance-mode.md](./commands/performance-mode.md).

## Installation

Add a command to your `.bashrc`:

```bash
sudo nano ~/.bashrc
```

…or use the included [syncbash.sh](./syncbash.sh), which syncs the git aliases into your `~/.bashrc` between marker comments (so they can be re-synced cleanly any time).

## Repository layout

- `commands/` — one markdown file per command, ready to paste into your shell config.
- `syncbash.sh` — syncs the aliases into `~/.bashrc`.
- [agents_context.md](./agents_context.md) — auto-generated project context for AI agents.
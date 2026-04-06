# NewNa.AI Power BI Plugin

Development toolkit for Power BI PBIP projects. Automates cache cleanup, documentation, code review, and optimization.

## Hook

| Hook | Trigger | What it does |
|------|---------|-------------|
| pbip-cache-cleanup | Before `git add`/`git commit` | Deletes `.pbi/` cache (sensitive data: `cache.abf`, `localSettings.json`) |

## Slash Commands

| Command | What it does |
|---------|-------------|
| `/pbip-scaffold` | Initialize a PBIP repo with .gitignore, dictionary, changelog, README |
| `/data-dictionary` | Generate/refresh data dictionary from TMDL files |
| `/measure-cleanup` | Find and remove unused measures (spawns measure-analyzer agent) |
| `/dax-optimize` | Scan DAX for anti-patterns and suggest rewrites (spawns dax-analyzer agent) |
| `/pbip-review` | Comprehensive 9-point model audit (spawns pbip-reviewer agent) |

## Auto-Trigger Skills

| Skill | When it fires |
|-------|--------------|
| data-dictionary | After model edits (also available as `/data-dictionary`) |
| pbip-changelog | At natural stopping points — maintains append-only change history |

## Agents

| Agent | Spawned by | What it does |
|-------|-----------|-------------|
| measure-analyzer | `/measure-cleanup` | Scans all measures, builds reference graph, identifies dead code |
| dax-analyzer | `/dax-optimize` | Checks DAX for anti-patterns, rates complexity, suggests rewrites |
| pbip-reviewer | `/pbip-review` | Runs 9 review checks: relationships, naming, TMDL lint, RLS, performance, visuals, accessibility, bookmarks, best practices |

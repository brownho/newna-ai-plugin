# NewNa.AI Plugin Marketplace

Claude Code plugin marketplace for the [newna.ai](https://newna.ai) VPS. Three plugins covering MCP server management, Power BI development, and server operations.

## Install

```bash
claude plugin marketplace add brownho/newna-ai-plugin
claude plugin install newna-mcp@newna-ai
claude plugin install newna-powerbi@newna-ai
claude plugin install newna-ops@newna-ai
```

## Plugins

### newna-mcp — Infrastructure

MCP server installers, git automation, and hands-free version control.

| Type | Name | Description |
|------|------|-------------|
| Skill | git-autopilot | Auto-manages git: init, commit, push, README maintenance |
| Skill | install-mcp | Auto-detects environment, installs MCP servers |
| Command | `/newna-install-mcp` | Manual MCP server install trigger |
| MCP | powerbi-knowledge | Power BI knowledge base (DAX, M, data modeling) |

### newna-powerbi — Power BI Development

PBIP project toolkit: cache cleanup, measure management, DAX optimization, documentation, and model review.

| Type | Name | Description |
|------|------|-------------|
| Hook | pbip-cache-cleanup | Deletes `.pbi/` cache before git commits |
| Command | `/pbip-scaffold` | Initialize PBIP repo with .gitignore, dictionary, changelog |
| Command | `/data-dictionary` | Generate/refresh data dictionary from TMDL |
| Command | `/measure-cleanup` | Find and remove unused measures |
| Command | `/dax-optimize` | Scan DAX for anti-patterns, suggest rewrites |
| Command | `/pbip-review` | 9-point model audit (relationships, naming, RLS, a11y, ...) |
| Skill | pbip-changelog | Auto-maintains append-only change history |
| Agent | measure-analyzer | Builds measure reference graphs |
| Agent | dax-analyzer | Checks DAX against anti-pattern library |
| Agent | pbip-reviewer | Runs 9 independent review checks |

### newna-ops — Server Operations

Deployment, monitoring, security, and maintenance for the newna.ai VPS.

| Type | Name | Description |
|------|------|-------------|
| Hook | ssl-cert-monitor | Warns on session start if SSL cert expires within 30 days |
| Hook | secret-scanner | Blocks git commits containing API keys or .env files |
| Hook | nginx-guard | Auto-backs up nginx config before edits |
| Command | `/deploy <app>` | Safe deploy with health checks and rollback |
| Command | `/server-health` | 11-point health audit (PM2, Docker, nginx, SSL, DB, disk) |
| Command | `/analyze-logs` | Scan logs for errors, crash patterns, root causes |
| Command | `/db-maintain` | SQLite integrity, WAL checkpoint, VACUUM, ANALYZE |
| Skill | backup-verifier | Verify daily backups to Google Drive |
| Skill | restart-analyzer | Investigate PM2 crash loops and find root causes |
| Agent | deploy-agent | Handles full deployment workflow |
| Agent | health-agent | Runs all health checks |
| Agent | log-analyzer | Correlates errors across log sources |
| MCP | newna-admin-api | Exposes admin panel API endpoints |

## Totals

- **4 hooks** — automatic safety nets
- **10 slash commands** — explicit actions
- **4 auto-trigger skills** — proactive maintenance
- **6 agents** — heavy analysis and autonomous tasks
- **2 MCP servers** — direct API access

## Server Requirements

- GoDaddy VPS running Ubuntu 24.04
- Node.js 22+, PM2, nginx, Docker
- SQLite3, certbot, fail2ban, UFW

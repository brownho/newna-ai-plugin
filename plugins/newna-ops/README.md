# NewNa.AI Ops Plugin

Server operations toolkit for the newna.ai VPS. Automates deployments, health monitoring, log analysis, database maintenance, security, and backup verification.

## Hooks (automatic, invisible)

| Hook | Trigger | What it does |
|------|---------|-------------|
| ssl-cert-monitor | SessionStart | Warns if SSL cert expires within 30 days |
| secret-scanner | Before git add/commit | Blocks commits containing API keys, .env files, private keys |
| nginx-guard | Before Edit/Write to /etc/nginx/ | Auto-backs up config before edits |

## Slash Commands

| Command | Agent | What it does |
|---------|-------|-------------|
| `/deploy <app>` | deploy-agent | Full deployment: pull, install, audit, health check, restart, rollback |
| `/server-health` | health-agent | 11-point health audit (PM2, Docker, nginx, SSL, DB, disk, firewall, backups) |
| `/analyze-logs` | log-analyzer | Scan all log sources for errors, crash patterns, root causes |
| `/db-maintain` | — | SQLite maintenance: integrity, WAL checkpoint, VACUUM, ANALYZE |

## Auto-Trigger Skills

| Skill | When it fires |
|-------|--------------|
| backup-verifier | When backups are mentioned, or `/verify-backup` |
| restart-analyzer | When PM2 restart counts are high, app crashes, or instability detected |

## MCP Server

Exposes the newna-admin API (50+ endpoints) as an MCP server for direct Claude access to system stats, database queries, service management, and file operations.

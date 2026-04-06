---
name: server-health
description: Comprehensive health check of the newna.ai VPS. Checks PM2, Docker, nginx, SSL, databases, disk, firewall, backups, and system resources. Use when the user says "check server health", "is the server ok", "server status", "what's running", "health check", or invokes /server-health. Also use proactively when something seems wrong (high restart counts, errors, slow responses).
allowed-tools: [Bash, Read, Grep, Agent]
---

# /server-health

Run a full health audit of the newna.ai VPS by spawning the `health-agent`.

## What it checks

1. **PM2** — process status, restart counts, memory usage
2. **Docker** — container health (deploy-api-1, gitea, filebrowser, portainer)
3. **Nginx** — config validity, service status
4. **SSL** — certificate expiry (warns at 30 days)
5. **Databases** — SQLite integrity, WAL sizes (admin.db, chat.db)
6. **Disk** — partition usage (warns at 80%)
7. **Memory** — available RAM (warns below 1GB)
8. **Firewall** — UFW status, expected ports
9. **Fail2ban** — SSH jail status, banned IPs
10. **Systemd** — failed units, backup timer status
11. **Backups** — last backup run, any errors

Spawn the `health-agent` and present its report organized by severity.

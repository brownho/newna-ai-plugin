---
name: deploy
description: Deploy newna.ai applications safely with health checks and rollback. Use when the user says "deploy", "push to production", "restart the app", "update the server", "ship it", or invokes /deploy. Spawns deploy-agent for the full deployment workflow.
argument-hint: <app-name> [newna-admin|newna-chat|all]
allowed-tools: [Bash, Read, Grep, Agent]
---

# /deploy

Safe deployment for newna.ai applications with pre-flight checks, health verification, and automatic rollback.

Arguments: $ARGUMENTS

## Apps

| Name | Directory | PM2 | Port |
|------|-----------|-----|------|
| `newna-admin` | `/home/sabro/projects/newna-admin` | `newna-admin` | 3000 |
| `newna-chat` | `/home/sabro/projects/NewNa.Ai-ChatApp` | `newna-chat` | 3001 |
| `all` | Both | Both | Both |

If no argument, ask which app to deploy.

## Workflow

Spawn the `deploy-agent` with the app name. It handles:
1. Check for uncommitted changes (abort if dirty)
2. Record current commit for rollback
3. `git pull origin main`
4. `npm ci --production`
5. `npm audit --audit-level=critical`
6. Pre-restart health check
7. `pm2 restart <name> --update-env`
8. Post-restart health check (5s wait)
9. Rollback if unhealthy

**Important:** Only restart PM2 once per deploy. Do NOT call `pm2 restart` multiple times.

After the agent returns, report the deployment result to the user.

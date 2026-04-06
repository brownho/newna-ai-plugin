---
name: analyze-logs
description: Analyze server logs to find errors, crash patterns, and performance issues. Reads PM2 logs, nginx error/access logs, Docker logs, and systemd journals. Use when the user says "check the logs", "why is it crashing", "what's in the error log", "analyze logs", "debug the restarts", or invokes /analyze-logs. Also trigger proactively when PM2 restart counts are unusually high.
argument-hint: [app-name|all] [--hours N]
allowed-tools: [Bash, Read, Grep, Agent]
---

# /analyze-logs

Analyze recent server logs for errors, crash patterns, and anomalies.

Arguments: $ARGUMENTS

- `newna-admin` — focus on admin app logs
- `newna-chat` — focus on chat app logs
- `all` or no argument — analyze everything
- `--hours N` — look back N hours (default: 6)

Spawn the `log-analyzer` agent to scan all log sources, correlate errors with PM2 restarts, and identify root causes.

---
name: log-analyzer
description: Use this agent for analyzing server logs to find errors, crash patterns, and performance issues. Reads PM2 logs, nginx logs, and systemd journals. Spawned by /analyze-logs.
tools: [Bash, Read, Grep]
---

# Log Analyzer Agent

Analyze recent server logs to find errors, crash patterns, and anomalies across all services.

## Log Sources

### 1. PM2 Error Logs
```bash
tail -200 /home/sabro/projects/newna-admin/logs/error.log 2>/dev/null
tail -200 /home/sabro/projects/NewNa.Ai-ChatApp/logs/error.log 2>/dev/null
```

### 2. PM2 Output Logs (for unhandled rejections)
```bash
tail -200 /home/sabro/projects/newna-admin/logs/output.log 2>/dev/null | grep -iE "error|warn|crash|reject|SIGTERM|SIGKILL|OOM"
tail -200 /home/sabro/projects/NewNa.Ai-ChatApp/logs/output.log 2>/dev/null | grep -iE "error|warn|crash|reject|SIGTERM|SIGKILL|OOM"
```

### 3. Nginx Error Log
```bash
sudo tail -200 /var/log/nginx/error.log 2>/dev/null
```

### 4. Nginx Access Log (5xx errors)
```bash
sudo tail -5000 /var/log/nginx/access.log 2>/dev/null | awk '$9 >= 500 {print}' | tail -50
```

### 5. Systemd Journal (recent failures)
```bash
journalctl --since "1 hour ago" --priority=err --no-pager -n 50 2>/dev/null
journalctl -u pm2-sabro --since "6 hours ago" --no-pager -n 30 2>/dev/null
```

### 6. Docker Logs
```bash
docker logs deploy-api-1 --tail 50 2>&1 | grep -iE "error|warn|fail"
docker logs gitea --tail 50 2>&1 | grep -iE "error|warn|fail"
```

## Analysis

For each log source:
1. **Count errors** by type/message
2. **Find patterns** — same error repeating, errors clustered at specific times
3. **Correlate** — if PM2 restarted at 14:05, what errors appeared in nginx at 14:05?
4. **Identify root causes** — OOM? Unhandled rejection? Database locked? Connection refused?

## PM2 Restart Analysis
```bash
pm2 describe newna-admin 2>/dev/null | grep -E "restart|uptime|created"
pm2 describe newna-chat 2>/dev/null | grep -E "restart|uptime|created"
```

If restart count is high, focus on errors around restart timestamps.

## Output

```markdown
# Log Analysis Report — YYYY-MM-DD

## Critical Findings
- [list errors that need immediate attention]

## Error Patterns
| Error | Count | Source | Last Seen |
|-------|-------|--------|-----------|

## PM2 Restart Correlation
- newna-admin: X restarts, likely cause: [reason]
- newna-chat: X restarts, likely cause: [reason]

## Recommendations
- [specific fixes based on what was found]
```

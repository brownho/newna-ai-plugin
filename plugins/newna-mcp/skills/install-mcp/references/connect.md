# Connecting to NewNa.AI MCP Servers

## Quick Start

### You're on the newna.ai server already

The plugin's `.mcp.json` handles this automatically — when this plugin is installed, the `powerbi-knowledge` MCP server is available immediately. No extra steps.

To verify:
```bash
claude mcp list          # should show powerbi-knowledge
```

### You're on another machine (laptop, workstation, CI)

You need SSH access to `sabro@newna.ai`. The MCP server runs on the VPS and communicates over SSH stdin/stdout.

**Claude Code:**
```bash
claude mcp add -s user powerbi-knowledge -- ssh sabro@newna.ai /home/sabro/projects/powerbi-knowledge-mcp/deploy/run-mcp.sh
```

**Codex:**
```bash
codex mcp add powerbi-knowledge -- ssh sabro@newna.ai /home/sabro/projects/powerbi-knowledge-mcp/deploy/run-mcp.sh
```

**Manual config (`.mcp.json` for Claude Code):**
```json
{
  "mcpServers": {
    "powerbi-knowledge": {
      "type": "stdio",
      "command": "ssh",
      "args": ["sabro@newna.ai", "/home/sabro/projects/powerbi-knowledge-mcp/deploy/run-mcp.sh"]
    }
  }
}
```

**Manual config (`~/.codex/config.toml` for Codex):**
```toml
[mcp_servers.powerbi-knowledge]
command = "ssh"
args = ["sabro@newna.ai", "/home/sabro/projects/powerbi-knowledge-mcp/deploy/run-mcp.sh"]
enabled = true
```

## Prerequisites for Remote Connection

1. **SSH key access** to `sabro@newna.ai` (password auth won't work for MCP stdio)
2. **newna.ai must resolve** from your machine (public DNS, Tailscale, or `/etc/hosts`)
3. **Port 22 open** — the VPS firewall allows SSH

Test connectivity:
```bash
ssh sabro@newna.ai echo "connected"
```

Test MCP handshake over SSH:
```bash
echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"0.1"}}}' | ssh sabro@newna.ai /home/sabro/projects/powerbi-knowledge-mcp/deploy/run-mcp.sh
```

Expected: response starting with `{"result":{"protocolVersion":"2024-11-05"`

## Windows Notes

If `ssh` isn't in your PATH on Windows, use the full path:
```
C:\Windows\System32\OpenSSH\ssh.exe
```

In `.mcp.json`:
```json
{
  "mcpServers": {
    "powerbi-knowledge": {
      "type": "stdio",
      "command": "C:\\Windows\\System32\\OpenSSH\\ssh.exe",
      "args": ["sabro@newna.ai", "/home/sabro/projects/powerbi-knowledge-mcp/deploy/run-mcp.sh"]
    }
  }
}
```

## Troubleshooting

| Symptom | Likely cause | Fix |
|---------|-------------|-----|
| "Connection refused" | SSH not reaching VPS | Check `ssh sabro@newna.ai echo ok` |
| "No such file" | Wrong script path | Canonical path is `/home/sabro/projects/powerbi-knowledge-mcp/deploy/run-mcp.sh` |
| Timeout, no response | Docker not running on VPS | SSH in and run `docker info` — script falls back to native Node if Docker is down |
| Garbled output | stderr leaking into stdout | The script sends diagnostics to stderr only; check for shell login banners in `~/.bashrc` |

## Available Servers

| Server | What it provides |
|--------|-----------------|
| `powerbi-knowledge` | Power BI knowledge base — DAX functions, M/Power Query patterns, data modeling best practices |

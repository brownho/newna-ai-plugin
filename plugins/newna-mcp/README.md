# NewNa.AI MCP Plugin

Plugin for installing, managing, and serving MCP servers hosted on the newna.ai VPS. Also handles git automatically so you never have to think about version control.

## Skills

| Skill | Type | What it does |
|-------|------|-------------|
| **install-mcp** | Auto-trigger | Detects environment and installs MCP servers into Claude Code / Codex |
| **newna-install-mcp** | Slash command | `/newna-install-mcp [server-name]` — manual install trigger |
| **git-autopilot** | Auto-trigger | Initializes git, commits at natural stopping points, handles best practices |

## MCP Servers (served via .mcp.json)

When installed on the newna.ai server, the plugin automatically serves:

| Server | Description |
|--------|-------------|
| powerbi-knowledge | Power BI knowledge base (DAX, M/Power Query, data modeling) |

For remote connection instructions, see `skills/install-mcp/references/connect.md`.

## Usage

```
/newna-install-mcp                      # install all servers
/newna-install-mcp powerbi-knowledge    # install specific server
```

Or just say "set up MCP servers" or "connect to newna.ai" in conversation.

Git is managed automatically — commits happen at natural stopping points without you asking.

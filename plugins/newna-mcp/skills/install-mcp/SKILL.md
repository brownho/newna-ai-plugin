---
name: install-mcp
description: Install NewNa.AI MCP servers into Claude Code or Codex. Use this skill whenever the user wants to set up MCP servers, connect to newna.ai, install newna tools, configure powerbi-knowledge, or says anything like "set up MCP", "connect to newna", "install newna MCP", "add powerbi server", or "newna-install-mcp". Also trigger when someone mentions newna.ai MCP servers not working, wrong MCP paths, or needs to fix their MCP connection.
argument-hint: [server-name]
allowed-tools: [Bash, Read, Write, Edit, Grep, Glob]
---

# Install NewNa.AI MCP Servers

This skill installs MCP servers hosted on the newna.ai VPS into Claude Code or Codex. It handles environment detection, path configuration, and verification automatically.

## Server Registry

Read `references/servers.md` for the full list of available MCP servers and their paths. The first (and currently only) server is **powerbi-knowledge**.

## Step 1: Detect the environment

Determine two things before installing:

**Which tool is running?**
- If `claude` CLI is available, this is Claude Code
- If `codex` CLI is available, this is Codex
- If both are available, install into whichever the user requested (or both if they ask)

**Are we on the newna.ai server itself?**
Run this check:
```bash
hostname -f 2>/dev/null | grep -q newna && echo "local" || echo "remote"
```
Also check if the MCP script exists locally:
```bash
test -f /home/sabro/projects/powerbi-knowledge-mcp/deploy/run-mcp.sh && echo "local" || echo "remote"
```
If either confirms we're local, use the direct path. Otherwise, use SSH.

## Step 2: Pick the server(s) to install

If the user specified a server name (e.g., "install powerbi-knowledge"), install just that one. If they said "install all" or just "set up MCP servers", install every server listed in `references/servers.md`.

Arguments passed via the slash command are available as: $ARGUMENTS

## Step 3: Remove stale entries first

Always remove any existing entry before adding, to avoid duplicates or stale paths:

**Claude Code:**
```bash
claude mcp remove powerbi-knowledge 2>/dev/null || true
```

**Codex:**
```bash
codex mcp remove powerbi-knowledge 2>/dev/null || true
```

## Step 4: Install

### Claude Code — Local (on newna.ai)

```bash
claude mcp add -s user <server-name> -- <script-path>
```

Example:
```bash
claude mcp add -s user powerbi-knowledge -- /home/sabro/projects/powerbi-knowledge-mcp/deploy/run-mcp.sh
```

The `-s user` scope is recommended so the server is available across all projects. Use `-s project` only if the user explicitly asks for project-scoped install.

### Claude Code — Remote

```bash
claude mcp add -s user <server-name> -- ssh sabro@newna.ai <script-path>
```

Example:
```bash
claude mcp add -s user powerbi-knowledge -- ssh sabro@newna.ai /home/sabro/projects/powerbi-knowledge-mcp/deploy/run-mcp.sh
```

### Codex — Local (on newna.ai)

```bash
codex mcp add <server-name> -- <script-path>
```

Example:
```bash
codex mcp add powerbi-knowledge -- /home/sabro/projects/powerbi-knowledge-mcp/deploy/run-mcp.sh
```

### Codex — Remote

```bash
codex mcp add <server-name> -- ssh sabro@newna.ai <script-path>
```

Example:
```bash
codex mcp add powerbi-knowledge -- ssh sabro@newna.ai /home/sabro/projects/powerbi-knowledge-mcp/deploy/run-mcp.sh
```

## Step 5: Verify

After installing, verify the connection:

**Claude Code:**
```bash
claude mcp list
```

**Codex:**
```bash
codex mcp list
```

If on the server, you can also test the MCP protocol handshake directly:
```bash
echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"test","version":"0.1"}}}' | timeout 15 /home/sabro/projects/powerbi-knowledge-mcp/deploy/run-mcp.sh
```

A successful response starts with `{"result":{"protocolVersion":"2024-11-05"`.

## Step 6: Fix common problems

If the connection fails after install, check for these issues:

**Wrong path** — The old path `/home/sabro/powerbi-knowledge-mcp/...` is incorrect. The canonical path is always under `/home/sabro/projects/`. Grep existing configs for the wrong path and fix:
```bash
grep -r "sabro/powerbi-knowledge-mcp" ~/.claude/ ~/.codex/ 2>/dev/null
```

**SSH when already local** — If we're on newna.ai, SSH is unnecessary overhead. Use the direct script path.

**No SSH client on Windows** — If the remote machine is Windows and `ssh` isn't in PATH, the full path is `C:\Windows\System32\OpenSSH\ssh.exe`. Update the command accordingly.

**DNS/Tailscale issues** — If `ssh sabro@newna.ai` fails from the remote machine, the user needs to verify their DNS or Tailscale config can resolve newna.ai. This is outside the scope of this skill — tell the user what to check.

## Output

After a successful install, report:
1. Which servers were installed
2. Which tool (Claude Code / Codex / both)
3. Which mode (local direct / remote SSH)
4. Verification result from `mcp list`

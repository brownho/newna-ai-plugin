# NewNa.AI MCP Server Registry

Each entry defines one MCP server hosted on the newna.ai VPS.

## powerbi-knowledge

| Field | Value |
|-------|-------|
| **Name** | `powerbi-knowledge` |
| **Script** | `/home/sabro/projects/powerbi-knowledge-mcp/deploy/run-mcp.sh` |
| **Description** | Power BI knowledge base — DAX, M/Power Query, data modeling, and best practices |
| **Runtime** | Docker (preferred) or native Node.js 22+ fallback |
| **Protocol** | MCP stdio (JSON-RPC over stdin/stdout) |

### Wrong paths (do not use)

These are legacy/incorrect paths that may appear in old configs. Replace them with the canonical path above:

- `/home/sabro/powerbi-knowledge-mcp/deploy/run-mcp.sh`
- `/home/sabro/powerbi-knowledge-mcp/run-mcp.sh`
- Any path not under `/home/sabro/projects/`

---

*To add a new server, copy the template above and fill in the fields. The install-mcp skill will automatically pick it up.*

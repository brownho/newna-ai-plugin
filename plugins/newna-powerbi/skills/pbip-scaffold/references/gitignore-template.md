# .gitignore Template for PBIP Projects

Use this as the baseline `.gitignore` for any Power BI PBIP project.

```gitignore
# ============================================
# Power BI PBIP — Git Ignore
# ============================================

# Cache and local settings (NEVER commit — contains data + user prefs)
**/.pbi/
**/cache.abf
**/localSettings.json
**/editorSettings.json

# Diagram layout (user-specific visual arrangement)
**/diagramLayout.json

# Platform deployment metadata (contains workspace GUIDs, not model content)
**/.platform

# Legacy Power BI binary formats
*.pbix
*.pbit

# ============================================
# Development tools
# ============================================

# Node.js
node_modules/
package-lock.json

# Python
__pycache__/
*.py[cod]
*.egg-info/
.venv/
venv/

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# ============================================
# Secrets and environment
# ============================================
.env
.env.local
.env.*.local
*.pem
*.key
credentials.json

# ============================================
# Data and caches
# ============================================
*.db
*.db-journal
*.db-wal
*.db-shm
.cache/

# ============================================
# OS
# ============================================
.DS_Store
Thumbs.db
```

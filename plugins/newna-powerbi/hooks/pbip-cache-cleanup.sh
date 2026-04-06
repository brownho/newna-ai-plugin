#!/usr/bin/env bash
# pbip-cache-cleanup.sh — PreToolUse hook for Bash tool
#
# Fires before every Bash tool use. If the command is a git add/commit
# inside a PBIP project, deletes .pbi/ cache files (sensitive data)
# and ensures .pbi/ is in .gitignore.
#
# Designed to be fast: exits immediately when not in a PBIP context.
set -euo pipefail

# Read tool input from stdin (Claude Code passes JSON)
INPUT=$(cat)

# Extract the bash command from the tool input
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null || true)

# Fast exit: only act on git add/commit commands
case "$COMMAND" in
  *"git add"*|*"git commit"*) ;;
  *) exit 0 ;;
esac

# Determine the working directory from the command or use PWD
WORK_DIR="${PWD}"

# Find the nearest directory containing a .pbip file (walk up from WORK_DIR)
find_pbip_root() {
  local dir="$1"
  while [ "$dir" != "/" ]; do
    if ls "$dir"/*.pbip 1>/dev/null 2>&1; then
      echo "$dir"
      return 0
    fi
    # Also check if we're inside a .SemanticModel or .Report directory
    if ls "$dir"/../*.pbip 1>/dev/null 2>&1; then
      echo "$(cd "$dir/.." && pwd)"
      return 0
    fi
    dir="$(dirname "$dir")"
  done
  return 1
}

PBIP_ROOT=$(find_pbip_root "$WORK_DIR" 2>/dev/null) || exit 0

# Found a PBIP project — clean .pbi/ directories
find "$PBIP_ROOT" -type d -name ".pbi" 2>/dev/null | while read -r pbi_dir; do
  # Delete sensitive cache files
  rm -f "$pbi_dir/cache.abf" 2>/dev/null || true
  rm -f "$pbi_dir/localSettings.json" 2>/dev/null || true
  rm -f "$pbi_dir/editorSettings.json" 2>/dev/null || true
done

# Ensure .pbi/ is in .gitignore
GITIGNORE="$PBIP_ROOT/.gitignore"
if [ -f "$GITIGNORE" ]; then
  if ! grep -q '^\*\*/\.pbi/' "$GITIGNORE" 2>/dev/null && \
     ! grep -q '^\*\*/.pbi/' "$GITIGNORE" 2>/dev/null && \
     ! grep -q '^\.pbi/' "$GITIGNORE" 2>/dev/null && \
     ! grep -q '^\*\*/\.pbi$' "$GITIGNORE" 2>/dev/null; then
    printf '\n# Power BI cache (auto-added by pbip-cache-cleanup hook)\n**/.pbi/\n' >> "$GITIGNORE"
  fi
else
  printf '# Power BI cache (auto-added by pbip-cache-cleanup hook)\n**/.pbi/\n' > "$GITIGNORE"
fi

exit 0

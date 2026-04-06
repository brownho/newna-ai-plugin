#!/usr/bin/env bash
# nginx-guard.sh — PreToolUse hook for Edit/Write tools
# Auto-backs up nginx config before edits, validates after.
set -euo pipefail

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null || true)

# Only act on nginx config files
case "$FILE_PATH" in
  /etc/nginx/*) ;;
  *) exit 0 ;;
esac

# Create timestamped backup before the edit happens
BACKUP="${FILE_PATH}.bak.$(date +%Y%m%d%H%M%S)"
if [ -f "$FILE_PATH" ]; then
  sudo cp "$FILE_PATH" "$BACKUP" 2>/dev/null || true
  echo "Backed up: ${FILE_PATH} → ${BACKUP}"
fi

# The edit will proceed after this hook exits 0.
# Post-edit validation happens via the nginx-guard skill which
# tells Claude to always run `sudo nginx -t` after editing nginx files.
exit 0

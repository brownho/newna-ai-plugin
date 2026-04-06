#!/usr/bin/env bash
# secret-scanner.sh — PreToolUse hook for Bash tool
# Blocks git add/commit if staged files contain secrets.
set -euo pipefail

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null || true)

# Only check git add/commit
case "$COMMAND" in
  *"git add"*|*"git commit"*) ;;
  *) exit 0 ;;
esac

# Check staged files for secret patterns
STAGED=$(git diff --cached --name-only 2>/dev/null || true)
[ -z "$STAGED" ] && exit 0

FOUND=""
while IFS= read -r file; do
  [ -f "$file" ] || continue

  # Skip binary files
  file -b --mime "$file" 2>/dev/null | grep -q "text/" || continue

  # Check for common secret patterns
  if grep -qEi '(API_KEY|SECRET_KEY|PASSWORD|PRIVATE_KEY|JWT_SECRET|SESSION_SECRET|MEM0_API_KEY|aws_secret|token)\s*[=:]\s*.{8,}' "$file" 2>/dev/null; then
    # Skip .example and .sample files
    case "$file" in
      *.example|*.sample|*.template) continue ;;
    esac
    FOUND="${FOUND}\n  - $file"
  fi

  # Check for private key headers
  if grep -q "BEGIN.*PRIVATE KEY" "$file" 2>/dev/null; then
    FOUND="${FOUND}\n  - $file (private key)"
  fi

  # Block .env files entirely
  case "$(basename "$file")" in
    .env|.env.local|.env.production|.env.development)
      FOUND="${FOUND}\n  - $file (.env file)"
      ;;
  esac
done <<< "$STAGED"

if [ -n "$FOUND" ]; then
  echo "BLOCKED: Potential secrets detected in staged files:${FOUND}"
  echo ""
  echo "If these are intentional, unstage the file or add to .gitignore."
  exit 2
fi

exit 0

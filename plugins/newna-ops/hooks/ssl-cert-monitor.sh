#!/usr/bin/env bash
# ssl-cert-monitor.sh — SessionStart hook
# Checks SSL certificate expiry on every session start.
# Warns if any cert expires within 30 days.
set -euo pipefail

WARN_DAYS=30

# Check if certbot is available
command -v certbot >/dev/null 2>&1 || exit 0

# Get cert info (needs sudo)
CERT_INFO=$(sudo certbot certificates 2>/dev/null) || exit 0

# Extract expiry dates and check each
echo "$CERT_INFO" | grep -i "expiry date:" | while read -r line; do
  # Extract the date string
  expiry_str=$(echo "$line" | sed 's/.*Expiry Date: //' | sed 's/ (VALID.*//')

  if [ -n "$expiry_str" ]; then
    expiry_epoch=$(date -d "$expiry_str" +%s 2>/dev/null) || continue
    now_epoch=$(date +%s)
    days_left=$(( (expiry_epoch - now_epoch) / 86400 ))

    if [ "$days_left" -lt "$WARN_DAYS" ]; then
      echo "WARNING: SSL certificate expires in ${days_left} days (${expiry_str})"
      echo "Run: sudo certbot renew --dry-run"
    fi
  fi
done

exit 0

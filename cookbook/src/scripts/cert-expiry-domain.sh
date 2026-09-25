#!/usr/bin/env bash
# Find every name in Certificate Transparency logs for a domain, then check
# the certificate each one serves right now: days left, expiry, and whether
# it verifies. Soonest expiry first.
# Usage: bash cert-expiry-domain.sh <domain> [parallel-jobs]
#        subfinder -silent -d <domain> | bash cert-expiry-domain.sh - [parallel-jobs]
set -euo pipefail

domain=${1:?usage: $0 <domain> [parallel-jobs]}
jobs=${2:-10}

check() {
  local name=$1 out end days verify
  out=$(timeout 5 openssl s_client -connect "$name:443" -servername "$name" \
        -verify_hostname "$name" </dev/null 2>/dev/null) || true
  end=$(printf '%s' "$out" | openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2) || true
  if [ -z "$end" ]; then
    printf 'NONE\t%s\tno TLS answer on 443\n' "$name"
    return
  fi
  verify=$(printf '%s' "$out" | sed -n 's/^ *Verify return code: [0-9]* (\(.*\))$/\1/p' | tail -1)
  days=$(( ($(date -d "$end" +%s) - $(date +%s)) / 86400 ))
  printf '%s\t%s\t%s\t%s\n' "$days" "$name" "$end" "$verify"
}
export -f check

names() {
  if [ "$domain" = - ]; then
    cat   # names on stdin, one per line
  else
    # name_value holds several names separated by newlines
    curl -fsS --retry 5 --retry-delay 10 --max-time 120 \
      "https://crt.sh/?q=%25.${domain}&output=json" | jq -r '.[].name_value'
  fi
}

# Wildcards are cut down to their base name so there is something to connect to.
names \
  | sed 's/^\*\.//' | tr 'A-Z' 'a-z' | sort -u \
  | xargs -P "$jobs" -I{} bash -c 'check "$1"' _ {} \
  | sort -n

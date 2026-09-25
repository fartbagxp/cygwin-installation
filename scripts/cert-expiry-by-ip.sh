#!/usr/bin/env bash
# Print the certificate expiry served by every IPv4 address behind a name.
# Usage: bash cert-expiry-by-ip.sh <hostname> [port]
set -euo pipefail

host=${1:?usage: $0 <hostname> [port]}
port=${2:-443}
now=$(date +%s)

# dig +short follows CNAMEs and prints them too; keep only the IPv4 answers.
dig +short A "$host" | grep -E '^[0-9.]+$' | while read -r ip; do
  end=$(timeout 5 openssl s_client -connect "$ip:$port" -servername "$host" </dev/null 2>/dev/null \
        | openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2) || true
  if [ -z "$end" ]; then
    printf '%s,%s,NO CERTIFICATE\n' "$host" "$ip"
    continue
  fi
  days=$(( ($(date -d "$end" +%s) - now) / 86400 ))
  printf '%s,%s,%s,%s days\n' "$host" "$ip" "$end" "$days"
done

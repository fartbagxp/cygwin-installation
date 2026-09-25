#!/usr/bin/env bash
# Which TLS versions does a server accept?
# Usage: bash tls-versions.sh <hostname> [port]
set -euo pipefail

host=${1:?usage: $0 <hostname> [port]}
port=${2:-443}

for v in tls1 tls1_1 tls1_2 tls1_3; do
  # SECLEVEL=0 lets the client offer old protocols at all. Distro crypto
  # policies can still block them; see the note under "Protocols and ciphers".
  if timeout 5 openssl s_client -connect "$host:$port" -servername "$host" \
       "-$v" -cipher 'DEFAULT:@SECLEVEL=0' </dev/null 2>/dev/null | grep -q '^New, TLS'; then
    printf '%-8s offered\n' "$v"
  else
    printf '%-8s not offered\n' "$v"
  fi
done

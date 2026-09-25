#!/usr/bin/env bash
# Check HSTS on a host, and on wherever it redirects to, the way M-15-13 and
# BOD 18-01 grade it. Pass an IP to test one edge node or a CDN before DNS moves.
# Usage: bash hsts-check.sh <hostname> [ip]
set -euo pipefail

host=${1:?usage: $0 <hostname> [ip]}
ip=${2:-}

pin=()
[ -n "$ip" ] && pin=(--resolve "$host:443:$ip")

hsts() {  # print the HSTS header value of a URL, or nothing
  curl -sS -o /dev/null -D - --max-time 10 "${pin[@]}" "$1" \
    | tr -d '\r' | sed -n 's/^strict-transport-security: *//Ip' | tail -1
}

report() {
  local url=$1 got lc age missing=()
  got=$(hsts "$url")
  if [ -z "$got" ]; then
    echo "FAIL  $url sends no Strict-Transport-Security header"
    return
  fi
  lc=$(printf '%s' "$got" | tr 'A-Z' 'a-z')
  age=$(printf '%s' "$lc" | sed -n 's/.*max-age="\{0,1\}\([0-9]*\).*/\1/p')
  [ "${age:-0}" -ge 31536000 ] || missing+=("max-age>=31536000")
  [[ $lc == *includesubdomains* ]] || missing+=(includeSubDomains)
  [[ $lc == *preload* ]]           || missing+=(preload)
  if [ ${#missing[@]} -eq 0 ]; then
    echo "OK    $url  $got"
  else
    echo "WARN  $url  $got"
    echo "      missing: ${missing[*]}"
  fi
}

report "https://$host/"

# Only the first hop is pinned: --resolve applies to $host alone, so a
# redirect to another name resolves normally.
final=$(curl -sS -L -o /dev/null --max-time 15 "${pin[@]}" -w '%{url_effective}' "https://$host/")
[ "$final" != "https://$host/" ] && report "$final"

# Port 80 should only redirect to https.
loc=$(curl -sS -o /dev/null --max-time 10 ${ip:+--resolve "$host:80:$ip"} -w '%{http_code} %{redirect_url}' "http://$host/")
echo "INFO  http://$host/ -> $loc"

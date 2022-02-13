#!/usr/bin/env bash

onelinetiming() {
  curl -k -w "dns_resolution: %{time_namelookup}, tcp_established: %{time_connect}, ssl_handshake_done: %{time_appconnect}, TTFB: %{time_starttransfer}\n" --trace-time -o /dev/null https://badssl.com/
}

curlformatting() {
  while true;
    do curl -sIvv --trace-time -w "@curl-format.txt" -o NUL -s https://badssl.com/ 2>&1 | tee -a timing-output.txt;
    sleep 5;
  done
}

expired() {
  curl -siv --trace-time https://expired.badssl.com/
}

expired
onelinetiming
curlformatting
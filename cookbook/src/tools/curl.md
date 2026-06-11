# Curl

[curl](https://curl.se/) is the de-facto command line tool for sending and
receiving data over URLs. For network debugging it is the fastest way to
answer a few recurring questions: is the website up, where does the time go
in a request (DNS, TCP, TLS, first byte), which certificate is the server
presenting, and does the problem follow a particular IP or proxy.

## Availability

| Platform         | How to get it                                                             |
| ---------------- | ------------------------------------------------------------------------- |
| Windows (Cygwin) | install the [curl](https://cygwin.com/packages/summary/curl.html) package |
| Windows (native) | `curl.exe` ships with Windows 10 (1803+) and Windows 11                   |
| Fedora           | `sudo dnf install curl` (usually preinstalled)                            |
| Ubuntu / Debian  | `sudo apt install curl`                                                   |

One thing to know before comparing results across platforms: the native
Windows `curl.exe` uses the Schannel TLS backend and the Windows certificate
store, while Cygwin and Linux builds typically use OpenSSL with a
`ca-certificates` bundle. If a site verifies on one and fails on the other,
suspect the trust store, not the network.

## Curl by Example

- Test whether a website like google.com is providing you with a HTTP 200 response

```bash
curl -sI https://www.google.com | head -n 1
```

- Get the HTTP status code only when testing a website

```bash
curl -s -o /dev/null -w '%{http_code}\n' https://www.google.com
```

- Break down where the time goes in a request (DNS vs connect vs TLS vs first byte)

```bash
curl -s -o /dev/null -w 'dns: %{time_namelookup}s\nconnect: %{time_connect}s\ntls: %{time_appconnect}s\nfirst byte: %{time_starttransfer}s\ntotal: %{time_total}s\n' https://www.google.com
```

- Run curl via a SOCKS proxy. The `socks5h://` scheme (note the `h`) makes
  the proxy resolve the domain name instead of resolving it locally. Use it
  when the destination is only resolvable from the far side of the proxy.

```bash
curl -vvvx socks5h://localhost:4020 https://www.google.com
```

- Setting up curl with a different set of trusted authority bundle

```bash
curl -sv --cacert internal-root-ca.pem https://auth.example.com
```

- Testing with mTLS (present a client certificate to the server; see
  [Network Basics](../basic-networking.md) for how the mTLS handshake works)

```bash
curl -sv https://auth.example.com --cert example.pem --key key.pem
```

## Pull HTTP response headers only

```bash
curl -sI https://www.yahoo.com 2>&1
```

## Force resolution to particular IP on specific port

This keeps SNI and the Host header correct while pinning the connection to
one address. Useful for testing a single backend behind a load balancer, or
a server whose DNS record does not exist yet:

```bash
curl -vv https://dns.google.com --resolve dns.google.com:443:8.8.8.8
```

## Continuous monitoring one-liners

- Continuously check [https://fonts.bunny.net](https://fonts.bunny.net) every
  10 seconds, with a total timeout of 3 seconds per attempt. Use **Ctrl+C** to kill.

```bash
while true; do curl -s -o /dev/null -w '%{http_code}\n' --max-time 3 https://fonts.bunny.net; sleep 10; done
```

- Same idea, but forcing IPv4 and a connection timeout of 10 seconds, printing
  the HTTP status line:

```bash
while true; do
  curl -s -4 https://fonts.bunny.net \
    --connect-timeout 10 \
    --no-progress-meter -D - -o /dev/null | head -n 1;
  sleep 10;
done
```

- With a timestamp on each line (`ts` comes from the `moreutils` package):

```bash
while true; do
  curl -s -4 https://fonts.bunny.net \
    --connect-timeout 10 \
    --no-progress-meter -D - -o /dev/null | head -n 1 | ts;
  sleep 10;
done
```

## Command for debugging

- Use [badssl.com](https://badssl.com/) to test client behavior against
  known-bad TLS configurations (expired, self-signed, wrong host, weak ciphers):

```bash
curl -sv https://expired.badssl.com/
curl -sv https://self-signed.badssl.com/
curl -sv https://wrong.host.badssl.com/
```

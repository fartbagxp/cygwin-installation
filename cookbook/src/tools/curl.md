# Curl

## Access

- [Raw download](https://curl.se/download.html)
- [Cygwin]()

## Curl by Example

- Test whether a website like google.com is providing you with a HTTP 200 response

```bash
curl -sI https://www.google.com | head -n 1
```

- Get the HTTP status code only when testing a website

```bash
curl -I --no-progress-meter https://www.google.com | head -n 1 | cut -d$' ' -f2
```

- Run curl via a set of SOCKS proxy, requiring [the proxy to resolve the domain name]()

```bash
curl -vvvx socks5h://localhost:4020 https://www.google.com
```

- Setting up curl with a different set of trusted authority bundle

Basic Testing

```bash
curl -sv https://auth.example.com
```

- Testing with mTLS

```bash
curl -sv https://auth.example.com --cert example.pem --key key.pem
```

## Pull HTTP response headers only

```bash
curl -sI https://www.yahoo.com 2>&1
```

## Force resolution to particular IP on specific port

```bash
curl -vv https://dns.google.com --resolve dns.google.com:443:8.8.8.8
```

- One Liner to continuously monitor [https://fonts.bunny.net](https://fonts.bunny.net) every 10 seconds forcing total timeout of 3 seconds. Use **Ctrl+C** to kill.

```bash
while true; do curl -s -o /dev/null -w '%{http_code}\n' --max-time 3 https://fonts.bunny.net; sleep 10; done
```

- One Liner to continuously monitor [https://fonts.bunny.net](https://fonts.bunny.net) every 10 seconds forcing connection timeout of 10 seconds. Use **Ctrl+C** to kill.

```bash
while true; do
  curl - -4 https://fonts.bunny.net \
    --connect-timeout 10 \
    --no-progress-meter -D - -o /dev/null | head -n 1;
  sleep 10;
done
```

```bash
while true; do
  curl -s -4 https://fonts.bunny.net \
    --connect-timeout 10 \
    --no-progress-meter -D - -o /dev/null | head -n 1 | ts;
  sleep 10;
done
```

## Command for debugging

- Use badssl.com

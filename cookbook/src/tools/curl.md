# Curl

## Access

- [Raw download](https://curl.se/download.html)
- [Cygwin]()
- [Linux Distros]()

## Run curl via a set of proxy

curl -vvvx socks5h://localhost:4020 https://www.google.com

## Setting up curl with a different set of trusted authority bundle

## Testing with mutual TLS (mTLS)

Basic Testing with TLS
`curl -sv https://auth.example.com`

Testing with mTLS
`curl -sv https://auth.example.com --cert example.pem --key key.pem`

## Pull HTTP response headers only

curl -sI https://www.yahoo.com 2>&1

## Force resolution to particular IP on specific port

curl -vv https://dns.google.com --resolve dns.google.com:443:8.8.8.8

## Continuous Run

```bash
while true; do curl -s -o /dev/null -w '%{http_code}\n' --max-time 3 https://apidev.cdc.gov; done
```

```bash
while true; do
  curl -vvv -4 https://fonts.bunny.net \
    --connect-timeout 10 \
    --no-progress-meter -D - -o /dev/null;
  sleep 10;
done
```

## Command for debugging

- Use badssl.com

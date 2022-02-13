# Curl

## Run curl via a set of proxy

## Setting up curl with a different set of trusted authority bundle

## Testing with mutual TLS (mTLS)

Basic Testing with TLS
`curl -sv https://auth.example.com`

Testing with mTLS
`curl -sv https://auth.example.com --cert example.pem --key key.pem`

## Pull HTTP response headers

curl -sI https://www.yahoo.com 2>&1

## Force resolution to particular IP on specific port

curl -vv https://dns.google.com --resolve dns.google.com:443:8.8.8.8

## Command for debugging

- Use badssl.com

# TLS Triage

Someone reports "the site is broken" or "we get a certificate error". Work through these in order. Each step either finds the problem or rules out a layer.

Examples use [badssl.com](https://badssl.com), which hosts a deliberately broken site for nearly every TLS failure, and `www.va.gov` as a well-behaved public site. Everything here runs in Cygwin with the `openssl`, `curl`, `bind-utils` and `jq` packages.

## 1. Let curl tell you which layer failed

Before opening `openssl`, run curl once and read the exit code. It separates DNS, TCP, and TLS failures without any guesswork.

```bash
curl -sS -o /dev/null -w '%{http_code}\n' https://expired.badssl.com
echo "exit code: $?"
```

| Exit | What failed | Typical message | Next step |
| ---- | ----------- | --------------- | --------- |
| 6 | DNS | `Could not resolve host` | [dig](../tools/dig.md), not a TLS problem |
| 7 | TCP | `Failed to connect ... Could not connect to server` | firewall or service down, try [netcat](../tools/netcat.md) |
| 28 | Timeout | `Connection timed out after ...` | packets dropped somewhere, try [trippy](../tools/trippy.md) |
| 35 | TLS handshake | `unsupported protocol`, `handshake failure` | client and server share no protocol or cipher, see [step 5](#5-protocols-and-ciphers) |
| 60 | Certificate verification | `certificate has expired`, `self-signed certificate`, `no alternative certificate subject name matches`, `unable to get local issuer certificate` | [step 2](#2-look-at-the-certificate-chain) |
| 0, HTTP 400 | Server wanted a client cert | `400 No required SSL certificate was sent` in the body | mTLS, see [curl](../tools/curl.md) `--cert`/`--key` |

Exit 60 covers four different problems. The message after the code tells you which one:

| curl message (exit 60) | Meaning | Usual fix |
| ---------------------- | ------- | --------- |
| `certificate has expired` | past `notAfter` | renew |
| `no alternative certificate subject name matches target hostname` | cert is for a different name | add the name as a SAN, or you hit the wrong vhost (missing SNI) |
| `unable to get local issuer certificate` | server did not send its intermediate | fix the server's chain file; browsers often hide this because they cache intermediates |
| `self-signed certificate in certificate chain` | chain ends at a root you do not trust | corporate TLS inspection, or a private CA: add the root to your bundle, do not add `-k` |

Do not reach for `curl -k` to make the error go away while triaging. It turns off exactly the check you are trying to run.

## 2. Look at the certificate chain

`-servername` sends SNI. Without it, a server hosting many sites returns its default certificate, and you end up debugging the wrong certificate.

```bash
echo | openssl s_client -connect www.va.gov:443 -servername www.va.gov -showcerts 2>/dev/null \
  | grep -E '^ *[0-9] s:|^ +i:'
```

```text
 0 s:CN=www.va.gov
   i:C=GB, O=Sectigo Limited, CN=Sectigo Public Server Authentication CA DV R36
 1 s:C=GB, O=Sectigo Limited, CN=Sectigo Public Server Authentication CA DV R36
   i:C=GB, O=Sectigo Limited, CN=Sectigo Public Server Authentication Root R46
 2 s:C=GB, O=Sectigo Limited, CN=Sectigo Public Server Authentication Root R46
   i:C=GB, ST=Greater Manchester, L=Salford, O=Comodo CA Limited, CN=AAA Certificate Services
```

Read it top down. Each `i:` (issuer) should equal the next line's `s:` (subject). If the list stops at `0` and the issuer is not a root your machine trusts, the server is missing its intermediate. That is the `unable to get local issuer certificate` case.

The leaf certificate's names and dates:

```bash
echo | openssl s_client -connect www.va.gov:443 -servername www.va.gov 2>/dev/null \
  | openssl x509 -noout -subject -issuer -dates -ext subjectAltName
```

```text
subject=CN=www.va.gov
issuer=C=GB, O=Sectigo Limited, CN=Sectigo Public Server Authentication CA DV R36
notBefore=Dec 20 00:00:00 2025 GMT
notAfter=Jan 18 23:59:59 2027 GMT
X509v3 Subject Alternative Name:
    DNS:www.va.gov, DNS:va.gov
```

Clients ignore the CN and match only against the Subject Alternative Names. If the name you typed is not in that list, you get the hostname mismatch error.

For a pass/fail answer, `-checkend` exits non-zero if the certificate expires within the given number of seconds. That makes it usable in cron or CI:

```bash
echo | openssl s_client -connect www.va.gov:443 -servername www.va.gov 2>/dev/null \
  | openssl x509 -noout -checkend $((30 * 86400)) || echo "expires within 30 days"
```

## 3. Check every IP, not just the one you happened to hit

A name behind a load balancer or round-robin DNS resolves to several IPs, and a renewal that missed one node shows up as an intermittent error. This checks each IPv4 address separately, sending the same SNI to each:

```bash
{{#include ../scripts/cert-expiry-by-ip.sh}}
```

```text
$ bash cert-expiry-by-ip.sh www.va.gov
www.va.gov,152.130.96.221,Jan 18 23:59:59 2027 GMT,115 days
```

`dig +short` prints CNAME targets before the addresses, which is why the script filters for lines that look like IPs.

## 4. Sweep a whole domain for expiring or broken certificates

Certificate Transparency logs list every certificate a public CA has issued for a domain, which gives you a list of names nobody remembered to put in the inventory. This pulls the names from [crt.sh](https://crt.sh), connects to each one in parallel, and reports days left plus whether the certificate actually verifies:

```bash
{{#include ../scripts/cert-expiry-domain.sh}}
```

Run it as `bash cert-expiry-domain.sh badssl.com 20`. Here it is fed a short list on stdin so the output is easy to read:

```text
$ printf '%s\n' '*.badssl.com' expired.badssl.com self-signed.badssl.com \
    WRONG.host.badssl.com nope.invalid | bash cert-expiry-domain.sh - 5
-4183   expired.badssl.com      Apr 12 23:59:59 2015 GMT   certificate has expired
NONE    nope.invalid            no TLS answer on 443
31      badssl.com              Oct 26 20:03:01 2026 GMT   ok
31      wrong.host.badssl.com   Oct 26 20:03:01 2026 GMT   hostname mismatch
727     self-signed.badssl.com  Sep 21 21:00:16 2028 GMT   self-signed certificate
```

Things to know:

- crt.sh is a free service and often returns 502 under load. The script retries, then stops with curl's error instead of printing an empty report. When it is down, feed the names in yourself: `subfinder -silent -d badssl.com | bash cert-expiry-domain.sh -`.
- An earlier version of this script only checked names that answered `200 OK` first. HTTP/2 servers answer `HTTP/2 200` and many sites answer with a redirect, so most live hosts were skipped. Connecting with `openssl` directly avoids the problem.
- `NONE` does not always mean dead. The name may be internal-only, behind a VPN, or listening only on a port other than 443.
- The `days` column only covers expiry. Read the last column too: a certificate with 700 days left that is self-signed is still broken.

## 5. Protocols and ciphers

Which TLS versions does the server accept?

```bash
{{#include ../scripts/tls-versions.sh}}
```

```text
$ bash tls-versions.sh www.va.gov
tls1     not offered
tls1_1   not offered
tls1_2   offered
tls1_3   not offered
```

Your local OpenSSL limits what this can see. OpenSSL 3 refuses TLS 1.0 and 1.1 unless you lower the security level, which the script does with `@SECLEVEL=0`. Fedora and RHEL crypto policies can still block legacy signatures underneath that, and you get `invalid digest` instead of a handshake. So "not offered" for old versions can mean "my client could not ask". For a compliance answer, use [testssl.sh](../tools/testssl.md), which ships its own OpenSSL built with the legacy options, or nmap:

```bash
nmap --script ssl-enum-ciphers -p 443 www.va.gov
```

Both grade every cipher the server offers, which is what an audit against [M-15-13](https://https.cio.gov/) and [BOD 18-01](https://www.cisa.gov/news-events/directives/bod-18-01-enhance-email-and-web-security) needs.

## 6. HSTS and the HTTP to HTTPS redirect

BOD 18-01 expects port 80 to redirect to HTTPS, and HTTPS responses to carry `Strict-Transport-Security` with `max-age` of at least one year, `includeSubDomains`, and `preload`. The check has to follow the redirect: `va.gov` and `www.va.gov` can send different headers.

```bash
{{#include ../scripts/hsts-check.sh}}
```

```text
$ bash hsts-check.sh va.gov
WARN  https://va.gov/  max-age=31536000; preload
      missing: includeSubDomains
OK    https://www.va.gov/  max-age=31536000; includeSubDomains; preload
INFO  http://va.gov/ -> 301 https://va.gov:443/
```

The script checks each directive on its own, because servers write them in different orders and cases. GitHub, for example, sends `includeSubdomains`.

## 7. Test a specific IP or CDN before changing DNS

Before a DNS cutover, you want to know the new origin or CDN edge serves the right certificate for your name. `--resolve` makes curl connect to an IP you choose while still sending the real hostname in SNI and the `Host` header:

```bash
curl -sS -o /dev/null --resolve www.va.gov:443:152.130.96.221 \
  -w 'ip=%{remote_ip} http=%{http_code} verify=%{ssl_verify_result}\n' https://www.va.gov/
```

The format is `host:port:address`, and the host and port must match the URL exactly. A malformed entry such as `--resolve https://www.va.gov:443:1.2.3.4` at least fails loudly (exit 49). A well-formed entry that does not match is worse: `--resolve va.gov:443:...` for a `www.va.gov` URL, or port 80 for an `https://` URL, is silently ignored, so curl resolves normally, tests the old site, and reports success. Always print `%{remote_ip}` to confirm you reached the IP you meant.

When the new target is a CDN hostname rather than an IP, `--connect-to` saves the `dig` step:

```bash
curl -sS -o /dev/null --connect-to www.example.gov:443:www.example.gov.edgekey.net:443 \
  -w 'ip=%{remote_ip} verify=%{ssl_verify_result}\n' https://www.example.gov/
```

`verify=0` means the certificate on the new target is valid for your name. If it is not, curl exits 60 and prints a non-zero `verify` (an OpenSSL verify code, such as 20 for a missing issuer), and that is what your users would see on cutover day. This is the one test where `-k` would hide exactly the problem you are looking for.

`hsts-check.sh` above takes the IP as a second argument (`bash hsts-check.sh www.va.gov 152.130.96.221`) to check the headers the new target sends, too.

To see the cutover from your users' point of view, run the same `curl` from several regions. A VPN with a CLI works, for example `piactl set region uk-london && piactl connect` in a loop. This matters most when overseas users are a population you have to serve.

## 8. Where the time goes

When the complaint is "TLS is slow", split the request into phases:

```bash
curl -sS -o /dev/null https://www.va.gov/ -w \
  'dns=%{time_namelookup}s tcp=%{time_connect}s tls=%{time_appconnect}s ttfb=%{time_starttransfer}s total=%{time_total}s\n'
```

```text
dns=0.000012s tcp=0.009375s tls=0.036600s ttfb=0.390449s total=0.523465s
```

Each value is cumulative from the start of the request. So the TLS handshake took `tls - tcp`, about 27 ms here, and the server spent `ttfb - tls` thinking. A large `tls - tcp` next to a small `tcp` usually points to a long certificate chain, a busy server doing expensive key exchanges, or a TLS-inspecting proxy in the path. See [Latency](../latency.md) for why the `tcp` number cannot go below the round trip.

## Further reading

- [badssl.com](https://badssl.com): a broken example for most failure modes, useful for checking that your client really does fail
- [SSL Labs deployment best practices](https://github.com/ssllabs/research/wiki/SSL-and-TLS-Deployment-Best-Practices)
- [Feisty Duck OpenSSL Cookbook](https://www.feistyduck.com/library/openssl-cookbook/)

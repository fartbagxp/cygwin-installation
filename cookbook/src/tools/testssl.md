# Testssl

[testssl.sh](https://testssl.sh/) is a [pure bash shell script](https://github.com/testssl/testssl.sh) for scanning whether a webserver hosting a webservice or website is promoting good security practices based on what the website supports in terms of SSL/TLS certificates, cipher preferences in TLS encryption, and supporting protocols.

## Availability

Because it is a pure bash script, testssl.sh runs anywhere bash and OpenSSL
exist, including inside Cygwin on Windows. It even bundles its own openssl
binaries for common platforms.

| Platform         | How to get it                                              |
| ---------------- | ----------------------------------------------------------- |
| Windows (Cygwin) | clone the repository (needs the `git` and `bash` packages) |
| Fedora           | `sudo dnf install testssl` or clone the repository         |
| Ubuntu / Debian  | `sudo apt install testssl.sh` or clone the repository      |

## Access

Download the latest script. The project moved from `drwetter/testssl.sh` to `testssl/testssl.sh`; the old URL redirects to the same repository.

```bash
git clone https://github.com/testssl/testssl.sh.git
```

There are two active branches:

- `3.3dev` is the default and gets fixes and new checks first.
- `3.2` is the stable release line, for when results need to stay the same between runs.

```bash
git clone --branch 3.2 https://github.com/testssl/testssl.sh.git
```

An existing clone may be following only one branch. Check which one, and switch to the development branch if you want it:

```bash
git -C testssl.sh branch --show-current
git -C testssl.sh remote set-branches --add origin 3.3dev
git -C testssl.sh fetch origin && git -C testssl.sh switch 3.3dev
```

## How to Run

Run it on a website such as google.com.

```bash
bash testssl.sh https://www.google.com
```

Sample Results:

```markdown
testssl.sh 3.0.8 from https://testssl.sh/
(30c0359 2024-02-13 18:42:33)

      This program is free software. Distribution and
             modification under GPLv2 permitted.
      USAGE w/o ANY WARRANTY. USE IT AT YOUR OWN RISK!

       Please file bugs @ https://testssl.sh/bugs/

###########################################################

Using "OpenSSL 1.0.2-bad (1.0.2k-dev)" [~179 ciphers]
on momo:./bin/openssl.Linux.x86_64
(built: "Sep 1 14:03:44 2022", platform: "linux-x86_64")

## Testing all IPv4 addresses (port 443): 172.253.63.105 172.253.63.99 172.253.63.106 172.253.63.103 172.253.63.147 172.253.63.104

Start 2024-02-25 03:13:30 -->> 172.253.63.105:443 (www.google.com) <<--

Further IP addresses: 172.253.122.104 172.253.122.103 172.253.122.105 172.253.122.99 172.253.122.147 172.253.122.106 2607:f8b0:4004:c07::69 2607:f8b0:4004:c07::93 2607:f8b0:4004:c07::63 2607:f8b0:4004:c07::67
rDNS (172.253.63.105): bi-in-f105.1e100.net.
Service detected: HTTP

Testing protocols via sockets except NPN+ALPN

SSLv2 not offered (OK)
SSLv3 not offered (OK)
TLS 1 offered (deprecated)
TLS 1.1 offered (deprecated)
TLS 1.2 offered (OK)
TLS 1.3 offered (OK): final
NPN/SPDY grpc-exp, h2, http/1.1 (advertised)
ALPN/HTTP2 h2, http/1.1, grpc-exp (offered)

Testing cipher categories

NULL ciphers (no encryption) not offered (OK)
Anonymous NULL Ciphers (no authentication) not offered (OK)
Export ciphers (w/o ADH+NULL) not offered (OK)
LOW: 64 Bit + DES, RC[2,4] (w/o export) not offered (OK)
Triple DES Ciphers / IDEA offered
Obsolete CBC ciphers (AES, ARIA etc.) offered
Strong encryption (AEAD ciphers) offered (OK)

Testing robust (perfect) forward secrecy, (P)FS -- omitting Null Authentication/Encryption, 3DES, RC4

PFS is offered (OK) TLS_AES_256_GCM_SHA384 TLS_CHACHA20_POLY1305_SHA256 ECDHE-RSA-AES256-GCM-SHA384 ECDHE-ECDSA-AES256-GCM-SHA384 ECDHE-RSA-AES256-SHA ECDHE-ECDSA-AES256-SHA ECDHE-ECDSA-CHACHA20-POLY1305
ECDHE-RSA-CHACHA20-POLY1305 TLS_AES_128_GCM_SHA256 ECDHE-RSA-AES128-GCM-SHA256 ECDHE-ECDSA-AES128-GCM-SHA256 ECDHE-RSA-AES128-SHA ECDHE-ECDSA-AES128-SHA
Elliptic curves offered: prime256v1 X25519

Testing server preferences

Has server cipher order? yes (OK) -- only for < TLS 1.3
Negotiated protocol TLSv1.3
Negotiated cipher TLS_AES_256_GCM_SHA384, 253 bit ECDH (X25519)
Cipher order
TLSv1: ECDHE-ECDSA-AES128-SHA ECDHE-ECDSA-AES256-SHA ECDHE-RSA-AES128-SHA ECDHE-RSA-AES256-SHA AES128-SHA AES256-SHA DES-CBC3-SHA
TLSv1.1: ECDHE-ECDSA-AES128-SHA ECDHE-ECDSA-AES256-SHA ECDHE-RSA-AES128-SHA ECDHE-RSA-AES256-SHA AES128-SHA AES256-SHA DES-CBC3-SHA
TLSv1.2: ECDHE-ECDSA-AES128-GCM-SHA256 ECDHE-ECDSA-CHACHA20-POLY1305 ECDHE-ECDSA-AES256-GCM-SHA384 ECDHE-ECDSA-AES128-SHA ECDHE-ECDSA-AES256-SHA ECDHE-RSA-AES128-GCM-SHA256 ECDHE-RSA-CHACHA20-POLY1305
ECDHE-RSA-AES256-GCM-SHA384 ECDHE-RSA-AES128-SHA ECDHE-RSA-AES256-SHA AES128-GCM-SHA256 AES256-GCM-SHA384 AES128-SHA AES256-SHA DES-CBC3-SHA

Testing server defaults (Server Hello)

TLS extensions (standard) "renegotiation info/#65281" "EC point formats/#11" "session ticket/#35" "next protocol/#13172" "key share/#51" "supported versions/#43" "extended master secret/#23"
"application layer protocol negotiation/#16"
Session Ticket RFC 5077 hint 100800 seconds but: PFS requires session ticket keys to be rotated < daily !
SSL Session ID support yes
Session Resumption Tickets: yes, ID: yes
TLS clock skew 0 sec from localtime

Server Certificate #1
Signature Algorithm SHA256 with RSA
Server key size RSA 2048 bits
Server key usage Digital Signature, Key Encipherment
Server extended key usage TLS Web Server Authentication
Serial 54866C406C047C7C0A34EC3C3AB1E0EB (OK: length 16)
Fingerprints SHA1 D7854FBC47BA3ED33395BD21FFF71643BC27A473
SHA256 448F11FAD35A95A788934732F8351A08BE930C0D5195E93D52D4C57E13072BB4
Common Name (CN) www.google.com
subjectAltName (SAN) www.google.com
Issuer GTS CA 1C3 (Google Trust Services LLC from US)
Trust (hostname) Ok via SAN (same w/o SNI)
Chain of trust Ok
EV cert (experimental) no
ETS/"eTLS", visibility info not present
Certificate Validity (UTC) 64 >= 60 days (2024-02-05 08:19 --> 2024-04-29 08:19)

# of certificates provided 3

Certificate Revocation List http://crls.pki.goog/gts1c3/QOvJ0N1sT2A.crl
OCSP URI http://ocsp.pki.goog/gts1c3
OCSP stapling not offered
OCSP must staple extension --
DNS CAA RR (experimental) available - please check for match with "Issuer" above: issue=pki.goog
Certificate Transparency yes (certificate extension)

Server Certificate #2
Signature Algorithm SHA256 with RSA
Server key size EC 256 bits
Server key usage Digital Signature
Server extended key usage TLS Web Server Authentication
Serial 55D169AD310983300AC6872F7A8B2B14 (OK: length 16)
Fingerprints SHA1 872B8A71846A1C14432200F6FD21E6AC7C21D3F5
SHA256 0093942C6AB658AADB2D3A3CFB40717CE28A23D2B6A2EDCE5D236F9E879E62D0
Common Name (CN) www.google.com
subjectAltName (SAN) www.google.com
Issuer GTS CA 1C3 (Google Trust Services LLC from US)
Trust (hostname) Ok via SAN (same w/o SNI)
Chain of trust Ok
EV cert (experimental) no
ETS/"eTLS", visibility info not present
Certificate Validity (UTC) 64 >= 60 days (2024-02-05 08:19 --> 2024-04-29 08:19)

# of certificates provided 3

Certificate Revocation List http://crls.pki.goog/gts1c3/moVDfISia2k.crl
OCSP URI http://ocsp.pki.goog/gts1c3
OCSP stapling not offered
OCSP must staple extension --
DNS CAA RR (experimental) available - please check for match with "Issuer" above: issue=pki.goog
Certificate Transparency yes (certificate extension)

Testing HTTP header response @ "/"

HTTP Status Code 200 OK
HTTP clock skew 0 sec from localtime
Strict Transport Security not offered
Public Key Pinning --
Server banner gws
Application banner --
Cookie(s) 3 issued: 2/3 secure, 2/3 HttpOnly
Security headers X-Frame-Options: SAMEORIGIN
Content-Security-Policy-Report-Only: object-src 'none';base-uri 'self';script-src 'nonce-dXVNDjDTt6VAToHGETYaOw' 'strict-dynamic' 'report-sample' 'unsafe-eval' 'unsafe-inline' https:
http:;report-uri https://csp.withgoogle.com/csp/gws/other-hp
Cache-Control: private, max-age=0
X-XSS-Protection: 0
Reverse Proxy banner --

Testing vulnerabilities

Heartbleed (CVE-2014-0160) not vulnerable (OK), no heartbeat extension
CCS (CVE-2014-0224) not vulnerable (OK)
Ticketbleed (CVE-2016-9244), experiment. not vulnerable (OK)
ROBOT not vulnerable (OK)
Secure Renegotiation (RFC 5746) supported (OK)
Secure Client-Initiated Renegotiation not vulnerable (OK)
CRIME, TLS (CVE-2012-4929) not vulnerable (OK)
BREACH (CVE-2013-3587) potentially NOT ok, "gzip" HTTP compression detected. - only supplied "/" tested
Can be ignored for static pages or if no secrets in the page
POODLE, SSL (CVE-2014-3566) not vulnerable (OK), no SSLv3 support
TLS_FALLBACK_SCSV (RFC 7507) Downgrade attack prevention supported (OK)
SWEET32 (CVE-2016-2183, CVE-2016-6329) VULNERABLE, uses 64 bit block ciphers
FREAK (CVE-2015-0204) not vulnerable (OK)
DROWN (CVE-2016-0800, CVE-2016-0703) not vulnerable on this host and port (OK)
make sure you don't use this certificate elsewhere with SSLv2 enabled services
https://search.censys.io/search?resource=hosts&virtual_hosts=INCLUDE&q=448F11FAD35A95A788934732F8351A08BE930C0D5195E93D52D4C57E13072BB4
LOGJAM (CVE-2015-4000), experimental not vulnerable (OK): no DH EXPORT ciphers, no DH key detected with <= TLS 1.2
BEAST (CVE-2011-3389) TLS1: ECDHE-ECDSA-AES128-SHA ECDHE-ECDSA-AES256-SHA ECDHE-RSA-AES128-SHA ECDHE-RSA-AES256-SHA AES128-SHA AES256-SHA DES-CBC3-SHA
VULNERABLE -- but also supports higher protocols TLSv1.1 TLSv1.2 (likely mitigated)
LUCKY13 (CVE-2013-0169), experimental potentially VULNERABLE, uses cipher block chaining (CBC) ciphers with TLS. Check patches
RC4 (CVE-2013-2566, CVE-2015-2808) no RC4 ciphers detected (OK)

Testing 370 ciphers via OpenSSL plus sockets against the server, ordered by encryption strength

## Hexcode Cipher Suite Name (OpenSSL) KeyExch. Encryption Bits Cipher Suite Name (IANA/RFC)

x1302 TLS_AES_256_GCM_SHA384 ECDH 253 AESGCM 256 TLS_AES_256_GCM_SHA384
x1303 TLS_CHACHA20_POLY1305_SHA256 ECDH 253 ChaCha20 256 TLS_CHACHA20_POLY1305_SHA256
xc030 ECDHE-RSA-AES256-GCM-SHA384 ECDH 256 AESGCM 256 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
xc02c ECDHE-ECDSA-AES256-GCM-SHA384 ECDH 256 AESGCM 256 TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
xc014 ECDHE-RSA-AES256-SHA ECDH 256 AES 256 TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA
xc00a ECDHE-ECDSA-AES256-SHA ECDH 256 AES 256 TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA
xcca9 ECDHE-ECDSA-CHACHA20-POLY1305 ECDH 253 ChaCha20 256 TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256
xcca8 ECDHE-RSA-CHACHA20-POLY1305 ECDH 253 ChaCha20 256 TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256
x9d AES256-GCM-SHA384 RSA AESGCM 256 TLS_RSA_WITH_AES_256_GCM_SHA384
x35 AES256-SHA RSA AES 256 TLS_RSA_WITH_AES_256_CBC_SHA
x1301 TLS_AES_128_GCM_SHA256 ECDH 253 AESGCM 128 TLS_AES_128_GCM_SHA256
xc02f ECDHE-RSA-AES128-GCM-SHA256 ECDH 256 AESGCM 128 TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
xc02b ECDHE-ECDSA-AES128-GCM-SHA256 ECDH 256 AESGCM 128 TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256
xc013 ECDHE-RSA-AES128-SHA ECDH 256 AES 128 TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA
xc009 ECDHE-ECDSA-AES128-SHA ECDH 256 AES 128 TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA
x9c AES128-GCM-SHA256 RSA AESGCM 128 TLS_RSA_WITH_AES_128_GCM_SHA256
x2f AES128-SHA RSA AES 128 TLS_RSA_WITH_AES_128_CBC_SHA
x0a DES-CBC3-SHA RSA 3DES 168 TLS_RSA_WITH_3DES_EDE_CBC_SHA

Running client simulations (HTTP) via sockets

Android 6.0 TLSv1.2 ECDHE-ECDSA-AES128-GCM-SHA256, 256 bit ECDH (P-256)
Android 7.0 (native) TLSv1.2 ECDHE-ECDSA-AES128-GCM-SHA256, 256 bit ECDH (P-256)
Android 8.1 (native) TLSv1.2 ECDHE-ECDSA-AES128-GCM-SHA256, 253 bit ECDH (X25519)
Android 9.0 (native) TLSv1.3 TLS_AES_128_GCM_SHA256, 253 bit ECDH (X25519)
Android 10.0 (native) TLSv1.3 TLS_AES_128_GCM_SHA256, 253 bit ECDH (X25519)
Android 11 (native) TLSv1.3 TLS_AES_128_GCM_SHA256, 253 bit ECDH (X25519)
Android 12 (native) TLSv1.3 TLS_AES_128_GCM_SHA256, 253 bit ECDH (X25519)
Chrome 79 (Win 10) TLSv1.3 TLS_AES_128_GCM_SHA256, 253 bit ECDH (X25519)
Chrome 101 (Win 10) TLSv1.3 TLS_AES_128_GCM_SHA256, 253 bit ECDH (X25519)
Firefox 66 (Win 8.1/10) TLSv1.3 TLS_AES_128_GCM_SHA256, 253 bit ECDH (X25519)
Firefox 100 (Win 10) TLSv1.3 TLS_AES_128_GCM_SHA256, 253 bit ECDH (X25519)
IE 6 XP No connection
IE 8 Win 7 TLSv1.0 ECDHE-ECDSA-AES128-SHA, 256 bit ECDH (P-256)
IE 8 XP TLSv1.0 DES-CBC3-SHA, No FS
IE 11 Win 7 TLSv1.2 ECDHE-ECDSA-AES128-GCM-SHA256, 256 bit ECDH (P-256)
IE 11 Win 8.1 TLSv1.2 ECDHE-ECDSA-AES128-GCM-SHA256, 256 bit ECDH (P-256)
IE 11 Win Phone 8.1 TLSv1.2 ECDHE-ECDSA-AES128-GCM-SHA256, 256 bit ECDH (P-256)
IE 11 Win 10 TLSv1.2 ECDHE-ECDSA-AES128-GCM-SHA256, 256 bit ECDH (P-256)
Edge 15 Win 10 TLSv1.2 ECDHE-ECDSA-AES128-GCM-SHA256, 253 bit ECDH (X25519)
Edge 101 Win 10 21H2 TLSv1.3 TLS_AES_128_GCM_SHA256, 253 bit ECDH (X25519)
Safari 12.1 (iOS 12.2) TLSv1.3 TLS_CHACHA20_POLY1305_SHA256, 253 bit ECDH (X25519)
Safari 13.0 (macOS 10.14.6) TLSv1.3 TLS_CHACHA20_POLY1305_SHA256, 253 bit ECDH (X25519)
Safari 15.4 (macOS 12.3.1) TLSv1.3 TLS_AES_128_GCM_SHA256, 253 bit ECDH (X25519)
Java 7u25 TLSv1.0 ECDHE-ECDSA-AES128-SHA, 256 bit ECDH (P-256)
Java 8u161 TLSv1.2 ECDHE-ECDSA-AES128-GCM-SHA256, 256 bit ECDH (P-256)
Java 11.0.2 (OpenJDK) TLSv1.2 ECDHE-ECDSA-AES128-GCM-SHA256, 256 bit ECDH (P-256)
Java 17.0.3 (OpenJDK) TLSv1.3 TLS_AES_256_GCM_SHA384, 253 bit ECDH (X25519)
go 1.17.8 TLSv1.3 TLS_AES_128_GCM_SHA256, 253 bit ECDH (X25519)
LibreSSL 2.8.3 (Apple) TLSv1.2 ECDHE-ECDSA-CHACHA20-POLY1305, 253 bit ECDH (X25519)
OpenSSL 1.0.2e TLSv1.2 ECDHE-ECDSA-AES128-GCM-SHA256, 256 bit ECDH (P-256)
OpenSSL 1.1.0l (Debian) TLSv1.2 ECDHE-ECDSA-CHACHA20-POLY1305, 253 bit ECDH (X25519)
OpenSSL 1.1.1d (Debian) TLSv1.3 TLS_AES_256_GCM_SHA384, 253 bit ECDH (X25519)
OpenSSL 3.0.3 (git) TLSv1.3 TLS_AES_256_GCM_SHA384, 253 bit ECDH (X25519)
Apple Mail (16.0) TLSv1.2 ECDHE-ECDSA-AES128-GCM-SHA256, 256 bit ECDH (P-256)
Thunderbird (91.9) TLSv1.3 TLS_AES_128_GCM_SHA256, 253 bit ECDH (X25519)

Done 2024-02-25 03:15:21 [ 115s] -->> 172.253.63.105:443 (www.google.com) <<--
```

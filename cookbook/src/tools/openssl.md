# OpenSSL

[OpenSSL](https://docs.openssl.org/3.3/man1/openssl-s_client/) is [an open
source toolkit](https://github.com/openssl/openssl) for SSL/TLS. For network
debugging, its `s_client` subcommand behaves like a TLS-speaking netcat: it
performs the TLS handshake (see [Network Basics](../basic-networking.md))
and shows you the exact certificate chain the server presents, which
protocol and cipher get negotiated, and whether the handshake completes at
all. The `x509` subcommand inspects and converts certificate files locally.

## Availability

| Platform         | How to get it                                                                   |
| ---------------- | -------------------------------------------------------------------------------- |
| Windows (Cygwin) | install the [openssl](https://cygwin.com/packages/summary/openssl.html) package |
| Fedora           | `sudo dnf install openssl` (usually preinstalled)                               |
| Ubuntu / Debian  | `sudo apt install openssl` (usually preinstalled)                               |

## Inspecting a live server

- Connect to google.com and show its full certificate chain (the
  `echo -n |` or `</dev/null` closes stdin so the command exits instead of
  waiting for input):

```bash
echo -n | openssl s_client -connect google.com:443 -showcerts
```

- When the server hosts several sites on one IP, set SNI explicitly with
  `-servername`, otherwise you may receive the wrong (default) certificate:

```bash
openssl s_client -connect www.google.com:443 -servername www.google.com </dev/null
```

- Get all subject alternative names (the list of hostnames the certificate
  is actually valid for):

```bash
openssl s_client -connect www.google.com:443 </dev/null | openssl x509 -noout -text | grep DNS:
```

- Test whether a server still accepts an old protocol version:

```bash
openssl s_client -connect example.com:443 -tls1_1 </dev/null
```

## Inspecting certificate files

- Convert a **.cer** file (a DER-encoded format commonly exported by Windows)
  to a base64-encoded human-readable **.pem** file:

```bash
openssl x509 -in VA-Internal-S2-RCA1-v1.cer -out VA-Internal-S2-RCA1-v1.pem
```

OpenSSL 3 detects the DER format on its own. OpenSSL 1.x needs `-inform der` added, or it fails with `unable to load certificate`.

- Check the validity dates of a single certificate:

```bash
openssl x509 -in <particular pem>.pem -noout -dates
```

- Check the dates of every .pem in a folder:

```bash
for i in <folder>/*.pem; do echo "$i"; openssl x509 -in "$i" -noout -dates; done
```

- Recursively find all .pem files and print their expiry dates:

```bash
find . -name '*.pem' -type f -print -exec openssl x509 -in {} -enddate -noout \;
```

## Extracting a server certificate for a Java trust store

A practical combination: pull the certificate a server presents, save it as
a .pem, and import it into a Java cacerts keystore (here inside a Dockerfile,
hence the `RUN`):

```dockerfile
RUN echo | openssl s_client -servername swa.cdc.gov -connect swa.cdc.gov:443 2>&1 \
      | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > cert.pem && \
    "${FORTIFY_EXEC_FOLDER}"/jre/bin/keytool -importcert -alias cdc-swa \
      -noprompt -cacerts -storepass changeit -file cert.pem
```

For a step by step walk through certificate problems, see [TLS Triage](../recipes/tls-triage.md).

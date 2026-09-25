# OpenSSL

[OpenSSL](https://docs.openssl.org/3.3/man1/openssl-s_client/) is [an open source tool](https://github.com/openssl/openssl) for testing SSL/TLS connections.

## Various Usage

- Connect to google.com and show google.com's TLS certificate

  ```bash
  echo -n | openssl s_client -connect google.com:443 -showcerts
  ```

- Convert a **.cer** file, a file commonly used by Windows for TLS certificates to a base64 encoded human-readable **.pem** file

  ```bash
  openssl x509 -in VA-Internal-S2-RCA1-v1.cer -out VA-Internal-S2-RCA1-v1.pem
  ```

  OpenSSL 3 detects the binary DER format on its own. OpenSSL 1.x needs `-inform der` added, or it fails with `unable to load certificate`.

- Show a certificate of a website like google.com, sending the hostname as SNI so a shared server returns the right certificate

  ```bash
  openssl s_client -showcerts -connect www.google.com:443 -servername www.google.com </dev/null
  ```

- Get all subject alternative names, the names a client actually matches against

  ```bash
  openssl s_client -connect www.google.com:443 -servername www.google.com </dev/null 2>/dev/null \
    | openssl x509 -noout -ext subjectAltName
  ```

- Check the dates on a single certificate file

  ```bash
  openssl x509 -in certificate.pem -noout -dates
  ```

- Check the expiry of every **.pem** file under a folder

  ```bash
  find . -name '*.pem' -type f -print -exec openssl x509 -in {} -noout -enddate \;
  ```

- Trust a server's certificate in a Java application (Java 9+), such as a scanner behind an internal CA. The `sed` keeps only the PEM block. Without `-showcerts` this is the leaf certificate, which stops working at the next renewal, so import the issuing CA instead when you can get it.

  ```bash
  echo | openssl s_client -servername internal.example.com -connect internal.example.com:443 2>/dev/null \
    | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > cert.pem
  "$JAVA_HOME"/bin/keytool -importcert -alias internal-example -noprompt \
    -cacerts -storepass changeit -file cert.pem
  ```

For a step by step walk through certificate problems, see [TLS Triage](../recipes/tls-triage.md).

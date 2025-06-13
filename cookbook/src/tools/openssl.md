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

- Show a certificate of a website like google.com
  `openssl s_client -showcerts -connect www.google.com:443 </dev/null`

- get all subject alternate names
  `openssl s_client -connect www.google.com:443 </dev/null | openssl x509 -noout -text | grep DNS: | awk '{print $0,"\n"}'`

For checking certificate dates: for i in $( ls <folder>/\*.pem ); do echo $i; openssl x509 -in $i -noout -dates; done
Single cert:
`openssl x509 -in <particular pem>.pem -noout -dates`

Show cert:  
 `openssl s_client -showcerts -connect www.google.com:443 </dev/null`

Look for all pem in a single directory and find all:
`find . -name '*.pem' -type f -print -exec openssl x509 -in {} -enddate -noout \;`

RUN echo | openssl s_client -servername swa.cdc.gov -connect swa.cdc.gov:443 2>&1 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > cert.pem && \
 "${FORTIFY_EXEC_FOLDER}"/jre/bin/keytool -importcert -alias cdc-swa -noprompt -cacerts -storepass changeit -file cert.pem

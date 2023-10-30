# OpenSSL

- echo -n | openssl s_client -connect google.com:443 -showcerts

- convert **.cer** file to **.pem**
  `openssl x509 -in VA-Internal-S2-RCA1-v1.cer -out VA-Internal-S2-RCA1-v1.pem`

- show a certificate of a website
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

# Diagnosis

A rough order of operations when "the network is broken". Each step maps to
one layer of the connection walkthrough in
[Network Basics](./basic-networking.md).

1. Name resolution. Does the name resolve, and to the right address? Start
   with [dig](./tools/dig.md) and compare resolvers. Switch to
   [delv](./tools/delv.md) if a validating resolver returns SERVFAIL.
2. Reachability. Can you open a TCP connection to the port at all?
   [netcat](./tools/netcat.md) answers this in one line.
3. Path. If reachability is flaky, find the lossy hop with
   [trippy](./tools/trippy.md) or mtr.
4. TLS. If the connection opens but the protocol fails, inspect the
   handshake and certificates with [openssl](./tools/openssl.md) s_client
   and [testssl](./tools/testssl.md).
5. Application. If all of the above pass, time the request phases with
   [curl](./tools/curl.md) and trace what the client actually does with
   [strace](./tools/strace.md).
6. Packets. When tools disagree, capture with
   [tcpdump](./tools/tcpdump.md) and read the capture in Wireshark.

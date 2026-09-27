# IP Addressing

## In Practice

### Private vs. Public IPs

A public IP is globally routable: any machine on the internet can, in principle, send packets to it. A private IP only has meaning inside your own network. [RFC 1918](https://datatracker.ietf.org/doc/html/rfc1918) reserves three ranges for private use, and [RFC 6598](https://datatracker.ietf.org/doc/html/rfc6598) adds a fourth for ISPs. You will see them everywhere:

| CIDR range       | Addresses                      | Where you usually meet it                 |
| ---------------- | ------------------------------ | ----------------------------------------- |
| `10.0.0.0/8`     | 10.0.0.0 to 10.255.255.255     | corporate networks, cloud VPCs            |
| `172.16.0.0/12`  | 172.16.0.0 to 172.31.255.255   | Docker's default bridge, cloud VPCs       |
| `192.168.0.0/16` | 192.168.0.0 to 192.168.255.255 | home routers                              |
| `100.64.0.0/10`  | 100.64.0.0 to 100.127.255.255  | carrier-grade NAT inside an ISP's network |

A NAT device (your home router, a cloud NAT gateway) rewrites private addresses to a public one on the way out, which is how a whole office shares one public IP.

The practical debugging consequences:

- If a server's "IP address" starts with 10., 172.16-31., or 192.168., that address is useless to anyone outside the network it lives in. A common cause of "it works from here but not from home."
- Two different networks can both use 192.168.1.0/24 internally. VPNs between them then collide, and packets go to the wrong place with no error message.
- If your router's "public" address is in `100.64.0.0/10`, you are behind your ISP's NAT and cannot accept inbound connections.

### Using ipcalc

[ipcalc](./tools/ipcalc.md) does the subnet math: give it an address in CIDR notation and it prints the network, netmask, broadcast, and usable host range.

```bash
ipcalc 10.130.75.80/26
```

The most common question it answers is "are these two IPs in the same subnet?" Run it on both addresses and compare the network lines.

To check whether your connection has working IPv6, open <https://ipv6.test-ipv6.com/>.

# Tcpdump

[tcpdump](https://www.tcpdump.org/) captures packets off a network
interface. When logs and tools disagree, a packet capture settles the
argument. Captures are usually written to a `.pcap` file and analyzed in
[Wireshark](https://www.wireshark.org/) afterwards.

Capturing requires root/administrator privileges on every platform.

## Availability

| Platform         | How to get it                                                                                   |
| ---------------- | ------------------------------------------------------------------------------------------------ |
| Windows (Cygwin) | not available; Cygwin cannot capture raw packets                                                |
| Windows (native) | use [Wireshark](https://www.wireshark.org/) with Npcap, or the built-in `pktmon` on Windows 10+ |
| Fedora           | `sudo dnf install tcpdump`                                                                      |
| Ubuntu / Debian  | `sudo apt install tcpdump`                                                                      |

## Examples

- Find your interface names first:

```bash
tcpdump -D
```

- Capture all UDP traffic to/from 1.1.1.1 on interface `wlp7s0`, full
  packets (`-s 0`), written to a pcap file for Wireshark (this example was
  used to debug DNSSEC responses from Cloudflare's resolver):

```bash
sudo tcpdump -i wlp7s0 -s 0 -w /tmp/dnssec-cdc4.pcap "host 1.1.1.1 and udp"
```

- Watch DNS queries live on screen, without name resolution (`-nn`) so
  tcpdump itself does not generate DNS traffic:

```bash
sudo tcpdump -i any -nn port 53
```

- Watch TCP connection attempts to a host. If you see SYNs going out with
  no SYN/ACK coming back, a firewall along the path is dropping them (see
  the handshake walkthrough in [Network Basics](../basic-networking.md)):

```bash
sudo tcpdump -i any -nn "host 192.168.122.15 and tcp port 443"
```

- Read a saved capture back (or open the file in Wireshark):

```bash
tcpdump -nn -r /tmp/dnssec-cdc4.pcap
```

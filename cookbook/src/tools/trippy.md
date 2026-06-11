# Trippy

[Trippy](https://trippy.rs/) ([GitHub](https://github.com/fujiapple852/trippy))
combines ping and traceroute in a live terminal UI: it continuously probes
every hop on the path and accumulates per-hop loss and latency statistics,
like mtr. Reach for it when a connection is flaky and you need to know
which hop is losing the packets.

The binary is named `trip`.

## Availability

| Platform         | How to get it                                                                                        |
| ---------------- | ----------------------------------------------------------------------------------------------------- |
| Windows (Cygwin) | not packaged for Cygwin; use the native Windows build                                                |
| Windows (native) | `winget install trippy` (requires [Npcap](https://npcap.com/) and an admin terminal)                 |
| Fedora           | `sudo dnf copr enable atim/trippy && sudo dnf install trippy`, or `cargo install trippy`             |
| Ubuntu / Debian  | `sudo add-apt-repository ppa:fujiapple/trippy && sudo apt install trippy`, or `cargo install trippy` |

Like traceroute, it needs raw sockets: run with `sudo` on Linux (or grant
the binary `CAP_NET_RAW`), and from an administrator terminal on Windows.

## Examples

- Trace a host and watch per-hop loss/latency accumulate (press `q` to quit):

```bash
sudo trip www.google.com
```

- Use TCP probes to port 443 instead of ICMP. TCP probes get through
  networks that drop ICMP, and they experience the path closer to how your
  actual HTTPS traffic does:

```bash
sudo trip www.google.com --protocol tcp --target-port 443
```

- Unprivileged mode: no sudo, ICMP via datagram sockets. This works on
  macOS, and on Linux when the `ping` group range is configured:

```bash
trip www.google.com --unprivileged
```

## Related Tools

- [mtr](https://github.com/traviscross/mtr), the classic continuous
  traceroute that Trippy modernizes; `sudo dnf install mtr` /
  `sudo apt install mtr-tiny`. Not packaged for Cygwin; WinMTR exists as an
  old native Windows port.

# Iperf3

[iperf3](https://github.com/esnet/iperf) measures the maximum achievable
bandwidth between two machines. Unlike most tools in this guide, it has to
run on both ends: one side acts as a server, the other connects to it as a
client. Run it when you need to know whether the link itself is slow or the
application on top of it is.

## Availability

| Platform         | How to get it                                                                                   |
| ---------------- | ------------------------------------------------------------------------------------------------ |
| Windows (Cygwin) | not packaged for Cygwin                                                                         |
| Windows (native) | unofficial builds from [iperf.fr](https://iperf.fr/iperf-download.php) or `winget` / chocolatey |
| Fedora           | `sudo dnf install iperf3`                                                                       |
| Ubuntu / Debian  | `sudo apt install iperf3`                                                                       |

## Examples

- On the server side (listens on TCP/UDP port 5201 by default, so open that
  port in the firewall):

```bash
iperf3 -s
```

- On the client side, run a 10 second TCP throughput test:

```bash
iperf3 -c <server IP>
```

- Measure the reverse direction (server sends, client receives) without
  swapping roles. Asymmetric links are common, so test both directions:

```bash
iperf3 -c <server IP> -R
```

- Use 4 parallel streams for 30 seconds. Parallel streams do a better job
  of saturating high-bandwidth, high-latency links:

```bash
iperf3 -c <server IP> -P 4 -t 30
```

- UDP test at a fixed 100 Mbit/s rate. The report includes jitter and
  packet loss, which TCP tests hide:

```bash
iperf3 -c <server IP> -u -b 100M
```

- Machine-readable output for graphing later:

```bash
iperf3 -c <server IP> --json > result.json
```

## Public Servers

When you do not control the far end, a list of volunteer-run public iperf3
servers is maintained at [iperf3serverlist.net](https://iperf3serverlist.net/).

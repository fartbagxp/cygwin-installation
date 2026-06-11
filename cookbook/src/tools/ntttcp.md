# NTttcp

[NTttcp](https://github.com/microsoft/ntttcp) is Microsoft's network
throughput benchmark, the Windows-native counterpart to [iperf3](./iperf.md).
Like iperf3 it requires a sender and a receiver, one on each end of the
link. Microsoft also maintains
[ntttcp-for-linux](https://github.com/microsoft/ntttcp-for-linux), so a
mixed Windows and Linux path can be benchmarked with the same tool family
on both ends.

## Availability

| Platform         | How to get it                                                                            |
| ---------------- | ----------------------------------------------------------------------------------------- |
| Windows (native) | download from the [NTttcp GitHub releases](https://github.com/microsoft/ntttcp/releases) |
| Windows (Cygwin) | not packaged; run the native Windows binary                                              |
| Fedora / Ubuntu  | build [ntttcp-for-linux](https://github.com/microsoft/ntttcp-for-linux) from source      |

## Examples

- Receiver side (`-r`), using 8 threads, listening on its own address:

```cmd
ntttcp -r -m 8,*,<receiver IP>
```

- Sender side (`-s`), matching parameters, run for 60 seconds:

```cmd
ntttcp -s -m 8,*,<receiver IP> -t 60
```

## Related Tools

- [ctsTraffic](https://github.com/microsoft/ctsTraffic), another Microsoft
  traffic generator. It is better suited to long-running reliability and
  connection churn testing than to raw throughput numbers.

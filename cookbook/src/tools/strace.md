# strace

[strace](https://strace.io) traces the system calls a Linux process makes.
It shows what a program actually does, regardless of what its own logging
claims: which config and certificate files it opens, which addresses it
connects to, which DNS lookups it issues. When a tool fails mysteriously
with no useful error, strace is how you find out why.

## Availability

| Platform         | How to get it                                                                                                                          |
| ---------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| Windows (Cygwin) | Cygwin ships its own `strace.exe`, but it is a different Cygwin-specific tracer for Cygwin processes, not the Linux strace             |
| Windows (native) | no equivalent; [Sysinternals Process Monitor](https://learn.microsoft.com/en-us/sysinternals/downloads/procmon) covers the same ground |
| Fedora           | `sudo dnf install strace`                                                                                                              |
| Ubuntu / Debian  | `sudo apt install strace`                                                                                                              |

## Examples

- Which files does this program open? Classic use: find out which CA bundle
  or config file a TLS client is really reading:

```bash
strace -e trace=openat wget -vv https://classic.yarnpkg.com 2>&1 | grep cert
```

- Show only network-related syscalls (connect, sendto, recvfrom...), follow
  child processes, and trace each child into its own output file:

```bash
strace -e trace=network -ff -o /tmp/dig-trace dig somename.com
```

- Attach to an already-running process by PID (requires sudo for processes
  you do not own):

```bash
sudo strace -p <PID> -e trace=network
```

- Time every syscall to find where a slow program is stuck. A `connect` or
  `poll` taking seconds points at the network; a slow `openat` on NFS
  points at the filesystem:

```bash
strace -T -e trace=network curl -s https://example.com -o /dev/null
```

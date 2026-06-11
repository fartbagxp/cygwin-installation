# Netstat

netstat shows the sockets currently open on the local machine: which ports
are listening, which connections are established, and (with privileges)
which process owns each one. Run it when a service refuses connections and
you want to confirm it is actually listening, or when you want to see what
a machine is talking to.

On modern Linux, netstat (from `net-tools`) is considered legacy; `ss` from
the `iproute2` package is faster and always installed. Windows ships its
own native `netstat.exe`, which works fine from a Cygwin terminal, so there
is no separate Cygwin netstat package.

## Availability

| Platform         | How to get it                                                           |
| ---------------- | ------------------------------------------------------------------------ |
| Windows (Cygwin) | use the native Windows `netstat.exe` (works inside the Cygwin terminal) |
| Fedora           | `sudo dnf install net-tools` (or use `ss`, preinstalled)                |
| Ubuntu / Debian  | `sudo apt install net-tools` (or use `ss`, preinstalled)                |

## Examples (Linux)

- Show established SSH connections, with the owning process
  (`-t` TCP, `-n` numeric, `-p` process, `-a` all):

```bash
sudo netstat -tnpa | grep 'ESTABLISHED.*sshd'
```

- What is listening, on which port, and which process owns it:

```bash
sudo netstat -ltnp
```

- The same questions answered with `ss`:

```bash
ss -tnp state established '( dport = :22 or sport = :22 )'
ss -ltnp
```

## Examples (Windows, native netstat.exe)

- All connections and listeners, numeric, with owning process ID
  (map the PID with Task Manager or `tasklist | findstr <PID>`):

```cmd
netstat -ano
```

- Include the executable name (requires an elevated/administrator shell):

```cmd
netstat -anob
```

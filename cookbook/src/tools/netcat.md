# Netcat

netcat (`nc`) is the swiss army knife for raw TCP/UDP connectivity: it opens
a connection (or listens for one) and pipes bytes. Because there is no
protocol on top to confuse things, it isolates the most basic question in
network debugging: can I reach that host on that port at all? In handshake
terms (see [Network Basics](../basic-networking.md)), a successful `nc -vz`
means the TCP three-way handshake completed.

## Availability

| Platform         | How to get it                                                                      |
| ---------------- | ----------------------------------------------------------------------------------- |
| Windows (Cygwin) | install the [nc](https://cygwin.com/packages/summary/nc.html) package (also `nc6`) |
| Fedora           | `sudo dnf install nmap-ncat` (provides `nc`)                                       |
| Ubuntu / Debian  | `sudo apt install netcat-openbsd`                                                  |

## Versions

Several incompatible implementations share the `nc` name: the original/GNU
netcat, the OpenBSD rewrite (Ubuntu's default, adds IPv6 and UNIX sockets),
and nmap's `ncat` (Fedora's default, adds TLS and proxying). Their flags
differ. If an example below fails, run `nc -h` to see which one you have.

## Examples

Simple port test (`-v` verbose, `-z` scan only, do not send data):

- NC via TCP with a 3 second timeout

```bash
nc -vz -w 3 <destination IP> 443
```

- NC via UDP with a 3 second timeout. Treat UDP "success" with suspicion:
  it only means nothing actively refused the packet, since UDP has no
  handshake to confirm delivery.

```bash
nc -vz -u -w 3 <destination IP> 443
```

- Continuous NC via TCP with a 3 second timeout every 5 seconds:

```bash
watch -n 5 nc -vz -w 3 <destination IP> 443
```

or with a plain shell loop:

```bash
while true; do nc -vz -w 3 <destination IP> 443; sleep 5; done;
```

## Listen on a port

Listening is the other half of debugging connectivity. Run a listener on
the destination, connect from the source, and you have tested the path
without involving any real application.

- Listen on TCP port 8080, then from the other machine connect with
  `nc <listener IP> 8080`. Anything typed on one side appears on the other:

```bash
nc -l 8080
```

- Quick one-shot file transfer (start the receiver first, then the sender):

```bash
nc -l 9000 > received-file        # on the receiver
nc <receiver IP> 9000 < file      # on the sender
```

## Admin Privilege

Admin privilege (ex. sudo) is needed when listening on a privileged port
between 1-1024.

For example, the following will require `sudo`:

```bash
sudo nc -l 443
```

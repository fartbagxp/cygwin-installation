# Ipcalc

ipcalc is a subnet calculator: give it an address in CIDR notation and it
prints the network address, netmask, broadcast address, and usable host
range. It saves you from doing binary math in your head while reading
firewall rules or cloud VPC definitions.

Beware that several unrelated programs share the name. Fedora ships its own
ipcalc, while Debian and Ubuntu ship a Perl version with different output
and flags. The examples below work on both, but check `ipcalc --help` on
your system.

## Availability

| Platform         | How to get it                                                                 |
| ---------------- | ------------------------------------------------------------------------------ |
| Windows (Cygwin) | install the [ipcalc](https://cygwin.com/packages/summary/ipcalc.html) package |
| Fedora           | `sudo dnf install ipcalc`                                                     |
| Ubuntu / Debian  | `sudo apt install ipcalc` (or `sipcalc` for an alternative)                   |

## Examples

- What network does this host live in, and what is the usable range?

```bash
ipcalc 10.130.75.80/26
```

On Debian/Ubuntu's ipcalc this prints the network (`10.130.75.64/26`), the
broadcast address (`10.130.75.127`), and the 62 usable hosts in between.
Run it on two addresses and compare the network lines to settle whether
they are in the same subnet.

- Same question for a /22 you see in a cloud VPC:

```bash
ipcalc 172.31.48.0/22
```

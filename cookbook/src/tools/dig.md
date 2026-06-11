# Dig

[dig](https://bind9.readthedocs.io/en/latest/manpages.html#dig-dns-lookup-utility)
(domain information groper) is the standard DNS lookup tool from BIND.
Reach for it first when a name does not resolve, resolves to the wrong
address, or resolves differently depending on which resolver you ask.

## Availability

| Platform         | How to get it                                                                         |
| ---------------- | ------------------------------------------------------------------------------------- |
| Windows (Cygwin) | install the [bind-utils](https://cygwin.com/packages/summary/bind-utils.html) package |
| Windows (native) | no official build; `nslookup` or PowerShell `Resolve-DnsName` are rough equivalents   |
| Fedora           | `sudo dnf install bind-utils`                                                         |
| Ubuntu / Debian  | `sudo apt install bind9-dnsutils` (older releases: `dnsutils`)                        |

## Examples

- Just the answer, no noise:

```bash
dig +short www.google.com
```

- Query a specific record type:

```bash
dig +short www.google.com AAAA
dig +short google.com MX
dig +short google.com TXT
```

- Ask a specific resolver. Comparing your local resolver against a public
  one is the quickest way to spot split-horizon DNS or a stale cache:

```bash
dig @8.8.8.8 www.google.com
dig @1.1.1.1 www.google.com
```

- Reverse lookup of an IP:

```bash
dig -x 8.8.8.8 +short
```

- Trace the delegation from the root servers down. This shows which
  nameserver actually hands out the answer:

```bash
dig +trace www.google.com
```

- Check the SOA serial on each authoritative nameserver to spot a zone
  change that has not propagated:

```bash
dig +nssearch google.com
```

- Watch a record continuously (for example, while waiting for a DNS change
  to propagate). Use **Ctrl+C** to kill.

```bash
while true; do dig +short www.va.gov; sleep 5; done
```

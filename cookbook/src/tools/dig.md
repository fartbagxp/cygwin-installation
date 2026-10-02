# Dig

[dig](https://bind9.readthedocs.io/en/latest/manpages.html#dig-dns-lookup-utility) (domain information groper) is the standard DNS lookup tool from BIND. It's the first thing to run when a name does not resolve, resolves to the wrong address, or resolves differently depending on which resolver we ask.

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

- Ask a specific resolver. Comparing your local resolver against a public one is the quickest way to spot split-horizon DNS or a stale cache:

```bash
dig @8.8.8.8 www.google.com
dig @1.1.1.1 www.google.com
```

- Reverse lookup of an IP:

```bash
dig -x 8.8.8.8 +short
```

- Trace the delegation from the root servers down. This shows which nameserver actually hands out the answer:

```bash
dig +trace www.google.com
```

- Check the SOA serial on each authoritative nameserver to spot a zone change that has not propagated:

```bash
dig +nssearch google.com
```

- Watch a record continuously (for example, while waiting for a DNS change to propagate). Use **Ctrl+C** to kill.

```bash
while true; do dig +short www.va.gov; sleep 5; done
```

## EDNS Client Subnet

With EDNS Client Subnet (ECS), a recursive resolver forwards part of your address (usually the /24) to the authoritative server. CDNs use that to pick an edge near you instead of near the resolver, which is why the same name can resolve to different addresses depending on who asks.

- Pretend to be in a different network and compare the answers. Google Public DNS refuses anything longer than a /24, so give it a network like `120.5.5.0/24` rather than a single IP:

```bash
dig +short @8.8.8.8 google.com +subnet=120.5.5.0/24
dig +short @8.8.8.8 google.com +subnet=121.5.5.0/24
```

Without `+short`, the OPT pseudosection shows a `CLIENT-SUBNET` line. The last number on it is the scope the authoritative server used for its answer.

- Find out what subnet a resolver forwards for you. A TXT query for `o-o.myaddr.l.google.com` returns the resolver's egress IP, plus an `edns0-client-subnet` line when ECS was sent:

```bash
dig +nocmd @dns.google. -t txt o-o.myaddr.l.google.com +nocomments +noall +answer +stats
dig +nocmd @resolver1.opendns.com -t txt o-o.myaddr.l.google.com +nocomments +noall +answer +stats
dig +nocmd @one.one.one.one -t txt o-o.myaddr.l.google.com +nocomments +noall +answer +stats
```

Google and OpenDNS return the `edns0-client-subnet` line. Cloudflare's 1.1.1.1 leaves ECS out for privacy, so you only get its own address back. Sites that geolocate with ECS can hand 1.1.1.1 users a far-away or wrong answer, and [archive.is refused to resolve properly through 1.1.1.1](https://webapps.stackexchange.com/questions/135222/why-does-1-1-1-1-not-resolve-archive-is/135223#135223) over exactly this.

Jim Nitterauer's [NolaCon 2017 talk on ECS](https://www.youtube.com/watch?v=pKp0igVsUhs) covers both the CDN and security sides of it.

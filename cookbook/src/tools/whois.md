# Whois

whois looks up the registration records behind a domain name, IP address,
or autonomous system (AS) number. When an unfamiliar IP shows up in your
logs or in a traceroute, whois tells you who owns it and which network it
belongs to. Different registries hold different data, so the useful trick
is the `-h` flag, which asks a specific whois server.

## Availability

| Platform         | How to get it                                                                        |
| ---------------- | -------------------------------------------------------------------------------------- |
| Windows (Cygwin) | install the [whois](https://cygwin.com/packages/summary/whois.html) package          |
| Windows (native) | [Sysinternals whois](https://learn.microsoft.com/en-us/sysinternals/downloads/whois) |
| Fedora           | `sudo dnf install whois`                                                             |
| Ubuntu / Debian  | `sudo apt install whois`                                                             |

## Examples

- Who registered a domain:

```bash
whois google.com
```

- Who owns an IP block, asking ARIN (the registry for North America)
  directly:

```bash
whois -h whois.arin.net "152.130.0.0"
whois -h whois.arin.net 8.8.8.8
```

- Map an IP to its AS number and network name via Team Cymru. This is the
  fastest way to find which provider an address belongs to:

```bash
whois -h whois.cymru.com 40.119.152.231
```

- List every route (prefix) an AS announces, via the RADb routing registry.
  Here AS32934 is Facebook; this kind of query is useful when building
  firewall allowlists:

```bash
whois -h whois.radb.net -- '-i origin AS32934' | grep ^route
```

- Look up which registered route covers an IP:

```bash
whois -h whois.radb.net 8.8.8.8
```

- Query the RIPE database (Europe/Middle East) for an IPv6 address, without
  recursing to other registries:

```bash
whois -r --sources RIPE 2a03:2880:20ff:d::face:b00c
```

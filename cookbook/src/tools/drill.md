# Drill

[drill](https://nlnetlabs.nl/projects/ldns/about/) is a DNS lookup tool from NLnet Labs' ldns library, built as a dig replacement with DNSSEC support baked in. It behaves like dig and offers the ability to chase DNSSEC signature chain from a record all the way up to the root. But when dealing with DNSSEC, it's better off to use [delv](delv.md) which specializes in DNSSEC records.

## Availability

| Platform         | How to get it                                                            |
| ---------------- | ------------------------------------------------------------------------ |
| Windows (Cygwin) | not packaged for Cygwin; use [dig](./dig.md) / [delv](./delv.md) instead |
| Fedora           | `sudo dnf install ldns-utils`                                            |
| Ubuntu / Debian  | `sudo apt install ldnsutils`                                             |

## Examples

- Basic lookup, dig-style:

```bash
drill www.google.com
drill @8.8.8.8 google.com TXT
```

- Reverse lookup:

```bash
drill -x 8.8.8.8
```

- Trace a name from the root servers down (like `dig +trace`):

```bash
drill -T www.google.com
```

- Chase the DNSSEC signature chain from the record up to the root, printing every DNSKEY/DS link along the way (`-D` requests DNSSEC records, `-S` chases the chain):

```bash
drill -DS www.cdc.gov
```

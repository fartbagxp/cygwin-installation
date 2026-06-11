# Drill

[drill](https://nlnetlabs.nl/projects/ldns/about/) is a DNS lookup tool from
NLnet Labs' ldns library, built as a dig replacement with DNSSEC support
baked in. Day to day it behaves like dig. The reason to learn it is the one
trick dig lacks: chasing a DNSSEC signature chain from a record all the way
up to the root.

## Availability

| Platform         | How to get it                                                             |
| ---------------- | -------------------------------------------------------------------------- |
| Windows (Cygwin) | not packaged for Cygwin; use [dig](./dig.md) / [delv](./delv.md) instead  |
| Fedora           | `sudo dnf install ldns-utils`                                             |
| Ubuntu / Debian  | `sudo apt install ldnsutils`                                              |

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

- Chase the DNSSEC signature chain from the record up to the root, printing
  every DNSKEY/DS link along the way (`-D` requests DNSSEC records, `-S`
  chases the chain):

```bash
drill -DS www.cdc.gov
```

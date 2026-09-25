# Delv

[delv](https://bind9.readthedocs.io/en/latest/manpages.html#delv-dns-lookup-and-validation-utility)
(domain entity lookup and validation) is dig's DNSSEC-aware sibling from
BIND 9. Where dig shows you the raw DNS answer, delv performs full DNSSEC
validation itself and tells you why a chain of trust fails. That is exactly
what you need when a domain works on one resolver but returns SERVFAIL on a
validating one.

## Availability

| Platform         | How to get it                                                                             |
| ---------------- | ----------------------------------------------------------------------------------------- |
| Windows (Cygwin) | included in the [bind-utils](https://cygwin.com/packages/summary/bind-utils.html) package |
| Fedora           | `sudo dnf install bind-utils`                                                             |
| Ubuntu / Debian  | `sudo apt install bind9-dnsutils`                                                         |

## Examples

- Validate a record and show the validation result (`; fully validated` or
  `; unsigned` in the output):

```bash
delv www.cdc.gov A
```

- Show the full validation logic step by step with `+vtrace`, and format
  multi-line records readably with `+multi`. Querying the same TLSA (DANE)
  record through several public resolvers tells you whether a DNSSEC problem
  lives in the zone itself or in one resolver's cache:

```bash
delv @1.1.1.1 cdc.gov TLSA +multi +vtrace
delv @8.8.8.8 cdc.gov TLSA +multi +vtrace
delv @62.149.128.4 cdc.gov TLSA +multi +vtrace
delv @208.67.220.220 cdc.gov TLSA +multi +vtrace
delv @208.67.222.222 cdc.gov TLSA +multi +vtrace
delv @185.228.169.9 cdc.gov TLSA +multi +vtrace
```

- See what a broken domain looks like. Instead of a bare SERVFAIL, delv
  prints the specific failure (expired signature, missing DS record, bogus
  chain):

```bash
delv dnssec-failed.org A +rtrace
```

## Rapid Verification

Web-based tools for cross-checking a DNSSEC problem you found with delv:

- [DNSViz](https://dnsviz.net/), which draws the whole chain of trust
- [Verisign DNSSEC Debugger](https://dnssec-debugger.verisignlabs.com/)
- [Ianix DNSSEC Outages](https://ianix.com/pub/dnssec-outages.html)

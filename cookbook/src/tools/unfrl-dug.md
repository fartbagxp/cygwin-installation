# Dug

[dug](https://github.com/unfrl/dug) is a global DNS propagation checker: it
queries hundreds of public DNS servers around the world at once and reports
what each one answers. Use it after a DNS change to see how far the new
record has spread, or to detect regional DNS poisoning and filtering, where
a domain resolves differently by country.

- [Worldwide DNS servers it queries](https://github.com/unfrl/dug/blob/main/cli/Resources/default_servers.csv)

## Availability

dug is a .NET application distributed from
[GitHub releases](https://github.com/unfrl/dug/releases). There is no
Cygwin, dnf, or apt package in the standard repositories.

| Platform         | How to get it                                                                                   |
| ---------------- | ------------------------------------------------------------------------------------------------ |
| Windows          | download the Windows binary from GitHub releases (runs natively; usable from a Cygwin terminal) |
| Fedora           | download the `.rpm` from GitHub releases                                                        |
| Ubuntu / Debian  | download the `.deb` from GitHub releases                                                        |

## Examples

- Quick propagation check with the pretty default output:

```bash
dug vaccines.gov
```

- Query 500 servers worldwide with retries, exporting everything to CSV for
  analysis in a spreadsheet (which countries see the old record, response
  times, DNSSEC status, errors):

```bash
dug vaccines.gov --retries 10 --server-count 500 --output-format CSV --output-template ipaddress,countrycode,city,dnssec,reliability,continentcode,countryname,countryflag,citycountryname,citycountrycontinentname,responsetime,recordtype,haserror,errormessage,errorcode,value > vaccines.gov-output.csv
```

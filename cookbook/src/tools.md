# Tools

Cygwin packages a large set of open source Unix tools for Windows. These are the ones I reach for when a network problem needs diagnosing, plus a few that only run on Linux.

The table shows where each tool comes from on each platform: a Cygwin package on Windows, and a dnf or apt package on Fedora and Ubuntu. N/A in the Cygwin column means the tool is not packaged for Cygwin. Several of those have native Windows builds instead; each tool's own page has the details.

## Open Source Tools

| Command Line Tool | Cygwin Package      | Fedora (dnf)      | Ubuntu (apt)      | Usage                                                          |
| ----------------- | ------------------- | ----------------- | ----------------- | -------------------------------------------------------------- |
| [curl]            | curl                | curl              | curl              | command line tool for sending/receiving web requests           |
| [dig]             | bind-utils          | bind-utils        | bind9-dnsutils    | DNS lookup tool, like nslookup but more useful                 |
| [delv]            | bind-utils          | bind-utils        | bind9-dnsutils    | DNS lookup with full DNSSEC validation and tracing             |
| [drill]           | N/A                 | ldns-utils        | ldnsutils         | dig-like DNS tool with DNSSEC signature chasing                |
| [git]             | git                 | git               | git               | version control; useful for debugging SSH/TLS transport issues |
| [ipcalc]          | ipcalc              | ipcalc            | ipcalc            | IP addressing calculator for subnet in CIDR notation           |
| [iperf3]          | N/A                 | iperf3            | iperf3            | measure throughput between two machines                        |
| [mtr]             | N/A                 | mtr               | mtr-tiny          | traceroute that keeps running and tracks per-hop loss          |
| [netcat]          | nc, nc6             | nmap-ncat         | netcat-openbsd    | swiss army knife for testing network connectivity              |
| netstat           | Windows netstat.exe | net-tools (or ss) | net-tools (or ss) | show listening ports and open connections                      |
| [ntttcp]          | N/A                 | build from source | build from source | Microsoft's network throughput benchmark                       |
| [openssl]         | openssl             | openssl           | openssl           | toolkit for testing SSL/TLS connections and certificates       |
| [openssh]         | openssh             | openssh-clients   | openssh-client    | ssh, sftp, and scp                                             |
| [rsync]           | rsync               | rsync             | rsync             | resumable, bandwidth-limited file synchronization over SSH     |
| [strace]          | N/A                 | strace            | strace            | trace the system calls a process makes (Linux)                 |
| [tcpdump]         | N/A                 | tcpdump           | tcpdump           | capture packets for reading in Wireshark                       |
| [testssl]         | runs in Cygwin bash | testssl           | testssl.sh        | scan a webserver's TLS protocols, ciphers, and certificates    |
| [trippy]          | N/A                 | copr or cargo     | PPA or cargo      | mtr with a nicer live terminal UI                              |
| [unfrl/dug]       | N/A                 | GitHub .rpm       | GitHub .deb       | query DNS servers worldwide to check propagation               |
| [watch]           | procps              | procps-ng         | procps            | re-run a command on an interval and watch its output           |
| [whois]           | whois               | whois             | whois             | look up who owns a domain, IP, or AS number                    |

[curl]: https://cygwin.com/packages/summary/curl.html
[dig]: https://cygwin.com/packages/summary/bind-utils.html
[delv]: https://cygwin.com/packages/summary/bind-utils.html
[drill]: https://nlnetlabs.nl/projects/ldns/about/
[git]: https://cygwin.com/packages/summary/git.html
[ipcalc]: https://cygwin.com/packages/summary/ipcalc.html
[iperf3]: https://iperf.fr/iperf-download.php
[mtr]: https://github.com/traviscross/mtr
[netcat]: https://cygwin.com/packages/summary/nc.html
[ntttcp]: https://github.com/microsoft/ntttcp
[openssl]: https://cygwin.com/packages/summary/openssl.html
[openssh]: https://cygwin.com/packages/summary/openssh.html
[rsync]: https://cygwin.com/packages/summary/rsync.html
[strace]: https://strace.io
[tcpdump]: https://www.tcpdump.org/
[testssl]: https://testssl.sh/
[trippy]: https://github.com/fujiapple852/trippy#binary-asset-download
[unfrl/dug]: https://github.com/unfrl/dug
[watch]: https://cygwin.com/packages/summary/procps-ng.html
[whois]: https://cygwin.com/packages/summary/whois.html

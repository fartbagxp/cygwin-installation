# Debug

Practical guides for debugging network problems, with examples. Most of it is stuff I kept having to look up again, so I wrote it down.

Part of it covers setting up [Cygwin](https://www.cygwin.com/), a Linux-like environment for Windows, as a networking toolbox on a machine where you don't have admin rights.

The examples pair well with [Wireshark](https://www.wireshark.org/) (needs admin rights) and the [Windows Sysinternals Suite](https://docs.microsoft.com/en-us/sysinternals/downloads/sysinternals-suite).

Find the [guide online](https://fartbagxp.github.io/cygwin-installation).

For deeper dives into networking, I recommend [TCP/IP Illustrated Volume 1](https://en.wikipedia.org/wiki/TCP/IP_Illustrated).

## Running Locally

- Install the [mdBook CLI](https://github.com/rust-lang/mdBook/releases) installed.
- Run `make preview` and open `localhost:3000` in your browser.

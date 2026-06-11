# Git

[git](https://git-scm.com/) is not a network tool, but git fetches and
pushes fail for network reasons all the time: SSH key problems, TLS
interception by corporate proxies, blocked ports. Git has built-in knobs
that expose what its transport (SSH or HTTPS) is actually doing.

## Availability

| Platform         | How to get it                                                           |
| ---------------- | ------------------------------------------------------------------------ |
| Windows (Cygwin) | install the [git](https://cygwin.com/packages/summary/git.html) package |
| Windows (native) | [Git for Windows](https://gitforwindows.org/)                           |
| Fedora           | `sudo dnf install git`                                                  |
| Ubuntu / Debian  | `sudo apt install git`                                                  |

## Debugging Git over SSH

Make git's underlying ssh invocation verbose. The output shows which key is
offered, which host key is received, and where authentication fails:

```bash
GIT_SSH_COMMAND="ssh -vvv" git clone <REPO_SSH_URL>
```

Test SSH authentication to the host directly, without git:

```bash
ssh -T git@github.com
```

## Debugging Git over HTTPS

Show the full HTTP conversation including TLS handshake and proxy usage:

```bash
GIT_CURL_VERBOSE=1 GIT_TRACE=1 git clone <REPO_HTTPS_URL>
```

Point git at a corporate CA bundle when a TLS-intercepting proxy breaks
certificate verification (prefer this over disabling verification):

```bash
git config --global http.sslCAInfo /path/to/corporate-ca-bundle.pem
```

## Interesting Links

- [Git documentation on environment variables](https://git-scm.com/book/en/v2/Git-Internals-Environment-Variables)

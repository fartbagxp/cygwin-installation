# SSH

[OpenSSH](https://www.openssh.com/) is the standard client for encrypted
remote shells, and also a general-purpose transport: file transfer
([sftp](./sftp.md), [rsync](./rsync.md)), [git](./git.md), and port
forwarding all ride on it. For network debugging, the verbose mode and the
tunneling features are diagnostic tools in their own right.

## Availability

| Platform         | How to get it                                                                    |
| ---------------- | ---------------------------------------------------------------------------------- |
| Windows (Cygwin) | install the [openssh](https://cygwin.com/packages/summary/openssh.html) package  |
| Windows (native) | Windows 10+ optional feature "OpenSSH Client" (`ssh.exe` in PowerShell)          |
| Fedora           | `sudo dnf install openssh-clients`                                               |
| Ubuntu / Debian  | `sudo apt install openssh-client` (usually preinstalled)                         |

Cygwin and native Windows OpenSSH keep separate configuration. Cygwin reads
`~/.ssh` inside the Cygwin home; native Windows reads `C:\Users\<you>\.ssh`.
Keys set up in one are not seen by the other.

## Debugging a connection

Verbose mode walks through each phase of the connection: TCP connect, host
key exchange, which keys are offered, which authentication methods fail.
Add up to `-vvv` for more detail:

```bash
ssh -v username@host
```

## SSH Config

Put per-host settings in `~/.ssh/config` so connections are reproducible and
short to type:

```text
Host jumpbox
  HostName bastion.example.com
  User boris
  IdentityFile ~/.ssh/id_ed25519

Host internal-db
  HostName 10.0.12.5
  User boris
  ProxyJump jumpbox
```

With the above, `ssh internal-db` transparently hops through the bastion.

## Port forwarding

- Local forward: expose a remote-only service on your own machine. Here, a
  database reachable only from the jump host appears on `localhost:5432`:

```bash
ssh -L 5432:db.internal:5432 username@jumpbox
```

- Dynamic forward: turn the SSH connection into a SOCKS proxy on
  `localhost:1080`, then point tools like [curl](./curl.md) at
  `socks5h://localhost:1080`:

```bash
ssh -D 1080 username@jumpbox
```

## Key Generation

- Preferred modern key type (ed25519), with extra KDF rounds on the
  passphrase:

```bash
ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/id_ed25519 -C "example-email@gmail.com"
```

- RSA fallback for old servers that do not support ed25519:

```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -C "example-email@gmail.com"
```

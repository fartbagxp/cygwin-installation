# SFTP

sftp is an interactive file transfer client that runs over SSH, part of the
OpenSSH suite. If you can `ssh` to a machine, you can almost always `sftp`
to it on the same port 22 with no extra server setup. It replaces legacy
FTP, which sent credentials in cleartext.

## Availability

| Platform         | How to get it                                                                       |
| ---------------- | ------------------------------------------------------------------------------------ |
| Windows (Cygwin) | included in the [openssh](https://cygwin.com/packages/summary/openssh.html) package |
| Windows (native) | included in Windows 10+ optional feature "OpenSSH Client"                           |
| Fedora           | `sudo dnf install openssh-clients`                                                  |
| Ubuntu / Debian  | `sudo apt install openssh-client` (usually preinstalled)                            |

## Examples

- Open an interactive session (then use `ls`, `cd`, `get`, `put`, `exit`):

```bash
sftp username@192.168.122.15
```

- Connect on a non-standard port (note: capital `-P`, unlike ssh):

```bash
sftp -P 2222 username@192.168.122.15
```

- Download or upload a single file without an interactive session:

```bash
sftp username@host:/var/log/app.log /tmp/
sftp local-file.txt username@host:/upload/
```

- Recursively download a whole directory:

```bash
sftp -r username@host:/var/log/myapp /tmp/logs/
```

- Scripted/batch mode. It runs the listed commands, exits non-zero on
  failure, and suits cron jobs:

```bash
echo 'put report.csv /incoming/' | sftp -b - username@host
```

Since sftp is just SSH underneath, debugging a failing connection is the
same as debugging [ssh](./ssh.md): add `-v`.

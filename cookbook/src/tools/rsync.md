# Rsync

[rsync](https://rsync.samba.org/) synchronizes files between machines (or
directories) and only transfers the parts that changed. It runs over SSH by
default, resumes interrupted transfers, and can throttle its own bandwidth.
That combination is why you reach for it on flaky or slow links, where
`scp` would start over from zero.

## Availability

| Platform         | How to get it                                                               |
| ---------------- | ---------------------------------------------------------------------------- |
| Windows (Cygwin) | install the [rsync](https://cygwin.com/packages/summary/rsync.html) package |
| Fedora           | `sudo dnf install rsync`                                                    |
| Ubuntu / Debian  | `sudo apt install rsync`                                                    |

rsync must be installed on both ends of the transfer. On Cygwin, local
Windows paths are written as `/cygdrive/c/...`.

## Examples

The flag bundle used below: `-a` archive (recurse, preserve permissions and
times), `-v` verbose, `-h` human-readable sizes, `-z` compress in transit,
`-S` handle sparse files, `-P` show progress and keep partial files so
interrupted transfers resume.

- rsync push from local to remote:

```bash
rsync -avhzSP --stats folder-of-interest/ username@192.168.122.15:/share/folder-of-interest/
```

- rsync pull from remote to local, limited to about 3.6 MB/s so the
  transfer does not saturate the link, with permissions forced on arrival:

```bash
rsync -avhzSP --stats --bwlimit=3600 --perms --chmod=a+rwx username@subdomain.domain.com:/home/username/completed/tv.shows/ /share/tv.shows/
```

- Dry run first, to see what would be transferred or deleted before doing it:

```bash
rsync -avhn --delete folder-of-interest/ username@192.168.122.15:/share/folder-of-interest/
```

Beware the trailing slash: `folder/` means "the contents of folder", while
`folder` means "the folder itself". Get it wrong and everything lands one
directory deeper than you wanted.

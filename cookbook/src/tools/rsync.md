# Rsync

## Examples

- rsync push from local to remote

```bash
rsync -avhzSP --stats folder-of-interest/ username@192.168.122.15:/share/folder-of-interest/
```

- rsync pull from remote to local

```bash
rsync -avhzSP --stats --bwlimit=3600 --perms --chmod=a+rwx username@subdomain.domain.com:/home/username/completed/tv.shows/ /share/tv.shows/
```

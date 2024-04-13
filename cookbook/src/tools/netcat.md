# Netcat

## Examples

Simple port test:

NC via TCP with a 3 second timeout

```bash
nc -vz -w 3 <destination IP> 443
```

NC via UDP with a 3 second timeout

```bash
nc -vz -u -w 3 <destination IP> 443
```

Continuous NC via TCP with a 3 second timeout every 5 seconds

```bash
watch -n 5 nc -vz -u -w 3 <destination IP> 443
```

## Versions

Multiple versions, BSD being oldest.
nmap reimplemented it.

```bash
while true; do nc -vz -u -w 3 <destination IP> 443; sleep 5; done;
```

## Admin Privilege

Admin Privilege (ex. sudo) is needed when listening on a higher privilege port between 1-1024.

For example, the following will require `sudo`.

```bash
sudo nc -l 443
```

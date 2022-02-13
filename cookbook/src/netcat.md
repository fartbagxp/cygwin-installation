## Network Diagnosis

Simple port test:

NC via TCP with a 3 second timeout

```
nc -vz -w 3 <destination IP> 443
```

NC via UDP with a 3 second timeout

```
nc -vz -u -w 3 <destination IP> 443
```

Continuous NC via TCP with a 3 second timeout every 5 seconds

```
watch -n 5 nc -vz -u -w 3 <destination IP> 443
```

```
while true; do nc -vz -u -w 3 <destination IP> 443; sleep 5; done;
```

# Latency

Latency is how long a packet takes to travel from one machine to another.
What most tools report is round-trip time (RTT): there and back again. The
two get conflated constantly, so when someone quotes "latency to the
server", check whether they mean one way or round trip. The difference is a
factor of two.

Bandwidth and latency are independent. A 10 Gbit/s link to Sydney still
takes 160 ms to deliver the first byte, and no upgrade changes that. You can
buy more bandwidth; you cannot buy a lower speed of light.

## Speed of light in fiber

Light travels 299,792 km/s in a vacuum. The glass in optical fiber has a
refractive index of about 1.5, so light inside it moves at roughly 200,000
km/s. That gives a rule of thumb worth memorizing:

```text
one-way time (ms) ≈ distance (km) ÷ 200
round-trip time (ms) ≈ distance (km) ÷ 100
```

Worked example for New York to London: 5,585 km ÷ 200 = 28 ms one way, so
56 ms round trip. That is the physical floor. Measured RTTs run higher
because cables do not follow great circles, and every router along the path
adds queueing and processing delay.

| Route                     | Distance  | One way in fiber | Minimum RTT | Typical measured RTT |
| ------------------------- | --------- | ---------------- | ----------- | -------------------- |
| London to Frankfurt       | 640 km    | 3 ms             | 6 ms        | 10 to 15 ms          |
| New York to San Francisco | 4,148 km  | 21 ms            | 41 ms       | about 60 ms          |
| New York to London        | 5,585 km  | 28 ms            | 56 ms       | about 75 ms          |
| New York to Sydney        | 15,993 km | 80 ms            | 160 ms      | 200 ms and up        |

Now connect this to the handshake arithmetic from
[Network Basics](./basic-networking.md): a cold HTTPS request spends about
four round trips (DNS, TCP, TLS, then the request itself) before the first
byte of content arrives. At 75 ms RTT that is 300 ms of pure waiting, with
zero bytes of payload moved. This is why CDNs put servers near users: the
only way to cut propagation delay is to shorten the distance.

## Jitter

Jitter is the variation in latency from packet to packet. A path with a
steady 80 ms RTT feels fine on a video call; a path that swings between 40
and 150 ms breaks up, even though its average looks better. Interactive
traffic (VoIP, video, SSH typing, games) cares about jitter as much as
about latency itself.

The usual cause is queueing: a router with oversized buffers absorbs bursts
of traffic and drains them slowly, a problem known as bufferbloat. Wi-Fi
retransmissions and route changes add to it.

To measure it, run a UDP test with [iperf3](./tools/iperf.md), which reports
jitter directly:

```bash
iperf3 -c <server IP> -u -b 10M
```

or watch the per-hop standard deviation column in
[trippy](./tools/trippy.md) or mtr to find which hop introduces the
variation.

## Further Reading

- [High Performance Browser Networking](https://hpbn.co/primer-on-latency-and-bandwidth/#speed-of-light-and-propagation-latency)

- [TCP and the Lower Bounds of Web Performance](https://www.stevesouders.com/blog/2010/07/13/velocity-tcp-and-the-lower-bound-of-web-performance/)

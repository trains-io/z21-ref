## z21-sim

Headless [Z21 LAN protocol](https://www.z21.eu) test server for local development and automated tests.

The container runs [ZIMO-Elektronik/Z21](https://github.com/ZIMO-Elektronik/Z21) **Z21Posix** — a reference implementation of the Z21 UDP API, not Roco hardware firmware. It listens on UDP port **21105**, the same port as a physical Z21 command station.

Z21Posix is patched at build time to answer `LAN_GET_SERIAL_NUMBER` with a simulator serial: decimal prefix **999** plus a time-based suffix fixed for the lifetime of the process (for example `9991730123`).

### Prerequisites

- Docker

### Quick start

```bash
make build
make run
```

Stop the simulator:

```bash
make stop
```

### Makefile

Run `make` or `make help` for available targets and variables.

### Manual Docker usage

Build:

```bash
docker build --build-arg Z21_VERSION=v0.4.0 -t z21-sim:local .
```

Run (custom host port if 21105 is taken):

```bash
docker run --rm -d --name z21-sim -p 21107:21105/udp z21-sim:local
```

View logs:

```bash
docker logs -f z21-sim
```

Stop:

```bash
docker rm -f z21-sim
```

### License

[MIT](LICENSE)

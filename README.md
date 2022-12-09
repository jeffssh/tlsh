# tlsh
Certificate pinning reverse shell. The certificate is embedded in both `tlsh` and `tlshl`, and the key is embedded in `tlshl`. Every build will generate a new key pair, along with new binaries that have the certificate/key embedded in them. One binary will not work with a binary from another build.

## Build
By default, tlsh will build for the current architecture. There are 5 build time variables that can be overridden during a call to make. To build for a different architecture, specify the relevant `GOOS` and `GOARCH` values. By default, tlsh will reach out to 127.0.0.1:1337. 

**Build variables:**
```
IP=127.0.0.1
PORT=1337
BINPATH=/bin/bash
GOOS=
GOARCH=
```

Example usage: `make TLSH_GOOS=linux TLSH_GOARCH=amd64 TLSHL_GOOS=linux TLSHL_GOARCH=arm`


**Supported GOOS and GOARCH:**
| GOOS      | GOARCH   |
| --------- | -------- |
| android   | arm      |
| darwin    | 386      |
| darwin    | amd64    |
| darwin    | arm      |
| darwin    | arm64    |
| dragonfly | amd64    |
| freebsd   | 386      |
| freebsd   | amd64    |
| freebsd   | arm      |
| linux     | 386      |
| linux     | amd64    |
| linux     | arm      |
| linux     | arm64    |
| linux     | ppc64    |
| linux     | ppc64le  |
| linux     | mips     |
| linux     | mipsle   |
| linux     | mips64   |
| linux     | mips64le |
| netbsd    | 386      |
| netbsd    | amd64    |
| netbsd    | arm      |
| openbsd   | 386      |
| openbsd   | amd64    |
| openbsd   | arm      |
| plan9     | 386      |
| plan9     | amd64    |
| solaris   | amd64    |
| windows   | 386      |
| windows   | amd64    |
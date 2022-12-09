IP=127.0.0.1
PORT=1337
BINPATH=/bin/bash
TLSH_GOOS=
TLSH_GOARCH=
TLSHL_GOOS=
TLSHL_GOARCH=


all:
	make clean
	make key-cert-pair
	make build

build:
	go get ./...
	CGO_ENABLED=0 GOOS=$(TLSH_GOOS) GOARCH=$(TLSH_GOARCH) go build -o tlsh -ldflags "-X main.lAddr=$(IP):$(PORT) -X main.binPath=$(BINPATH)" ./cmd/tlsh/main.go
	CGO_ENABLED=0 GOOS=$(TLSHL_GOOS) GOARCH=$(TLSHL_GOARCH) go build -o tlshl -ldflags "-X main.lAddr=$(IP):$(PORT) -X main.binPath=$(BINPATH)" ./cmd/tlshl/main.go

key-cert-pair:
	mkdir cert 2>/dev/null
	bash -c "openssl req -x509 -new -newkey rsa:2048 -nodes -keyout cert/server.key -out cert/server.csr -subj \"/O=tlsh/\" -extensions SAN -reqexts SAN -config <(cat /etc/ssl/openssl.cnf <(printf \"\n[ SAN ]\nsubjectAltName=IP:$(IP)\n\"))"
	cp cert/server.csr cmd/tlsh/server.csr
	cp cert/server.csr cmd/tlshl/server.csr
	cp cert/server.key cmd/tlshl/server.key

clean:
	rm -f tlsh*
	rm -rf cert

	rm -f cmd/tlsh/server.csr
	rm -f cmd/tlshl/server.csr
	rm -f cmd/tlshl/server.key
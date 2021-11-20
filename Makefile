IP=127.0.0.1
PORT=1337
BINPATH=/bin/bash
GOOS=
GOARCH=


all:
	make clean
	make key-cert-pair
	make build

build:
	go get ./...
	CGO_ENABLED=0 GOOS=$(GOOS) GOARCH=$(GOARCH) go build -o . -ldflags "-X main.lAddr=$(IP):$(PORT) -X main.binPath=$(BINPATH)" ./...

key-cert-pair:
	bash -c "openssl req -x509 -new -newkey rsa:2048 -nodes -keyout cert/server.key -out cert/server.csr -subj \"/O=tlsh/\" -extensions SAN -reqexts SAN -config <(cat /etc/ssl/openssl.cnf <(printf \"\n[ SAN ]\nsubjectAltName=IP:$(IP)\n\"))"
	cp cert/server.csr cmd/tlsh/server.csr
	cp cert/server.csr cmd/tlshl/server.csr
	cp cert/server.key cmd/tlshl/server.key

clean:
	rm -f tlsh*

	rm -f cert/server.csr 
	rm -f cert/server.key 

	rm -f cmd/tlsh/server.csr
	rm -f cmd/tlshl/server.csr
	rm -f cmd/tlshl/server.key
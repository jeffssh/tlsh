build:
	go get ./...
	go build -o . -ldflags "-X main.lAddr=$(LADDR) -X main.binPath=$(BINPATH)" ./...

key-cert-pair:
	bash -c "openssl req -x509 -new -newkey rsa:2048 -nodes -keyout cert/server.key -out cert/server.csr -subj \"/O=tlsh/\" -extensions SAN -reqexts SAN -config <(cat /etc/ssl/openssl.cnf <(printf \"\n[ SAN ]\nsubjectAltName=IP:$(IP)\n\"))"
	cp cert/server.csr cmd/tlsh/server.csr

run:
	go run main.go

clean:
	rm tlsh tlshl
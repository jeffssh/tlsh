package main

import (
	// "fmt"
	// "io"

	"crypto/tls"
	"fmt"
	"io"
	"log"
	"net"
	"os"
)

var lAddr string = "127.0.0.1:1337"
var serverKeyFile string = "cert/server.key"
var serverCertFile string = "cert/server.csr"

func errCheck(err error) {
	if err != nil {
		log.Fatalf("%v", err)
	}
}

func main() {
	cert, err := tls.LoadX509KeyPair(serverCertFile, serverKeyFile)
	errCheck(err)
	config := &tls.Config{
		Certificates: []tls.Certificate{cert},
	}
	fmt.Println(lAddr)
	l, err := tls.Listen("tcp", lAddr, config)
	errCheck(err)
	defer l.Close()

	for {
		log.Printf("Accepting connections on %s", lAddr)
		conn, err := l.Accept()
		errCheck(err)
		handleConn(conn)
	}
}

func handleConn(conn net.Conn) {
	log.Printf("Got Connection from %s", conn.RemoteAddr())
	defer conn.Close()
	doneChan := make(chan int)
	go func() {
		io.Copy(os.Stdout, conn)
		doneChan <- 0
	}()
	go func() {
		io.Copy(conn, os.Stdin)
		doneChan <- 0
	}()
	<-doneChan
	log.Println("Connection closed")
}

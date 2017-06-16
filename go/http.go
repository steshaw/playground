package main

import "io"
import "log"
import "net/http"
import "os"

func main() {
	res, err := http.Get("https://golang.org1")
	defer res.Body.Close()
	if err != nil {
		log.Fatal(err)
	}
	io.Copy(os.Stdout, res.Body)
}

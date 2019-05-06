package main

import "time"

func server(i int) {
	for {
		println(i)
		time.Sleep(1)
	}
}

func main() {
	go server(1)
	go server(2)
	time.Sleep(2000)
}

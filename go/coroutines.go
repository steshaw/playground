package main

import "time"
import "fmt"

func expensiveComputation(x int, y int, z int, done chan int) {
  time.Sleep(3000 * 1000 * 1000)
  fmt.Printf("x=%d, y=%d, y=%d\n", x, y, z)
  done <- 1
}

func anotherExpensiveComputation(a string, b string, c string) {
  time.Sleep(2000 * 1000 * 1000)
  fmt.Printf("a=%s, b=%s, c=%s\n", a, b, c)
}

func main() {
  var (
    x = 1
    y = 2
    z = 3
    done = make(chan int)
  )
  go expensiveComputation(x, y, z, done)
  var (
    a = "at"
    b = "banana"
    c = "cat"
  )
  anotherExpensiveComputation(a, b, c)
  i := <-done // Wait for expensiveComputation to be complete before we quit.
  fmt.Printf("bye done=%d\n", i)
}

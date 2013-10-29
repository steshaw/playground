//
// From Derek Collison
//
// See http://www.slideshare.net/derekcollison/go-conference-japan
//

package main

import (
//  "fmt"
  "os"
//  "testing"
  "runtime"
)

func stack() {
  var a [22]int
    as := a[:0]
    for i := 0; i < 22; i++ { 
      as = append(as, 22) 
    }
}

func stackOverrun() {
  var a [22]int
  as := a[:0]

  for i := 0; i < 100; i++ {
    as = append(as, 22)
  }
}

func reportHeap(str string) {
  var m runtime.MemStats
  runtime.GC()
  runtime.ReadMemStats(&m)
  println(str, m.HeapObjects)
}

//func TestStack(t *testing.T) {
func main() {
  reportHeap("stack HEAP (before):")
  stack()
  reportHeap("stack HEAP (after):")

  reportHeap("stackOverrun HEAP (before):")
  stackOverrun()
  reportHeap("stackOverrun HEAP (after):")

  os.Stdout.Sync()
}

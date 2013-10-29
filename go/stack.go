//
// From Derek Collison
//
// See http://www.slideshare.net/derekcollison/go-conference-japan
//

package main

import (
//  "fmt"
//  "os"
//  "testing"
  "runtime"
)

func stack22() {
  var a [22]int
    as := a[:0]
    for i := 0; i < 22; i++ { 
      as = append(as, 99) 
    }
}

func stack100() {
  var a [100]int
    as := a[:0]
    for i := 0; i < 100; i++ { 
      as = append(as, 99) 
    }
}

func stack1000() {
  var a [1000]int
    as := a[:0]
    for i := 0; i < 1000; i++ { 
      as = append(as, 99) 
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
  reportHeap("stack 22 HEAP (before):")
  stack22()
  reportHeap("stack 22 HEAP (after):")

  reportHeap("stack 100 HEAP (before):")
  stack100()
  reportHeap("stack 100 HEAP (after):")

  reportHeap("stack 1000 HEAP (before):")
  stack1000()
  reportHeap("stack 1000 HEAP (after):")

//  os.Stdout.Sync()
}

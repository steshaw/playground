/* 
 * From http://flyingfrogblog.blogspot.com/2009/01/mono-22-still-leaks-memory.html
 */

type 'a cell = { content: 'a; mutable next: 'a cell option }

do
  let mutable tail = None
  if tail = None then
    let cell = { content = [||]; next = None }
    cell.next <- Some cell
    tail <- Some cell
  while true do
    let tail' = Option.get tail
    let cell = Some { content = [|1.;2.;3.;4.|]; next = tail'.next }
    tail'.next <- cell
    tail <- cell
    let tail' = Option.get tail
    tail'.next <- (Option.get tail'.next).next

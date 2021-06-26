/*
 * From http://flyingfrogblog.blogspot.com/2009/01/mono-does-not-support-tail-calls.html
 */
let even odd n = odd(n+1)

let odd n =
printf "%d\n" n
even odd (n+1)

let (_: int) =
even odd 0

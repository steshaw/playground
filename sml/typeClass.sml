(*
 * See "Modular Type Classes" 
 *   http://www.mpi-sws.org/~dreyer/talks/popl07.ppt
 *   http://www.mpi-sws.org/~dreyer/papers/mtc/main-short.pdf
 *   http://www.mpi-sws.org/~dreyer/research.html
 *)

signature EQ = sig
  type t
  val eq: t -> t -> bool
end

signature LT = sig
  type t
  val lt: t -> t -> bool
end

signature ORD = sig
  structure E: EQ
  structure L: LT
  sharing type E.t = L.t
end

structure EqInt: EQ = struct
  type t = int
  fun eq a b = a = b
end

structure LtInt: LT = struct
  type t = int
  fun lt a b = a < b
end

abstype Set = List of int
with
  val empty = []
  fun insert(s, n) = n :: s
  fun isEmpty(s) = List.null s
  fun contains(s, n: int) = List.exists (fn elem => elem = n) s
end

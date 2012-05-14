structure Set :> SET = 
struct
  type Set = int list
  val empty = []
  fun insert(s, n) = n :: s
  fun isEmpty(s) = List.null s
  fun contains(s, n: int) = List.exists (fn elem => elem = n) s
end

(* Lists *)

fun length nil = 0
  | length (_::t) = 1 + length t

fun append (nil, l) = l
  | append (h::t, l) = h :: append (t, l)

fun rev nil = nil
  | rev (h::t) = rev t @ [h]

local
    fun rev_helper (nil, a) = a
      | rev_helper (h::t, a) = rev_helper (t, h::a)
in
    fun rev l = rev_helper (l, nil)
end


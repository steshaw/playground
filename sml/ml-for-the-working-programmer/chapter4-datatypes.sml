datatype person = King
                | Peer of string * string * int
                | Knight of string
                | Peasant of string;

King;
Peer;
Knight;
Peasant;

fun title King                    = "His Majesty the King"
  | title (Peer(deg,territory,_)) = "The " ^ deg ^ " of " ^ territory
  | title (Knight name)           = "Sir " ^ name
  | title (Peasant name)          = name;

fun superior (King, Peer _)        = true
  | superior (King, Knight _)      = true
  | superior (King, Peasant _)     = true
  | superior (Peer _, Knight _)    = true
  | superior (Peer _, Peasant _)   = true
  | superior (Knight _, Peasant _) = true
  | superior _                     = false;

(* Not the same as above, here Kings are superior to Kings *)
fun superior' (King, _)             = true
  | superior' (Peer _, Knight _)    = true
  | superior' (Peer _, Peasant _)   = true
  | superior' (Knight _, Peasant _) = true
  | superior' _                     = false;

fun rank King              = 4
  | rank (Peer _)          = 3
  | rank (Knight _)        = 2
  | rank (Peasant _)       = 1;

(* faithfully matches function 'superior' *)
fun superior'' p1 p2 = (rank p1) > (rank p2);

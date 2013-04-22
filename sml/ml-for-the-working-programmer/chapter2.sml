val pi = 3.14159;

val message = "Hello. \
              \This is a\
              \ test"

val space_character = #" ";

val character_a = #"a";

fun digit i = String.sub("0123456789", i);

fun sign(n) =
          if n>0 then 1
     else if n=0 then 0
     else (*n<0*) ~1;

fun isLower c = #"a" <= c andalso c <= #"z";

fun isValidDate d m =
  (* 30 days has September, April, June and November *)
  if m = "September" orelse m = "April" orelse m = "June" orelse m = "November"
  then 1 <= d andalso d <= 30
  (* Also the rest of 31 except February which as 28 except in leap years *)
  else if m = "February" then 1 <= d andalso d <= 28
  else if m = "January" orelse m = "March" orelse m = "May" orelse m = "July"
       orelse m = "August" orelse m = "October" orelse m = "December"
       then 1 <= d andalso d <= 31
  else false



type king = {name : string, 
             born : int,
             crowned : int,
             died : int,
             quote : string};

fun lifetime (k: king) = #died k - #born k;

fun lifetime' ({name, born, crowned, died, quote}) = died - born;

infix xor;
fun (p xor q) = (p orelse q) andalso not (p andalso q);

infix 6 plus; (* same precedence as '+' in ML *)
fun (a plus b) = "(" ^ a ^ "+" ^ b ^ ")";

"1" plus "2" plus "3";

infix 7 times; (* same precedence as '*' in ML *)
fun (a times b) = "(" ^ a ^ "*" ^ b ^ ")";

"m" times "n" times "3" plus "i" plus "j" times "k";

infixr 8 pow;
fun (a pow b) = "(" ^ a ^ "**" ^ b ^ ")";

"m" times "i" pow "j" pow "2" times "n";

type vec = real * real

infix ++;
fun ((x1,y1) ++ (x2,y2)) : vec = (x1+x2, y1+y2);

nonfix *;
val result = * (2,3);
infix 6 *;
val oops = 1 + 2 * 3;
infix 7 *; (* put '*' back to correct precedence and fixivity *)
val good = 1 + 2 * 3;

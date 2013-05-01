
(* from 3.7 *)
(*
 * This algorithm is greed (it always chooses the largest coin).
 * This means it can't make change for 16 given coins 5 and 2.
 *)
fun change (coinvals, 0)         = []
  | change (c::coinvals, amount) =
      if amount<c then change (coinvals, amount)
                  else c::change (c::coinvals, amount -c);

val gb_coins = [50,20,10,5,2,1]
and us_coins = [25,10,5,1];

print("change\n");
change(gb_coins, 43);
change(us_coins, 43);
change([5,2], 16) 
  handle Match => (print "Cannot make change for 16 using [5, 2]\n"; []);

fun allChange (coins, coinvals,    0)      = [coins]
  | allChange (coins, []      ,    amount) = []
  | allChange (coins, c::coinvals, amount) =
      if amount < 0 then []
      else allChange (c::coins, c::coinvals, amount-c) @ 
           allChange(coins, coinvals, amount);

print("allChange\n");
allChange([], [10, 2], 27);
allChange([], [5,2], 16);
allChange([], gb_coins, 43);
allChange([], us_coins, 43);
allChange([], gb_coins, 16);

exception Change;

(* backtracking coin change *)
fun backChange (coinvals, 0)         = []
  | backChange ([], amount)          = raise Change
  | backChange (c::coinvals, amount) = 
      if amount < 0 then raise Change
      else c :: backChange(c::coinvals, amount-c)
           handle Change => backChange(coinvals, amount);

print("backChange\n");
backChange([10, 2], 27)
  handle Change => (print "Cannot make change for 27 using [10, 2]\n"; []);
backChange([5,2], 16);
backChange(gb_coins, 16);
backChange(gb_coins, 43);
backChange(us_coins, 43);


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

(* with coinvals being a list of pairs - snd being the number of coins available *)
fun allChangef (coins, coinvals, 0)             = [coins]
  | allChangef (coinn, [], amount)              = []
  | allChangef (coins, (c,0)::coinvals, amount) = allChangef(coins, coinvals, amount)
  | allChangef (coins, (c,n)::coinvals, amount) =
      if amount < 0 then []
      else allChangef(c::coins, (c,n-1)::coinvals, amount-c) @
           allChangef(coins, coinvals, amount);

print("allChangef\n");
allChangef([], [(10,100), (2,100)], 27);
allChangef([], [(5,2),(2, 10)], 16);
(* GB and US coins with 3 available of every denomination *)
val gb_coinsf = [(50,3),(20,3),(10,3),(5,3),(2,3),(1,3)]
and us_coinsf = [(25,3),(10,3),(5,3),(1,3)];
allChangef([], gb_coinsf, 43);
allChangef([], us_coinsf, 43);
allChangef([], gb_coinsf, 16);

(* Faster version of allChange using extract argument as accumulator for list.
 * Avoids appending the result lists. *)
fun allChange2 (coins, coinvals, 0, coinslist)         = coins::coinslist
  | allChange2 (coins, [], amount, coinslist)          = coinslist
  | allChange2 (coins, c::coinvals, amount, coinslist) =
      if amount < 0 then coinslist
      else allChange2(c::coins, c::coinvals, amount-c, 
                      allChange2(coins, coinvals, amount, coinslist));
print("allChange2\n");
allChange2([], [10, 2], 27, []);
allChange2([], [5,2], 16, []);
allChange2([], gb_coins, 43, []);
allChange2([], us_coins, 43, []);
allChange2([], gb_coins, 16, []);

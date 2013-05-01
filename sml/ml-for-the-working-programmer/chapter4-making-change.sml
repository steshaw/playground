
(* from 3.7 *)
val gb_coins = [50,20,10,5,2,1]
and us_coins = [25,10,5,1];

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

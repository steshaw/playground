
# A correction of Matthias' code posted at http://beust.com/weblog/archives/000508.html

bet = 1.00
for experiments in 1..5 do
  otaku = 0.00 # start with nothing
  me = 1_000_000.00 # start with a million bucks

  # do a million bets
  1_000_000.times do
    x = 1 + rand(100)
    me -= bet
    if x <= 50 then
      otaku += bet
    elsif x >= 51 and x <= 65 then
      me += bet
    elsif x >= 66 and x <= 75 then
      me += 1.5 * bet
      otaku -= 0.5 * bet
    elsif x >= 76 and x <= 99 then
      me += 2 * bet
      otaku -= bet
    elsif x == 100 then
      me += 3 * bet
      otaku -= 2 * bet
    else
      throw "oops"
    end
  end

  puts if experiments > 1
  printf "me    $%.2f\n", me
  printf "otaku $%.2f\n", otaku
end

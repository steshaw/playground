module unit_testing

my.fact : Nat -> Nat
my.fact Z     = 1
my.fact (S k) = (S k) * (my.fact k)

test0 : so (my.fact 0 == 1)
test0 = oh

test1 : so (my.fact 4 == 24)
test1 = oh

test2 : so (my.fact 1 == 1)
test2 = oh

test3 : so (my.fact 3 == 6)
test3 = oh

test4 : so (my.fact 5 == 120)
test4 = oh

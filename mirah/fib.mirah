def fib(a:int)
  if a < 2
    a
  else
    fib(a - 1) + fib(a - 2)
  end
end

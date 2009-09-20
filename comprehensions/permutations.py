
def permutations(xs):
  if xs:
    return [[x] + ys
            for x in xs
            for ys in permutations([i for i in xs if i != x])]
  else:
    return [[]]

print(permutations([1,2,3]))

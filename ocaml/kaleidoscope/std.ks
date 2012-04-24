extern putchard(char)
extern printd(x)

# I/O sequencing operator
def binary : 1 (x y) 0;  # Low-precedence operator that ignores operands.

# Logical unary not.
def unary!(v)
  if v then
    0
  else
    1

def unary - (v)
  0 - v

def binary > 10 (lhs rhs)
  rhs < lhs

def binary | 5 (lhs rhs)
  if lhs then
    1
  else if rhs then
    1
  else
    0

def binary & 6 (lhs rhs)
  if !lhs then
    0
  else
    !!rhs

def binary = 9 (lhs rhs)
  !(lhs < rhs | lhs > rhs)

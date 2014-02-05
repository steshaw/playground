JS = hello.js
BIN = hello reverse vectIndex evens greet bounds bmain
IBC = prims.ibc vectPredicate.ibc
IBC_NO_PRELUDE = Nat.ibc

.PHONY: all
all: $(JS) $(BIN) $(IBC) $(IBC_NO_PRELUDE)

.PHONY: clean
clean:
	rm -f *.ibc $(BIN)

hello.js:
	idris --codegen javascript -o hello.js hello.idr

hello:
	idris -o hello hello.idr

reverse:
	idris -o reverse reverse.idr

vectIndex:
	idris vectIndex.idr -o vectIndex

evens:
	idris evens.idr -o evens

greet:
	idris greet.idr -o greet

bounds:
	idris bounds.idr -o bounds

bmain:
	idris bmain.idr -o bmain

prims.ibc:
	idris --check prims.idr

vectPredicate.ibc:
	idris --check vectPredicate.idr

Nat.ibc:
	idris --noprelude --check Nat.idr

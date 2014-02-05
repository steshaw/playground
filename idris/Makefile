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

$(BIN): %: %.idr
	idris $< -o $@

$(IBC): %.ibc: %.idr
	idris --check $<

Nat.ibc:
	idris --noprelude --check Nat.idr

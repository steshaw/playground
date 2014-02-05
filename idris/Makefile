JS = hello.js
BIN = hello reverse vectIndex evens greet bounds bmain
IBC = Nat.ibc prims.ibc vectPredicate.ibc

.PHONY: all
all: $(JS) $(BIN) $(IBC)

.PHONY: clean
clean:
	rm -f *.ibc $(BIN)

hello.js:
	idris --codegen javascript -o hello.js hello.idr

$(BIN): %: %.idr
	idris $< -o $@

$(IBC): %.ibc: %.idr
	idris --check $(IDRIS_FLAGS) $<

Nat.ibc: IDRIS_FLAGS = --noprelude

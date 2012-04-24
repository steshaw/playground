#!/bin/bash

LLVM_OCAML_LIB=/Users/steshaw/.shelly/local/llvm-3.0/lib/ocaml

Build() {
  ocamlbuild \
      -cflags -I,$LLVM_OCAML_LIB \
      -lflags -I,$LLVM_OCAML_LIB \
      "$@"
}

if [[ $# -eq 0 ]]; then
  Build toy.native
else
  Build "$@"
fi

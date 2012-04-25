#!/bin/bash

LLVM_OCAML_LIB=$(llvm-config --libdir)/ocaml

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

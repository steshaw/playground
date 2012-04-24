#!/bin/bash

LLVM_OCAML_LIB=/Users/steshaw/.shelly/local/llvm-3.0/lib/ocaml

ocamlbuild \
    -cflags -I,$LLVM_OCAML_LIB \
    -lflags -I,$LLVM_OCAML_LIB \
    "$@"

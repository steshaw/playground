open Ocamlbuild_plugin;;

ocaml_lib ~extern:true "llvm";;
ocaml_lib ~extern:true "camlp4";;
(*
ocaml_lib ~extern:true "camlp4oof";;
*)


(* 
flag ["link"; "ocaml"; "g++"] (S[A"-cc"; A"g++"]);;

let packages = "camlp4,llvm";;

flag ["link"; "ocaml"; "g++"] (S[A"-cc"; A"g++"]);;
flag ["pp"; "ocaml"] (S[A"camlp4oof"]);;
flag ["compile"; "ocaml"] (S[A"-I"; A"+camlp4"]);;
 *)

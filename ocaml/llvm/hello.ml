open Printf
open Llvm

let main filename =
   let m = create_module filename in

   (* @greeting = global [14 x i8] c"Hello, world!\00" *)
   let greeting =
     define_global "greeting" (const_string "Hello, world!\000") m in

   (* declare i32 @puts(i8* ) *)
   let puts =
     declare_function "puts"
       (function_type i32_type [|pointer_type i8_type|]) m in

   (* define i32 @main() { entry: *)
   let main = define_function "main" (function_type i32_type [| |]) m in
   let at_entry = builder_at_end (entry_block main) in

   (* %tmp = getelementptr [14 x i8]* @greeting, i32 0, i32 0 *)
   let zero = const_int i32_type 0 in
   let str = build_gep greeting [| zero; zero |] "tmp" at_entry in

   (* call i32 @puts( i8* %tmp ) *)
   ignore (build_call puts [| str |] "" at_entry);

   (* ret void *)
   ignore (build_ret (const_null i32_type) at_entry);

   (* write the module to a file *)
   if not (Llvm_bitwriter.write_bitcode_file m filename) then exit 1;
   dispose_module m

let () = match Sys.argv with
  | [|_; filename|] -> main filename
  | _ -> main "a.out"

(*
To use it I just do:

$ ocamlopt -dtypes -cc g++ -I /usr/local/lib/ocaml/ llvm.cmxa 
llvm_bitwriter.cmxa hellow.ml -o hellow
$ ./hellow run.bc
$ llc -f -march=c run.bc -o run.c
$ gcc run.c -o run
run.c:114: warning: conflicting types for built-in function ‘malloc’
run.c: In function ‘main’:
run.c:143: warning: return type of ‘main’ is not ‘int’
$ ./run
Hello, world!
*)

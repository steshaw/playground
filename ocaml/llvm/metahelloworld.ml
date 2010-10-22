(*
 * From: Gordon Henriksen gordonhenriksen at mac.com
 * http://lists.cs.uiuc.edu/pipermail/llvmdev/2007-October/010996.html
 *
 * Not currently compiling against llvm-2.8
 *)

(* metahelloworld.ml *)

open Llvm
open Llvm_bitwriter

let _ =
   let filename = Sys.argv.(1) in
   let m = create_module filename in

   (* @greeting = global [14 x i8] c"Hello, world!\00" *)
   let greeting = define_global "greeting" (make_string_constant
                                              "Hello, world!" true) m in

   (* declare i32 @puts(i8) *)
   let puts = declare_function "puts" (make_function_type i32_type [|
                                         make_pointer_type i8_type |]  false) m in

   (* define i32 @main() {
      entry:               *)
   let main = define_function "main" (make_function_type
                                        i32_type [| |] false) m in
   let at_entry = builder_at_end (entry_block main) in

   (* %tmp = getelementptr [14 x i8]* @greeting, i32 0, i32 0 *)
   let zero = make_int_constant i32_type 0 false in
   let str = build_gep greeting [| zero; zero |] "tmp" at_entry in

   (* call i32 @puts( i8* %tmp ) *)
   ignore (build_call puts [| str |] "" at_entry);

   (* ret void *)
   ignore (build_ret (make_null i32_type) at_entry);

   (* write the module to a file *)
   if not (write_bitcode_file m filename) then exit 1;
   dispose_module m

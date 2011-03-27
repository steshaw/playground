(*
  Motivated by http://bitsquid.blogspot.com/2011/02/some-systems-need-to-manipulate-objects.html 
*)

datatype openStruct 
  = Bool of bool
  | Int of int
  | Float of real
  | String of string
  | Array of openStruct list
  | Dictionary of (string * openStruct) list
  | Vector3 of {x: real, y: real, z: real}
  | Quaternion of {x: real, y: real, z: real, w: real}

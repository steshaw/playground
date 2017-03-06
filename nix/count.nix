with import <nixpkgs> {};
let
  list = ["a" "b" "a" "c" "d" "a"];
  countA = lib.fold (i: acc: if i == "a" then acc + 1 else acc) 0;
in
rec {
  example = lib.fold (x: y: x + y) "" ["a" "b" "c"]; #is "abc"
  result = countA list; #should be 3
}

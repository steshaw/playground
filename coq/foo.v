Definition fred (a:nat) := 0.

Theorem asdf: ~ fred 1 = fred 2.
Proof.
  intros.
  auto.

Theorem foo: forall {X Y: Type} {f : X -> Y},
  forall (x:X) (y:X), (f x = f y -> x = y) -> False.
Proof.
  intros.
  specialize (H fred).

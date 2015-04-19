-- Matthew Brecknell @mbrcknl
-- BFPG.org, March 2015

open import Agda.Primitive using (_⊔_)

postulate
  String : Set

{-# BUILTIN STRING String #-}

-- data Bool = True | False

data bool : Set where
  tt : bool
  ff : bool

if_then_else_ : ∀ {ℓ} {T : bool → Set ℓ}
  → (b : bool) → T tt → T ff → T b
if tt then x else y = x
if ff then x else y = y

ex₀ : bool → String
ex₀ tt = "hi"
ex₀ ff = "bye"

-- data Nat = Zero | Succ Nat

data ℕ : Set where
  zero : ℕ
  succ : ℕ → ℕ

{-# BUILTIN NATURAL ℕ #-}

_plus_ : ℕ → ℕ → ℕ
zero plus n = n
succ m plus n = succ (m plus n)

ex₁ : ℕ
ex₁ = 2 plus 3

data [_] (α : Set) : Set where
  ◇ : [ α ]
  _,_ : α → [ α ] → [ α ]

infixr 6 _,_

_++_ : ∀ {α} → [ α ] → [ α ] → [ α ]
◇ ++ ys = ys
(x , xs) ++ ys = x , (xs ++ ys)

ex₂ : [ ℕ ]
ex₂ = (0 , 1 , 2 , ◇) ++ (3 , 4 , ◇)

data _≡_ {ℓ} {α : Set ℓ} (x : α) : α → Set ℓ where
  refl : x ≡ x

data Zero : Set where

{-# BUILTIN EQUALITY _≡_ #-}
{-# BUILTIN REFL refl #-}

ex₃ : (2 plus 3) ≡ 5
ex₃ = refl

ex₄ : 0 ≡ 1 → Zero
ex₄ ()

cong : ∀ {α β : Set} {x y : α} (f : α → β) → x ≡ y → f x ≡ f y
cong {x = x} {y = .x} _ refl = refl

ex₅ : ∀ n → (n plus 0) ≡ n
ex₅ zero = refl
ex₅ (succ n) = cong succ (ex₅ n)

--
-- Sigma types
--

-- data Either a b = Left a | Right b

data _+_ (α β : Set) : Set where
  «_ : α → α + β
  »_ : β → α + β

ex₆ ex₇ : String + ℕ
ex₆ = « "hi"
ex₇ = » 42

record Σ (I : Set) (V : I → Set) : Set where
  constructor _,_
  field
    fst : I
    snd : V fst

_∨_ : Set → Set → Set
α ∨ β = Σ bool (λ b → if b then α else β)

tosum : ∀ {α β : Set} → α + β → α ∨ β
tosum (« x) = tt , x
tosum (» x) = ff , x

unsum : ∀ {α β : Set} → α ∨ β → α + β
unsum (tt , snd) = « snd
unsum (ff , snd) = » snd

tosum∘unsum : ∀ {α β : Set} (p : α ∨ β) → (tosum (unsum p)) ≡ p
tosum∘unsum (tt , snd) = refl
tosum∘unsum (ff , snd) = refl

unsum∘tosum : ∀ {α β : Set} (p : α + β) → (unsum (tosum p)) ≡ p
unsum∘tosum (« x) = refl
unsum∘tosum (» x) = refl

--
-- Pi types
--

record _×_ (α β : Set) : Set where
  constructor _,_
  field
    fst : α
    snd : β

ex₈ : String × ℕ
ex₈ = "hi" , 42

∏ : (A : Set) → (A → Set) → Set
∏ I V = (i : I) → V i

_∧_ : Set → Set → Set
α ∧ β = (b : bool) → if b then α else β

_,,_ : ∀ {α β : Set} → α → β → α ∧ β
_,,_ x y tt = x
_,,_ x y ff = y

ex₉ : String ∧ ℕ
ex₉ = "hi" ,, 99

tofun : ∀ {α β : Set} → α × β → α ∧ β
tofun (fst , snd) = fst ,, snd

defun : ∀ {α β : Set} → α ∧ β → α × β
defun f = f tt , f ff

tofun∘defun : ∀ {α β : Set} (p : α ∧ β) (b : bool) → tofun (defun p) b ≡ p b
tofun∘defun p tt = refl
tofun∘defun p ff = refl

defun∘tofun : ∀ {α β : Set} (p : α × β) → defun (tofun p) ≡ p
defun∘tofun p = refl

{-

--
-- Heterogeneous lists
--

data _∈_ {α : Set} (x : α) : [ α ] → Set where
  -- zero : ?
  -- succ : ?

exₐ : 0 ∈ (0 , 1 , 2 , ◇)
exₐ = ?

exₑ : 1 ∈ (0 , 1 , 2 , ◇)
exₑ = ?

exᵢ : 3 ∈ (0 , 1 , 2 , ◇) → Zero
exᵢ = ?

data [_⊣_] {I : Set} (V : I → Set) : [ I ] → Set where
  -- ◇ : ?
  -- _,_ : ?

exⱼ : [ (λ b → if b then ℕ else String) ⊣ ff , tt , ff , ◇ ]
exⱼ = ?

_!_ : ∀ {I : Set} {i : I} {is : [ I ]} {V : I → Set} → [ V ⊣ is ] → i ∈ is → Zero
xs ! i = ?

--
-- STLC
--

data Type : Set where
  ι   : Type
  _▷_ : Type → Type → Type

⟨_⟩ : Type → Set
⟨ T ⟩ = ?

data _⊢_ (Γ : [ Type ]) : Type → Set where
  -- lam : ?
  -- _$_ : ?
  -- var : ?

⟪_⊢_⟫ : ∀ {Γ : [ Type ]} {T : Type} → Zero
⟪ γ ⊢ t ⟫ = ?

twice : ∀ {Γ : [ Type ]} {T : Type} → Γ ⊢ ((T ▷ T) ▷ (T ▷ T))
twice = ?

-}


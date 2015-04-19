-- Matthew Brecknell @mbrcknl
-- BFPG.org, March 2015

-- open import Agda.Primitive using (_⊔_)
-- open import Data.String

postulate
  String : Set

{-# BUILTIN STRING String #-}

data Bool : Set where
  true : Bool
  false : Bool

if_then_else_ : forall {T : Set} → Bool → T → T → T
if true then x else y = x
if false then x else y = y

ex₀ : Bool → String
ex₀ true = "true"
ex₀ false = "false"

data ℕ : Set where
  zero : ℕ
  succ : ℕ → ℕ

{-# BUILTIN NATURAL ℕ #-}

_plus_ : ℕ → ℕ → ℕ
zero plus n = n
succ m plus n = succ (m plus n)

ex₁ : ℕ
ex₁ = 10 plus 32

data [_] (α : Set) : Set where
  ◇ : [ α ]
  _,_ : α → [ α ] → [ α ]

infixr 6 _,_

_++_ : ∀ {α} → [ α ] → [ α ] → [ α ]
◇ ++ ys = ys
(x , xs) ++ ys = x , (xs ++ ys)

ex₂ : [ ℕ ]
ex₂ = (1 , 2 , 3 , ◇) ++ (4 , 5 , 6 , ◇)

data _≡_ {ℓ} {α : Set ℓ} (x : α) : α → Set ℓ where
  refl : x ≡ x

-- {-# BUILTIN EQUALITY _≡_ #-}
-- {-# BUILTIN REFL refl #-}

ex₃ : (2 plus 3) ≡ 5
ex₃ = refl

data Zero : Set where

ex₄ : 0 ≡ 1 → Zero
ex₄ ()

another : ∀ n → (0 plus n) ≡ n
another n = refl

cong : {α β : Set} (f : α → β) {x y : α} → x ≡ y → f x ≡ f y
cong _ refl = refl

ex₅ : ∀ n → (n plus 0) ≡ n
ex₅ zero = refl
ex₅ (succ n) = cong succ (ex₅ n)

--
-- Sigma types
--

data _+_ (α β : Set) : Set where
  «_ : α → α + β
  »_ : β → α + β

ex₆ ex₇ : String + ℕ
ex₆ = « "Hi"
ex₇ = » 42

record twice (β : Set) : Set where
  constructor _,_
  field
    fst : Bool
    snd : β

tosum : {β : Set} → (β + β) → twice β
tosum (« x) = true , x
tosum (» x) = false , x

l : twice ℕ
l = tosum (« 3)

r : twice ℕ
r = tosum (» 4)

unsum : {β : Set} → twice β → β + β
unsum (fst , snd) = if fst then « snd else » snd

tosum∘unsum : {β : Set} (p : twice β) → (tosum (unsum p)) ≡ p
tosum∘unsum (true , snd) = refl
tosum∘unsum (false , snd) = refl

unsum∘tosum : {β : Set} (p : β + β) → (unsum (tosum p)) ≡ p
unsum∘tosum (« x) = refl
unsum∘tosum (» x) = refl

{-
--
-- Pi types
--

record _×_ (α β : Set) : Set where
  constructor _,_
  field
    fst : α
    snd : β

ex₈ : String × ℕ
ex₈ = ?

_² : Set → Set
β ² = bool → β

_,,_ : ∀ {β : Set} → β → β → β ²
_,,_ x y b = ?

ex₉ : ℕ ²
ex₉ = ?

tofun : ∀ {β : Set} → β × β → β ²
tofun p = ?

defun : ∀ {β : Set} → β ² → β × β
defun f = ?

tofun∘defun : ∀ {β : Set} (p : β ²) → tofun (defun p) ≡ p
tofun∘defun p = ?

defun∘tofun : ∀ {β : Set} (p : β × β) → defun (tofun p) ≡ p
defun∘tofun p = ?

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

-- Matthew Brecknell @mbrcknl
-- BFPG.org, March 2015

open import Agda.Primitive using (_⊔_)

postulate
  String : Set

{-# BUILTIN STRING String #-}

data bool : Set where
  tt : bool
  ff : bool

ex₀ : bool → String
ex₀ b = ?

{-

if_then_else_ : forall {T : Set} → bool → T → T → T
if b then x else y = ?

data ℕ : Set where
  zero : ℕ
  succ : ℕ → ℕ

{-# BUILTIN NATURAL ℕ #-}

_plus_ : ℕ → ℕ → ℕ
m plus n = ?

ex₁ : ℕ
ex₁ = ?

data [_] (α : Set) : Set where
  ◇ : [ α ]
  _,_ : α → [ α ] → [ α ]

infixr 6 _,_

_++_ : ∀ {α} → [ α ] → [ α ] → [ α ]
xs ++ ys = ?

ex₂ : [ ℕ ]
ex₂ = ?

data _≡_ {α : Set} (x : α) : α → Set where
  refl : x ≡ x

-- {-# BUILTIN EQUALITY _≡_ #-}
-- {-# BUILTIN REFL refl #-}

ex₃ : (2 plus 3) ≡ 5
ex₃ = ?

ex₄ : 0 ≡ 1
ex₄ = ?

ex₅ : ∀ n → (n plus 0) ≡ n
ex₅ n = ?

cong : ∀ {α β : Set} {x y : α} {f : α → β} → x ≡ y → f x ≡ f y
cong eq = ?

--
-- Sigma types
--

data _+_ (α β : Set) : Set where
  «_ : α → α + β
  »_ : β → α + β

ex₆ ex₇ : String + ℕ
ex₆ = ?
ex₇ = ?

record twice (β : Set) : Set where
  constructor _,_
  field
    fst : bool
    snd : β

tosum : ∀ {β : Set} → β + β → twice β
tosum s = ?

unsum : ∀ {β : Set} → twice β → β + β
unsum t = ?

tosum∘unsum : ∀ {β : Set} (p : twice β) → (tosum (unsum p)) ≡ p
tosum∘unsum t = ?

unsum∘tosum : ∀ {β : Set} (p : β + β) → (unsum (tosum p)) ≡ p
unsum∘tosum s = ?

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


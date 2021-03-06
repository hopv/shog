--------------------------------------------------------------------------------
-- Proposition
--------------------------------------------------------------------------------

{-# OPTIONS --without-K --sized-types #-}

module Shog.Logic.Prop where

open import Base.Level using (Level; ↓_)
open import Base.Size using (Size; ∞)
open import Base.Thunk using (Thunk)
open import Base.Func using (_$_; _∘_; it)
open import Base.Few using (binary; absurd)
open import Base.Bool using (Bool; tt; ff)
open import Base.Prod using (_×_; _,_; curry)
open import Base.Nat using (ℕ)
open import Base.List using (List; []; _∷_; map)
open import Base.List.Nat using (mapi)
open import Base.RatPos using (ℚ⁺; 1ᴿ⁺)
open import Shog.Lang.Expr using (Addr; _ₒ_; AnyVal)

--------------------------------------------------------------------------------
-- Prop': Proposition

data  Prop' (ι : Size) :  Set₂

-- Prop˂: Prop' under Thunk
Prop˂ :  Size →  Set₂
Prop˂ ι =  Thunk Prop' ι

private variable
  ι :  Size
  X₀ :  Set₀
  X₁ :  Set₁
  ℓ :  Level
  X :  Set ℓ
  P˙ :  X → Prop' ∞
  P Q R S :  Prop' ∞
  A :  Set ℓ

infixr 5 _→'_ _-∗_
infixr 7 _∗_
infix 8 |=>_ □_
infix 9 _↦⟨_⟩_

data  Prop' ι  where

  -- ∀₁˙, ∃₁˙: Universal/existential quantification over any type X₁ in Set₁,
  --         which does not include Prop' ι itself (predicativity)
  ∀₁˙ ∃₁˙ :  (X₁ → Prop' ι) →  Prop' ι
  -- →': Implication
  _→'_ :  Prop' ι →  Prop' ι →  Prop' ι

  -- ∗: Separating conjunction
  -- -∗: Magic wand
  _∗_ _-∗_ :  Prop' ι →  Prop' ι →  Prop' ι

  -- |=>: Update modality
  -- □: Persistence modality
  |=>_ □_ :  Prop' ι →  Prop' ι

  -- Saveˣ, Save□: Save token, exclusive and persistent
  Saveˣ Save□ :  Prop˂ ι →  Prop' ι

  -- Points-to token
  _↦⟨_⟩_ :  Addr →  ℚ⁺ →  AnyVal →  Prop' ι
  -- Freeing token
  Free :  ℕ →  Addr →  Prop' ι

--------------------------------------------------------------------------------
-- Utility for ∀/∃

∀₀˙ ∃₀˙ :  (X₀ → Prop' ι) →  Prop' ι
∀₀˙ P˙ =  ∀₁˙ $ P˙ ∘ ↓_
∃₀˙ P˙ =  ∃₁˙ $ P˙ ∘ ↓_

∀₁∈-syntax ∃₁∈-syntax ∀₁-syntax ∃₁-syntax :  (X₁ → Prop' ι) →  Prop' ι
∀₁∈-syntax =  ∀₁˙
∃₁∈-syntax =  ∃₁˙
∀₁-syntax =  ∀₁˙
∃₁-syntax =  ∃₁˙
∀₀∈-syntax ∃₀∈-syntax ∀₀-syntax ∃₀-syntax :  (X₀ → Prop' ι) →  Prop' ι
∀₀∈-syntax =  ∀₀˙
∃₀∈-syntax =  ∃₀˙
∀₀-syntax =  ∀₀˙
∃₀-syntax =  ∃₀˙
infix 3 ∀₁∈-syntax ∃₁∈-syntax ∀₁-syntax ∃₁-syntax
  ∀₀∈-syntax ∃₀∈-syntax ∀₀-syntax ∃₀-syntax
syntax ∀₁∈-syntax {X₁ = X₁} (λ x → P) =  ∀₁ x ∈ X₁ , P
syntax ∃₁∈-syntax {X₁ = X₁} (λ x → P) =  ∃₁ x ∈ X₁ , P
syntax ∀₁-syntax (λ x → P) =  ∀₁ x , P
syntax ∃₁-syntax (λ x → P) =  ∃₁ x , P
syntax ∀₀∈-syntax {X₀ = X₀} (λ x → P) =  ∀₀ x ∈ X₀ , P
syntax ∃₀∈-syntax {X₀ = X₀} (λ x → P) =  ∃₀ x ∈ X₀ , P
syntax ∀₀-syntax (λ x → P) =  ∀₀ x , P
syntax ∃₀-syntax (λ x → P) =  ∃₀ x , P

--------------------------------------------------------------------------------
-- ∧: Conjunction
-- ∨: Disjunction

infixr 7 _∧_
infixr 6 _∨_

_∧_ _∨_ :  Prop' ι →  Prop' ι →  Prop' ι
P ∧ Q =  ∀₁˙ (binary P Q)
P ∨ Q =  ∃₁˙ (binary P Q)

--------------------------------------------------------------------------------
-- ⊤': Truth
-- ⊥': Falsehood

⊤' ⊥' :  Prop' ι
⊤' =  ∀₁˙ absurd
⊥' =  ∃₁˙ absurd

--------------------------------------------------------------------------------
-- ⌜ ⌝: Set embedding

⌜_⌝₁ :  Set₁ →  Prop' ι
⌜ X₁ ⌝₁ =  ∃₁ _ ∈ X₁ , ⊤'
⌜_⌝₀ :  Set₀ →  Prop' ι
⌜ X₀ ⌝₀ =  ∃₀ _ ∈ X₀ , ⊤'

--------------------------------------------------------------------------------
-- [∗]: Iterated separating conjunction

infix 8 [∗]_
[∗]_ :  List (Prop' ι) →  Prop' ι
[∗] [] =  ⊤'
[∗] (P ∷ Ps) =  P ∗ [∗] Ps

-- Syntax for [∗] map / mapi

infix 8 [∗∈]-syntax [∗ⁱ∈]-syntax
[∗∈]-syntax :  (A → Prop' ι) →  List A →  Prop' ι
[∗∈]-syntax P˙ as =  [∗] map P˙ as
[∗ⁱ∈]-syntax :  (ℕ × A → Prop' ι) →  List A →  Prop' ι
[∗ⁱ∈]-syntax P˙ as =  [∗] mapi (curry P˙) as
syntax [∗∈]-syntax (λ a → P) as =  [∗ a ∈ as ] P
syntax [∗ⁱ∈]-syntax (λ ia → P) as =  [∗ ia ⁱ∈ as ] P
-- Currently in Agda, we can't bind two variables in syntax like:
--   syntax [∗ⁱ∈]-syntax (λ i a → P) as =  [∗ i ⁱ a ∈ as ] P

--------------------------------------------------------------------------------
-- Extending _↦⟨_⟩_

infix 9 _↦_ _↦ˡ⟨_⟩_ _↦ˡ_

-- Full points-to token
_↦_ :  Addr →  AnyVal →  Prop' ι
θ ↦ av =  θ ↦⟨ 1ᴿ⁺ ⟩ av

-- Iterated points-to token
_↦ˡ⟨_⟩_ :  Addr →  ℚ⁺ →  List AnyVal →  Prop' ι
θ ↦ˡ⟨ p ⟩ avs =  [∗ (i , av) ⁱ∈ avs ] θ ₒ i ↦⟨ p ⟩ av
_↦ˡ_ :  Addr →  List AnyVal →  Prop' ι
θ ↦ˡ avs =  θ ↦ˡ⟨ 1ᴿ⁺ ⟩ avs

--------------------------------------------------------------------------------
-- Basic Shog proposition

-- IsBasic P: P consists only of ∀₁, ∃₁, ∗ and □
data  IsBasic :  Prop' ∞ →  Set₂  where
  ∀₁-IsBasic :  (∀ x → IsBasic (P˙ x)) →  IsBasic (∀₁˙ P˙)
  ∃₁-IsBasic :  (∀ x → IsBasic (P˙ x)) →  IsBasic (∃₁˙ P˙)
  ∗-IsBasic :  IsBasic P →  IsBasic Q →  IsBasic (P ∗ Q)
  □-IsBasic :  IsBasic P →  IsBasic (□ P)

-- Basic: Type class wrapping IsBasic
record  Basic (P : Prop' ∞) :  Set₂  where
  field  isBasic :  IsBasic P
open Basic {{...}} public

abstract

  -- For ∀₁/∃₁
  -- They are not instances, because unfortunately Agda can't search a
  -- universally quantified instance (∀ x → ...)

  ∀₁-Basic :  (∀ x → Basic (P˙ x)) →  Basic (∀₁˙ P˙)
  ∀₁-Basic ∀Basic .isBasic =  ∀₁-IsBasic $ λ x → ∀Basic x .isBasic

  ∀₀-Basic :  (∀ x → Basic (P˙ x)) →  Basic (∀₀˙ P˙)
  ∀₀-Basic ∀Basic =  ∀₁-Basic $ ∀Basic ∘ ↓_

  ∃₁-Basic :  (∀ x → Basic (P˙ x)) →  Basic (∃₁˙ P˙)
  ∃₁-Basic ∀Basic .isBasic =  ∃₁-IsBasic $ λ x → ∀Basic x .isBasic

  ∃₀-Basic :  (∀ x → Basic (P˙ x)) →  Basic (∃₀˙ P˙)
  ∃₀-Basic ∀Basic =  ∃₁-Basic $ ∀Basic ∘ ↓_

  instance

    -- For ∧/∨/⊤'/⊥'

    ∧-Basic :  {{Basic P}} →  {{Basic Q}} →  Basic (P ∧ Q)
    ∧-Basic =  ∀₁-Basic $ binary it it

    ∨-Basic :  {{Basic P}} →  {{Basic Q}} →  Basic (P ∨ Q)
    ∨-Basic =  ∃₁-Basic $ binary it it

    ⊤-Basic :  Basic ⊤'
    ⊤-Basic =  ∀₁-Basic absurd

    ⊥-Basic :  Basic ⊥'
    ⊥-Basic =  ∃₁-Basic absurd

    -- For ∗

    ∗-Basic :  {{Basic P}} →  {{Basic Q}} →  Basic (P ∗ Q)
    ∗-Basic .isBasic =  ∗-IsBasic isBasic isBasic

    -- For ⌜ ⌝

    ⌜⌝₁-Basic :  Basic ⌜ X₁ ⌝₁
    ⌜⌝₁-Basic =  ∃₁-Basic $ λ _ → ⊤-Basic

    ⌜⌝₀-Basic :  Basic ⌜ X₀ ⌝₀
    ⌜⌝₀-Basic =  ⌜⌝₁-Basic

    -- For ⌜ ⌝

    □-Basic :  {{Basic P}} →  Basic (□ P)
    □-Basic .isBasic =  □-IsBasic isBasic

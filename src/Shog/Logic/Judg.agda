--------------------------------------------------------------------------------
-- Judgment in Shog
--------------------------------------------------------------------------------

{-# OPTIONS --without-K --sized-types #-}

module Shog.Logic.Judg where

open import Base.Level using (Level; ↑_)
open import Base.Size using (Size; ∞)
open import Base.Thunk using (Thunk; !)
open import Base.Func using (_∘_; _$_)
open import Base.Few using (⊤)
open import Base.Eq using (_≡_)
open import Base.Prod using (_,_)
open import Base.Sum using (inj₀; inj₁)
open import Base.Bool using (Bool)
open import Base.Nat using (ℕ)
open import Base.List using (List; map)
open import Base.List.Nat using (rep; len)
open import Base.RatPos using (ℚ⁺)
open import Shog.Logic.Prop using (Prop'; Prop˂; ∀₁˙; ∃₁˙; ∀₁-syntax; ∃₁-syntax;
  ∃₁∈-syntax; _∧_; ⊤'; _→'_; _∗_; _-∗_; |=>_; □_; [∗]_; [∗∈]-syntax; Saveˣ;
  Save□; _↦⟨_⟩_; _↦_; _↦ˡ_; Free; Basic)
open import Shog.Lang.Expr using (Addr; Type; ◸_; Expr; Expr˂; ∇_; Val; V⇒E;
  AnyVal; ⊤-val)
open import Shog.Lang.Ktxred using (▶ᴿ_; ndᴿ; _◁ᴿ_; ★ᴿ_; _←ᴿ_; allocᴿ; freeᴿ;
  Ktx; _ᴷ◁_; _ᴷ|ᴿ_; Val/Ktxred; val/ktxred)

--------------------------------------------------------------------------------
-- WpK: Weakest precondion kind

data  WpK :  Set₀  where
  -- Partial/total
  par tot :  WpK

--------------------------------------------------------------------------------
-- JudgRes: Result of a judgment

private variable
  T U V :  Type

infix 3 |=>>_

data  JudgRes :  Set₂  where
  -- Just a proposition
  Pure :  Prop' ∞ →  JudgRes
  -- Under the super update
  |=>>_ :  Prop' ∞ →  JudgRes
  -- Weakest precondion, over Val/Ktxred
  Wp' :  WpK →  Val/Ktxred T →  (Val T → Prop' ∞) →  JudgRes

--------------------------------------------------------------------------------
-- P ⊢[ ι ]* Jr :  Judgment

infix 2 _⊢[_]*_ _⊢[_]_ _⊢[<_]_ _⊢[_]=>>_ _⊢[_]'⟨_⟩[_]_ _⊢[_]'⟨_⟩ᴾ_ _⊢[_]'⟨_⟩ᵀ_
  _⊢[_]⟨_⟩[_]_ _⊢[_]⟨_⟩ᴾ_ _⊢[<_]⟨_⟩ᴾ_ _⊢[_]⟨_⟩ᵀ_

-- Declaring _⊢[_]*_
data  _⊢[_]*_ :  Prop' ∞ →  Size →  JudgRes →  Set₂

-- ⊢[ ] : Pure sequent
_⊢[_]_ :  Prop' ∞ →  Size →  Prop' ∞ →  Set₂
P ⊢[ ι ] Q =  P ⊢[ ι ]* Pure Q

-- ⊢[< ] : Pure sequent under thunk
_⊢[<_]_ :  Prop' ∞ →  Size →  Prop' ∞ →  Set₂
P ⊢[< ι ] Q =  Thunk (P ⊢[_] Q) ι

-- ⊢[ ]=>> : Super update
_⊢[_]=>>_ :  Prop' ∞ →  Size →  Prop' ∞ →  Set₂
P ⊢[ ι ]=>> Q =  P ⊢[ ι ]* |=>> Q

-- ⊢[ ]'⟨ ⟩[ ] : Hoare-triple over Val/Ktxred

_⊢[_]'⟨_⟩[_]_ :
  Prop' ∞ →  Size →  Val/Ktxred T →  WpK →  (Val T → Prop' ∞) →  Set₂
P ⊢[ ι ]'⟨ vk ⟩[ κ ] Qᵛ =  P ⊢[ ι ]* Wp' κ vk Qᵛ

_⊢[_]'⟨_⟩ᴾ_ _⊢[_]'⟨_⟩ᵀ_ :
  Prop' ∞ →  Size →  Val/Ktxred T →  (Val T → Prop' ∞) →  Set₂
P ⊢[ ι ]'⟨ vk ⟩ᴾ Qᵛ =  P ⊢[ ι ]'⟨ vk ⟩[ par ] Qᵛ
P ⊢[ ι ]'⟨ vk ⟩ᵀ Qᵛ =  P ⊢[ ι ]'⟨ vk ⟩[ tot ] Qᵛ

-- ⊢[ ]⟨ ⟩[ ] : Hoare-triple over Expr

_⊢[_]⟨_⟩[_]_ :
  Prop' ∞ →  Size →  Expr ∞ T →  WpK →  (Val T → Prop' ∞) →  Set₂
P ⊢[ ι ]⟨ e ⟩[ κ ] Qᵛ =  P ⊢[ ι ]'⟨ val/ktxred e ⟩[ κ ] Qᵛ

_⊢[_]⟨_⟩ᴾ_ _⊢[<_]⟨_⟩ᴾ_ _⊢[_]⟨_⟩ᵀ_ :
  Prop' ∞ →  Size →  Expr ∞ T →  (Val T → Prop' ∞) →  Set₂
P ⊢[ ι ]⟨ e ⟩ᴾ Qᵛ =  P ⊢[ ι ]⟨ e ⟩[ par ] Qᵛ
P ⊢[< ι ]⟨ e ⟩ᴾ Qᵛ =  Thunk (P ⊢[_]⟨ e ⟩[ par ] Qᵛ) ι
P ⊢[ ι ]⟨ e ⟩ᵀ Qᵛ =  P ⊢[ ι ]⟨ e ⟩[ tot ] Qᵛ

private variable
  ι :  Size
  ℓ :  Level
  X :  Set ℓ
  x :  X
  Y˙ :  X → Set ℓ
  Jr :  JudgRes
  P P' Q R :  Prop' ∞
  P˙ Q˙ :  X → Prop' ∞
  P˂ Q˂ :  Prop˂ ∞
  P˂s :  List (Prop˂ ∞)
  κ :  WpK
  vk :  Val/Ktxred T
  Qᵛ Rᵛ :  Val T → Prop' ∞
  e :  Expr ∞ U
  e˂ :  Expr˂ ∞ U
  e˙ :  X → Expr ∞ U
  ktx :  Ktx T U
  v :  Val T
  θ :  Addr
  p :  ℚ⁺
  n :  ℕ
  av :  AnyVal
  avs :  List AnyVal

infixr -1 _»_ _ᵘ»ᵘ_ _ᵘ»ʰ_ _ʰ»ᵘ_

-- Defining _⊢[_]*_
data  _⊢[_]*_  where
  ------------------------------------------------------------------------------
  -- General rules

  -- The sequent is reflexive

  ⊢-refl :  P ⊢[ ι ] P

  -- The left-hand side of a judgment can be modified with a sequent

  _»_ :  P ⊢[ ι ] Q →  Q ⊢[ ι ]* Jr →  P ⊢[ ι ]* Jr

  ------------------------------------------------------------------------------
  -- On ∀ / ∃

  -- Introducing ∀ / Eliminating ∃

  ∀₁-intro :  (∀ x → P ⊢[ ι ] Q˙ x) →  P ⊢[ ι ] ∀₁˙ Q˙

  ∃₁-elim :  (∀ x → P˙ x ⊢[ ι ]* Jr) →  ∃₁˙ P˙ ⊢[ ι ]* Jr

  -- Eliminating ∀ / Introducing ∃

  ∀₁-elim :  ∀ x →  ∀₁˙ P˙ ⊢[ ι ] P˙ x

  ∃₁-intro :  ∀ x →  P˙ x ⊢[ ι ] ∃₁˙ P˙

  -- Choice, which is safe to have thanks to the logic's predicativity

  choice₁ :  ∀ {P˙˙ : ∀ (x : X) → Y˙ x → Prop' ∞} →
    ∀₁ x , ∃₁ y , P˙˙ x y ⊢[ ι ] ∃₁ y˙ ∈ (∀ x → Y˙ x) , ∀₁ x , P˙˙ x (y˙ x)

  ------------------------------------------------------------------------------
  -- On →

  -- → is the right adjoint of ∧

  →-intro :  P ∧ Q ⊢[ ι ] R →  Q ⊢[ ι ] P →' R

  →-elim :  Q ⊢[ ι ] P →' R →  P ∧ Q ⊢[ ι ] R

  ------------------------------------------------------------------------------
  -- On ∗

  -- ∗ is unital w.r.t. ⊤', commutative, associative, and monotone

  ⊤∗-elim :  ⊤' ∗ P ⊢[ ι ] P

  ⊤∗-intro :  P ⊢[ ι ] ⊤' ∗ P

  ∗-comm :  P ∗ Q ⊢[ ι ] Q ∗ P

  ∗-assocˡ :  (P ∗ Q) ∗ R ⊢[ ι ] P ∗ (Q ∗ R)

  ∗-monoˡ :  P ⊢[ ι ] Q →  P ∗ R ⊢[ ι ] Q ∗ R

  ------------------------------------------------------------------------------
  -- On -∗

  -- -∗ is the right adjoint of ∗

  -∗-intro :  P ∗ Q ⊢[ ι ] R →  Q ⊢[ ι ] P -∗ R

  -∗-elim :  Q ⊢[ ι ] P -∗ R →  P ∗ Q ⊢[ ι ] R

  ------------------------------------------------------------------------------
  -- On |=>

  -- |=> is monadic: monotone, increasing, and idempotent

  |=>-mono :  P ⊢[ ι ] Q →  |=> P ⊢[ ι ] |=> Q

  |=>-intro :  P ⊢[ ι ] |=> P

  |=>-join :  |=> |=> P ⊢[ ι ] |=> P

  -- ∗ can get inside |=>

  |=>-frameˡ :  P ∗ |=> Q ⊢[ ι ] |=> (P ∗ Q)

  -- ∃₁ _ , can get outside |=>

  |=>-∃₁-out :  |=> (∃₁ _ ∈ X , P) ⊢[ ι ] ∃₁ _ ∈ X , |=> P

  ------------------------------------------------------------------------------
  -- On □

  -- □ is comonadic: monotone, decreasing, and idempotent

  □-mono :  P ⊢[ ι ] Q →  □ P ⊢[ ι ] □ Q

  □-elim :  □ P ⊢[ ι ] P

  □-dup :  □ P ⊢[ ι ] □ □ P

  -- ∧ can turn into ∗ when one argument is under □

  □ˡ-∧⇒∗ :  □ P ∧ Q ⊢[ ι ] □ P ∗ Q

  -- ∀ can get inside □

  □-∀₁-in :  ∀₁˙ (□_ ∘ P˙) ⊢[ ι ] □ ∀₁˙ P˙

  -- ∃ can get outside □

  □-∃₁-out :  □ ∃₁˙ P˙ ⊢[ ι ] ∃₁˙ (□_ ∘ P˙)

  ------------------------------------------------------------------------------
  -- On super update

  -- Lift a sequent under |=> to a super update =>>

  |=>⇒=>> :  P ⊢[ ι ] |=> Q →  P ⊢[ ι ]=>> Q

  -- The super update =>> is transitive

  _ᵘ»ᵘ_ :  P ⊢[ ι ]=>> Q →  Q ⊢[ ι ]=>> R →  P ⊢[ ι ]=>> R

  -- The super update =>> can frame

  =>>-frameˡ :  Q ⊢[ ι ]=>> R →  P ∗ Q ⊢[ ι ]=>> P ∗ R

  ------------------------------------------------------------------------------
  -- On save token

  -- Save□ is persistent

  Save□-□ :  Save□ P˂ ⊢[ ι ] □ Save□ P˂

  -- An exclusive/persistent save token can be modified using a thunk sequent

  Saveˣ-mono-∧ :  {{Basic R}} →  R ∧ P˂ .! ⊢[< ι ] Q˂ .! →
                  R ∧ Saveˣ P˂ ⊢[ ι ] Saveˣ Q˂

  Save□-mono-∧ :  {{Basic R}} →  R ∧ P˂ .! ⊢[< ι ] Q˂ .! →
                  R ∧ Save□ P˂ ⊢[ ι ] Save□ Q˂

  -- An exclusive save token Saveˣ P˂ is obtained by allocating P˂

  Saveˣ-alloc :  P˂ .! ⊢[ ι ]=>> Saveˣ P˂

  -- Persistent save tokens Save□ P˂ (for P˂ ∈ P˂s) can be obtained
  -- by allocating □ P˂ (for P˂ ∈ P˂s) minus the save tokens themselves

  Save□-alloc-rec :  [∗] map Save□ P˂s -∗ [∗ P˂ ∈ P˂s ] □ P˂ .!
                     ⊢[ ι ]=>> [∗] map Save□ P˂s

  -- Use a exclusive/persistent save token

  Saveˣ-use :  Saveˣ P˂ ⊢[ ι ]=>> P˂ .!

  Save□-use :  Save□ P˂ ⊢[ ι ]=>> □ P˂ .!

  ------------------------------------------------------------------------------
  -- On Hoare triple

  -- Weaken a Hoare triple from total to partial

  hor-ᵀ⇒ᴾ :  ∀{Qᵛ : _} →  P ⊢[ ι ]'⟨ vk ⟩ᵀ Qᵛ →  P ⊢[ ι ]'⟨ vk ⟩ᴾ Qᵛ

  -- Compose with a super update

  _ᵘ»ʰ_ :  ∀{Rᵛ : _} →  P ⊢[ ι ]=>> Q →  Q ⊢[ ι ]'⟨ vk ⟩[ κ ] Rᵛ →
                        P ⊢[ ι ]'⟨ vk ⟩[ κ ] Rᵛ

  _ʰ»ᵘ_ :  ∀{Qᵛ : Val T → _} →
    P ⊢[ ι ]'⟨ vk ⟩[ κ ] Qᵛ → (∀ v → Qᵛ v ⊢[ ι ]=>> Rᵛ v) →
    P ⊢[ ι ]'⟨ vk ⟩[ κ ] Rᵛ

  -- Frame

  hor-frameˡ :  ∀{Qᵛ : _} →  P ⊢[ ι ]'⟨ vk ⟩[ κ ] Qᵛ →
                             R ∗ P ⊢[ ι ]'⟨ vk ⟩[ κ ] λ v → R ∗ Qᵛ v

  -- Bind by a context

  hor-bind :  ∀{Qᵛ : _} {Rᵛ : _} →
    P ⊢[ ι ]⟨ e ⟩[ κ ] Qᵛ →  (∀ v → Qᵛ v ⊢[ ι ]⟨ ktx ᴷ◁ V⇒E v ⟩[ κ ] Rᵛ) →
    P ⊢[ ι ]⟨ ktx ᴷ◁ e ⟩[ κ ] Rᵛ

  -- Value

  hor-valᵘ :  ∀{v : Val T} →  P ⊢[ ι ]=>> Qᵛ v →  P ⊢[ ι ]'⟨ inj₀ v ⟩[ κ ] Qᵛ

  -- Non-deterministic value

  hor-ndᵘ :  (∀ x → P ⊢[ ι ]=>> Qᵛ (↑ x)) →
             P ⊢[ ι ]'⟨ inj₁ $ ktx ᴷ|ᴿ ndᴿ ⟩[ κ ] Qᵛ

  -- ▶, for partial and total Hoare triples

  horᴾ-▶ :  ∀{Qᵛ : _} →  P ⊢[< ι ]⟨ ktx ᴷ◁ e˂ .! ⟩ᴾ Qᵛ →
                         P ⊢[ ι ]'⟨ inj₁ $ ktx ᴷ|ᴿ ▶ᴿ e˂ ⟩ᴾ Qᵛ

  horᵀ-▶ :  ∀{Qᵛ : _} →  P ⊢[ ι ]⟨ ktx ᴷ◁ e˂ .! ⟩ᵀ Qᵛ →
                         P ⊢[ ι ]'⟨ inj₁ $ ktx ᴷ|ᴿ ▶ᴿ e˂ ⟩ᵀ Qᵛ

  -- Application

  hor-◁ :  ∀{Qᵛ : _} →  P ⊢[ ι ]⟨ ktx ᴷ◁ e˙ x ⟩[ κ ] Qᵛ →
                        P ⊢[ ι ]'⟨ inj₁ $ ktx ᴷ|ᴿ e˙ ◁ᴿ x ⟩[ κ ] Qᵛ

  -- Memory read

  hor-★ :  ∀{Qᵛ : _} →
    θ ↦⟨ p ⟩ (V , v) ∗ P ⊢[ ι ]⟨ ktx ᴷ◁ V⇒E v ⟩[ κ ] Qᵛ →
    θ ↦⟨ p ⟩ (_ , v) ∗ P ⊢[ ι ]'⟨ inj₁ $ ktx ᴷ|ᴿ ★ᴿ θ ⟩[ κ ] Qᵛ

  -- Memory write

  hor-← :  ∀{Qᵛ : _} →
    θ ↦ (V , v) ∗ P ⊢[ ι ]⟨ ktx ᴷ◁ ∇ _ ⟩[ κ ] Qᵛ →
    θ ↦ av ∗ P ⊢[ ι ]'⟨ inj₁ $ ktx ᴷ|ᴿ θ ←ᴿ v ⟩[ κ ] Qᵛ

  -- Memory allocation

  hor-alloc :  ∀{Qᵛ : _} →
    (∀ θ →  θ ↦ˡ rep n ⊤-val ∗ Free n θ ∗ P ⊢[ ι ]⟨ ktx ᴷ◁ ∇ θ ⟩[ κ ] Qᵛ) →
    P ⊢[ ι ]'⟨ inj₁ $ ktx ᴷ|ᴿ allocᴿ n ⟩[ κ ] Qᵛ

  -- Memory freeing

  hor-free :  ∀{Qᵛ : _} →
    len avs ≡ n →  P ⊢[ ι ]⟨ ktx ᴷ◁ ∇ _ ⟩[ κ ] Qᵛ →
    θ ↦ˡ avs ∗ Free n θ ∗ P ⊢[ ι ]'⟨ inj₁ $ ktx ᴷ|ᴿ freeᴿ θ ⟩[ κ ] Qᵛ

--------------------------------------------------------------------------------
-- Pers: Persistence of a proposition

record  Pers (P : Prop' ∞) :  Set₂  where
  -- Pers-⇒□: P can turn into □ P
  field Pers-⇒□ :  P ⊢[ ι ] □ P
open Pers {{...}} public

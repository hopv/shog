--------------------------------------------------------------------------------
-- Hoare triple
--------------------------------------------------------------------------------

{-# OPTIONS --without-K --sized-types #-}

module Shog.Logic.Hor where

open import Base.Level using (↑_)
open import Base.Size using (Size; ∞)
open import Base.Func using (_$_)
open import Base.Prod using (_,_)
open import Base.Sum using (inj₀; inj₁)
open import Shog.Logic.Prop using (Prop'; _∗_)
open import Shog.Logic.Core using (_⊢[_]_; _»_; ∗-comm)
open import Shog.Logic.Supd using (_⊢[_]=>>_; ⇒=>>; =>>-refl)
open import Shog.Lang.Expr using (Type; Expr; Val; let˙)
open import Shog.Lang.Ktxred using (ndᴿ; Ktx; •ᴷ; _◁ᴷʳ_; _ᴷ|ᴿ_; Val/Ktxred)

-- Import and re-export
open import Shog.Logic.Judg public using (WpK; par; tot; Wp'; _⊢[_]'⟨_⟩[_]_;
  _⊢[_]'⟨_⟩ᴾ_; _⊢[_]'⟨_⟩ᵀ_; _⊢[_]⟨_⟩[_]_; _⊢[_]⟨_⟩ᴾ_; _⊢[<_]⟨_⟩ᴾ_; _⊢[_]⟨_⟩ᵀ_;
  hor-ᵀ⇒ᴾ; _ᵘ»ʰ_; _ʰ»ᵘ_; hor-frameˡ; hor-bind; hor-valᵘ; hor-ndᵘ; horᴾ-▶;
  horᵀ-▶; hor-◁)

private variable
  ι :  Size
  A :  Set₀
  T U :  Type
  κ :  WpK
  P P' R :  Prop' ∞
  Qᵛ Q'ᵛ Rᵛ :  Val T → Prop' ∞
  vk :  Val/Ktxred T
  ktx :  Ktx U T
  e₀ :  Expr ∞ T
  e˙ :  A → Expr ∞ T

infixr -1 _ʰ»_

abstract

  -- Compose

  _ʰ»_ :  ∀{Qᵛ : Val T → _} →
    P ⊢[ ι ]'⟨ vk ⟩[ κ ] Qᵛ →  (∀ v → Qᵛ v ⊢[ ι ] Rᵛ v) →
    P ⊢[ ι ]'⟨ vk ⟩[ κ ] Rᵛ
  P⊢⟨vk⟩Q ʰ» ∀vQ⊢R =  P⊢⟨vk⟩Q ʰ»ᵘ λ _ → ⇒=>> $ ∀vQ⊢R _

  -- Frame

  hor-frameʳ :  ∀{Qᵛ : _} →  P ⊢[ ι ]'⟨ vk ⟩[ κ ] Qᵛ →
                             P ∗ R ⊢[ ι ]'⟨ vk ⟩[ κ ] λ v → Qᵛ v ∗ R
  hor-frameʳ P⊢⟨vk⟩Q =  ∗-comm » hor-frameˡ P⊢⟨vk⟩Q ʰ» λ _ → ∗-comm

  -- Non-deterministic value

  hor-nd :  (∀ x → P ⊢[ ι ] Qᵛ (↑ x)) →  P ⊢[ ι ]'⟨ inj₁ $ ktx ᴷ|ᴿ ndᴿ ⟩[ κ ] Qᵛ
  hor-nd ∀xP⊢Q =  hor-ndᵘ $ λ _ → ⇒=>> $ ∀xP⊢Q _

  -- Let binding

  hor-let :  ∀{Rᵛ : _} →
    P ⊢[ ι ]⟨ e₀ ⟩[ κ ] Qᵛ →  (∀ x → Qᵛ (↑ x) ⊢[ ι ]⟨ e˙ x ⟩[ κ ] Rᵛ) →
    P ⊢[ ι ]⟨ let˙ e₀ e˙ ⟩[ κ ] Rᵛ
  hor-let P⊢⟨e₀⟩Q ∀xQ⊢⟨e˙⟩R =
    hor-bind {ktx = _ ◁ᴷʳ •ᴷ} P⊢⟨e₀⟩Q $ λ (↑ x) → hor-◁ $ ∀xQ⊢⟨e˙⟩R x

  -- Value

  hor-val :  ∀{v : Val T} →  P ⊢[ ι ] Qᵛ v →  P ⊢[ ι ]'⟨ inj₀ v ⟩[ κ ] Qᵛ
  hor-val P⊢Q =  hor-valᵘ $ ⇒=>> P⊢Q

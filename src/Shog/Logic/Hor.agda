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
  hor-ᵀ⇒ᴾ; hor-monoˡᵘ; hor-monoʳᵘ; hor-frameˡ; hor-bind; hor-valᵘ; hor-ndᵘ;
  horᴾ-▶; horᵀ-▶; hor-◁)

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

abstract

  -- Monotonicity

  hor-monoˡ :  ∀{Qᵛ : _} →  P' ⊢[ ι ] P →  P ⊢[ ι ]'⟨ vk ⟩[ κ ] Qᵛ →
                            P' ⊢[ ι ]'⟨ vk ⟩[ κ ] Qᵛ
  hor-monoˡ P'⊢P =  hor-monoˡᵘ $ ⇒=>> P'⊢P

  hor-monoʳ :  ∀{Qᵛ : Val T → _} →
    (∀ v → Qᵛ v ⊢[ ι ] Q'ᵛ v) →  P ⊢[ ι ]'⟨ vk ⟩[ κ ] Qᵛ →
    P ⊢[ ι ]'⟨ vk ⟩[ κ ] Q'ᵛ
  hor-monoʳ ∀vQ⊢Q' =  hor-monoʳᵘ $ λ _ → ⇒=>> $ ∀vQ⊢Q' _

  -- Frame

  hor-frameʳ :  ∀{Qᵛ : _} →  P ⊢[ ι ]'⟨ vk ⟩[ κ ] Qᵛ →
                             P ∗ R ⊢[ ι ]'⟨ vk ⟩[ κ ] λ v → Qᵛ v ∗ R
  hor-frameʳ P⊢⟨vk⟩Q =
    hor-monoʳ (λ _ → ∗-comm) $ ∗-comm » hor-frameˡ P⊢⟨vk⟩Q

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

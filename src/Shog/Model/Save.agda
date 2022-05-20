--------------------------------------------------------------------------------
-- Interpreting save tokens
--------------------------------------------------------------------------------

{-# OPTIONS --without-K --sized-types #-}

open import Base.Level using (Level)
module Shog.Model.Save (ℓ : Level) where

open import Base.Size using (∞)
open import Base.Func using (_$_)
open import Base.Nat using (ℕ)
open import Base.Level using (↓ˡ_)
open import Shog.Logic.Prop ℓ using (Prop'; _∗_; Basic)
open import Shog.Logic.Judg ℓ using (_⊢[_]_)
open import Shog.Model.RA.Glob ℓ using (Globᴿᴬ; Saveˣ; injˢˣ; injᶠˢˣ; #ˣᴾ_;
  Save□; injˢ□; injᶠˢ□; agᴾ)
open import Shog.Model.Prop Globᴿᴬ using (Propᵒ; own; ∃ᵒ-syntax; ⌜_⌝ᵒ'; _∧ᵒ'_)
open import Shog.Model.Basic ℓ using ([|_|]ᴮ)

--------------------------------------------------------------------------------
-- Interpreting exclusive save tokens

lineˢˣ :  ℕ →  Prop' ∞ →  Propᵒ
lineˢˣ i P =  own $ injˢˣ $ injᶠˢˣ i $ #ˣᴾ P

saveˣᵒ :  Prop' ∞ →  Propᵒ
saveˣᵒ P =  ∃ᵒ P' , ∃ᵒ B , ∃ᵒ BaB , ∃ᵒ i ,
  ⌜ B ∗ P ⊢[ ∞ ] P' ⌝ᵒ'  ∧ᵒ'  [| B |]ᴮ {{ BaB }}  ∧ᵒ'  lineˢˣ (↓ˡ i) P

--------------------------------------------------------------------------------
-- Interpreting persistent save tokens

lineˢ□ :  ℕ →  Prop' ∞ →  Propᵒ
lineˢ□ i P =  own $ injˢ□ $ injᶠˢ□ i $ agᴾ P

save□ᵒ :  Prop' ∞ →  Propᵒ
save□ᵒ P =  ∃ᵒ P' , ∃ᵒ B , ∃ᵒ BaB , ∃ᵒ i ,
  ⌜ B ∗ P ⊢[ ∞ ] P' ⌝ᵒ'  ∧ᵒ'  [| B |]ᴮ {{ BaB }}  ∧ᵒ'  lineˢ□ (↓ˡ i) P

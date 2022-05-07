--------------------------------------------------------------------------------
-- On ×ᴿᴬ
--------------------------------------------------------------------------------

{-# OPTIONS --without-K --safe #-}

open import Shog.Model.RA using (RA)
module Shog.Model.RA.Prod.Derived {ℓˡ ℓ≈ᴸ ℓ✓ˡ ℓʳ ℓ≈ʳ ℓ✓ʳ}
  {Raˡ : RA ℓˡ ℓ≈ᴸ ℓ✓ˡ} {Raʳ : RA ℓʳ ℓ≈ʳ ℓ✓ʳ} where

open RA Raˡ using () renaming (Carrier to A;
  _≈_ to _≈ᴸ_; ✓ to ✓ˡ; _∙_ to _∙ˡ_; ε to εˡ; ⌞_⌟ to ⌞_⌟ˡ;
  refl to reflˡ; _↝_ to _↝ˡ_; ↝-refl to ↝ˡ-refl)
open RA Raʳ using () renaming (Carrier to X;
  _≈_ to _≈ʳ_; ✓ to ✓ʳ; _∙_ to _∙ʳ_; ε to εʳ; ⌞_⌟ to ⌞_⌟ʳ;
  refl to reflʳ; _↝_ to _↝ʳ_; ↝-refl to ↝ʳ-refl)

open import Algebra.Construct.DirectProduct using ()
  renaming (commutativeMonoid to ×-CommutativeMonoid)
open import Base.Prod using (_×_; _,_)
open import Shog.Model.RA.Prod.Base Raˡ Raʳ using (_×ᴿᴬ_)
open RA _×ᴿᴬ_ using (_≈_; _↝_) renaming (Carrier to AX)

private variable
  a b : A
  x y : X

abstract

  -- Congruence on a pair

  ×-congˡ :  a ≈ᴸ b  →  (a , x) ≈ (b , x)
  ×-congˡ a≈b = a≈b , reflʳ

  ×-congʳ :  x ≈ʳ y  →  (a , x) ≈ (a , y)
  ×-congʳ x≈y = reflˡ , x≈y

  -- Injecting an element of a component RA

  ×-injˡ : A → AX
  ×-injˡ a = a , εʳ

  ×-injʳ : X → AX
  ×-injʳ x = εˡ , x

  -- Update on _×ᴿᴬ_

  ×-↝-lift :  a ↝ˡ b  →  x ↝ʳ y  →  (a , x) ↝ (b , y)
  ×-↝-lift a↝b x↝y _ (✓c∙a , ✓z∙x) = a↝b _ ✓c∙a , x↝y _ ✓z∙x

  ×-↝-liftˡ :  a ↝ˡ b  →  (a , x) ↝ (b , x)
  ×-↝-liftˡ a↝b = ×-↝-lift a↝b ↝ʳ-refl

  ×-↝-liftʳ :  x ↝ʳ y  →  (a , x) ↝ (a , y)
  ×-↝-liftʳ x↝y = ×-↝-lift ↝ˡ-refl x↝y

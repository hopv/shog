--------------------------------------------------------------------------------
-- Trivial resource algebra
--------------------------------------------------------------------------------

{-# OPTIONS --without-K --safe #-}

open import Base.Level using (Level)
module Shog.Model.RA.Top {ℓ ℓ≈ ℓ✓ : Level} where

open import Base.Few using (⊤)
open import Shog.Model.RA using (RA)

open RA using (Car; _≈_; ✓_; _∙_; ε; ⌞_⌟; refl˜; ◠˜_; _◇˜_; ∙-congˡ; ∙-unitˡ;
  ∙-comm; ∙-assocˡ; ✓-resp; ✓-rem; ✓-ε; ⌞⌟-cong; ⌞⌟-add; ⌞⌟-unitˡ; ⌞⌟-idem)

--------------------------------------------------------------------------------
-- ⊤RA : Trivial resource algebra

⊤RA :  RA ℓ ℓ≈ ℓ✓
⊤RA .Car =  ⊤
⊤RA ._≈_ _ _ =  ⊤
⊤RA .✓_ _ =  ⊤
⊤RA ._∙_ =  _
⊤RA .ε =  _
⊤RA .⌞_⌟ =  _
⊤RA .refl˜ =  _
⊤RA .◠˜_ =  _
⊤RA ._◇˜_ =  _
⊤RA .∙-congˡ =  _
⊤RA .∙-unitˡ =  _
⊤RA .∙-comm =  _
⊤RA .∙-assocˡ =  _
⊤RA .✓-resp =  _
⊤RA .✓-rem =  _
⊤RA .✓-ε =  _
⊤RA .⌞⌟-cong =  _
⊤RA .⌞⌟-add =  _
⊤RA .⌞⌟-unitˡ =  _
⊤RA .⌞⌟-idem =  _

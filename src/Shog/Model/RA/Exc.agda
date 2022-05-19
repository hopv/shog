--------------------------------------------------------------------------------
-- Exclusive resource algebra
--------------------------------------------------------------------------------

{-# OPTIONS --without-K --safe #-}

open import Base.Setoid using (Setoid)
module Shog.Model.RA.Exc {ℓ ℓ≈} (S : Setoid ℓ ℓ≈) where
open Setoid S using (_≈_; refl˜; sym˜; _»˜_) renaming (Car to A)

open import Base.Level using (Level; 0ˡ)
open import Base.Func using (id)
open import Base.Prod using (_,_)
open import Base.Few using (⊤; ⊥)
open import Shog.Model.RA using (RA)

--------------------------------------------------------------------------------
-- Exc : Excᴿᴬ's carrier

data  Exc :  Set ℓ  where
  -- Pending
  ?ˣ :  Exc
  -- Exclusively set
  #ˣ :  A →  Exc
  -- Invalid
  ↯ˣ :  Exc

private variable
  a b : A

--------------------------------------------------------------------------------
-- Internal definitions
private

  -- Equivalence
  infix 4 _≈ˣ_
  _≈ˣ_ :  Exc → Exc → Set ℓ≈
  ?ˣ ≈ˣ ?ˣ =  ⊤
  ↯ˣ ≈ˣ ↯ˣ =  ⊤
  #ˣ a ≈ˣ #ˣ b =  a ≈ b
  _ ≈ˣ _ =  ⊥

  -- Validity
  infix 3 ✓ˣ_
  ✓ˣ_ :  Exc → Set
  ✓ˣ_ ↯ˣ =  ⊥
  ✓ˣ_ _ =  ⊤

  -- Product
  infixl 7 _∙ˣ_
  _∙ˣ_ :  Exc → Exc → Exc
  ?ˣ ∙ˣ x =  x
  ↯ˣ ∙ˣ x =  ↯ˣ
  x ∙ˣ ?ˣ =  x
  _ ∙ˣ _ =  ↯ˣ

-- Lemmas
private abstract

  ≈ˣ-refl :  ∀ x →  x ≈ˣ x
  ≈ˣ-refl ?ˣ =  _
  ≈ˣ-refl ↯ˣ =  _
  ≈ˣ-refl (#ˣ _) =  refl˜

  ≈ˣ-sym :  ∀ x y →  x ≈ˣ y →  y ≈ˣ x
  ≈ˣ-sym ?ˣ ?ˣ =  _
  ≈ˣ-sym ↯ˣ ↯ˣ =  _
  ≈ˣ-sym (#ˣ _) (#ˣ _) =  sym˜

  ≈ˣ-trans :  ∀ x y z →  x ≈ˣ y →  y ≈ˣ z →  x ≈ˣ z
  ≈ˣ-trans ?ˣ ?ˣ ?ˣ =  _
  ≈ˣ-trans ↯ˣ ↯ˣ ↯ˣ =  _
  ≈ˣ-trans (#ˣ _) (#ˣ _) (#ˣ _) =  _»˜_

  ∙ˣ-congˡ :  ∀ x y z →  x ≈ˣ y →  x ∙ˣ z  ≈ˣ  y ∙ˣ z
  ∙ˣ-congˡ ?ˣ ?ˣ z _ =  ≈ˣ-refl z
  ∙ˣ-congˡ ↯ˣ ↯ˣ _ _ =  _
  ∙ˣ-congˡ (#ˣ a) (#ˣ b) ?ˣ a≈b =  a≈b
  ∙ˣ-congˡ (#ˣ _) (#ˣ _) ↯ˣ _ =  _
  ∙ˣ-congˡ (#ˣ _) (#ˣ _) (#ˣ _) _ =  _

  ∙ˣ-comm :  ∀ x y →  x ∙ˣ y  ≈ˣ  y ∙ˣ x
  ∙ˣ-comm ?ˣ ?ˣ =  _
  ∙ˣ-comm ?ˣ ↯ˣ =  _
  ∙ˣ-comm ?ˣ (#ˣ _) =  refl˜
  ∙ˣ-comm ↯ˣ ?ˣ =  _
  ∙ˣ-comm ↯ˣ ↯ˣ =  _
  ∙ˣ-comm ↯ˣ (#ˣ _) =  _
  ∙ˣ-comm (#ˣ _) ?ˣ =  refl˜
  ∙ˣ-comm (#ˣ _) ↯ˣ =  _
  ∙ˣ-comm (#ˣ _) (#ˣ _) =  _

  ∙ˣ-assocˡ :  ∀ x y z →  (x ∙ˣ y) ∙ˣ z  ≈ˣ  x ∙ˣ (y ∙ˣ z)
  ∙ˣ-assocˡ ?ˣ x y =  ≈ˣ-refl (x ∙ˣ y)
  ∙ˣ-assocˡ ↯ˣ _ _ =  _
  ∙ˣ-assocˡ (#ˣ a) ?ˣ y =  ≈ˣ-refl (#ˣ a ∙ˣ y)
  ∙ˣ-assocˡ (#ˣ _) ↯ˣ y =  _
  ∙ˣ-assocˡ (#ˣ _) (#ˣ _) ?ˣ =  _
  ∙ˣ-assocˡ (#ˣ _) (#ˣ _) ↯ˣ =  _
  ∙ˣ-assocˡ (#ˣ _) (#ˣ _) (#ˣ _) =  _

  ✓ˣ-resp :  ∀ x y →  x ≈ˣ y →  ✓ˣ x →  ✓ˣ y
  ✓ˣ-resp ?ˣ ?ˣ _ _ =  _
  ✓ˣ-resp (#ˣ _) (#ˣ _) _ _ =  _

  ✓ˣ-rem :  ∀ x y →  ✓ˣ x ∙ˣ y →  ✓ˣ y
  ✓ˣ-rem ?ˣ _ =  id
  ✓ˣ-rem (#ˣ _) ?ˣ =  _

--------------------------------------------------------------------------------
-- Excᴿᴬ : Exclusive resource algebra

module _ where
  open RA

  Excᴿᴬ : RA ℓ ℓ≈ 0ˡ
  Excᴿᴬ .Car =  Exc
  Excᴿᴬ ._≈_ =  _≈ˣ_
  Excᴿᴬ .✓_ =  ✓ˣ_
  Excᴿᴬ ._∙_ =  _∙ˣ_
  Excᴿᴬ .ε =  ?ˣ
  Excᴿᴬ .⌞_⌟ _ =  ?ˣ
  Excᴿᴬ .refl˜ {x} =  ≈ˣ-refl x
  Excᴿᴬ .sym˜ {x} =  ≈ˣ-sym x _
  Excᴿᴬ ._»˜_ {x} =  ≈ˣ-trans x _ _
  Excᴿᴬ .∙-congˡ {x} =  ∙ˣ-congˡ x _ _
  Excᴿᴬ .∙-unitˡ {x} =  ≈ˣ-refl x
  Excᴿᴬ .∙-comm {x} =  ∙ˣ-comm x _
  Excᴿᴬ .∙-assocˡ {x} =  ∙ˣ-assocˡ x _ _
  Excᴿᴬ .✓-resp =  ✓ˣ-resp _ _
  Excᴿᴬ .✓-rem {x} {y} =  ✓ˣ-rem x y
  Excᴿᴬ .✓-ε =  _
  Excᴿᴬ .⌞⌟-cong =  _
  Excᴿᴬ .⌞⌟-add =  ?ˣ , _
  Excᴿᴬ .⌞⌟-unitˡ {x} =  ≈ˣ-refl x
  Excᴿᴬ .⌞⌟-idem =  _

open RA Excᴿᴬ using (_↝_)

--------------------------------------------------------------------------------
-- Lemmas

abstract

  -- Update on #ˣ

  #ˣ-↝ :  #ˣ a  ↝  #ˣ b
  #ˣ-↝ ?ˣ =  _
  -- The frame z can only be ?ˣ; otherwise ✓ z ∙ #ˣ a does not hold
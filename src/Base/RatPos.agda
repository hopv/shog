--------------------------------------------------------------------------------
-- Positive rational number
--------------------------------------------------------------------------------

{-# OPTIONS --without-K --safe #-}

module Base.RatPos where

open import Base.NatPos using (ℕ⁺; 1⁺; 2⁺; _≤⁺_; cmp⁺; _≡⁺ᵇ_; _≤⁺ᵇ_; _+⁺_; _*⁺_;
  ≤⁺-refl; ≡⇒¬<⁺; <⁺-trans; <⁺-≤⁺-trans; <⁺⇒≤⁺; ≤⁺⇒¬>⁺; ⁺ᵇ⇒≡; ≡⇒⁺ᵇ; ᵇ⇒≤⁺; ≤⁺⇒ᵇ;
  +⁺-comm; +⁺-assocˡ; +⁺-assocʳ; +⁺-sincrˡ; *⁺-comm; *⁺-assocˡ; *⁺-assocʳ;
  *⁺-+⁺-distrʳ; *⁺-actˡ-comm; *⁺-actʳ-comm; *⁺-injʳ; *⁺-smonoʳ; *⁺-smonoˡ;
  *⁺-monoʳ)
open import Base.Eq using (_≡_; refl; ◠_; _◇_; cong; cong₂; subst; subst₂)
open import Base.Func using (_$_; flip)
open import Base.Bool using (Bool; Tt)
open import Base.Few using (¬_; absurd)
open import Base.Sum using (_⊎_; inj₀; inj₁₀; inj₁₁)

--------------------------------------------------------------------------------
-- ℚ⁺: Positive rational number

infix 7 _//⁺_
record  ℚ⁺ : Set where
  constructor _//⁺_
  field
    denom⁺ numer⁺ : ℕ⁺ --  denominator and numerator

-- We use the superscript ᴿ for rational numbers
-- (superscipt Q is not widely supported)

private variable
  p q r s :  ℚ⁺

--------------------------------------------------------------------------------
-- 1ᴿ⁺, ½ᴿ⁺: Numbers in ℚ⁺

1ᴿ⁺ ½⁺ :  ℚ⁺
1ᴿ⁺ =  1⁺ //⁺ 1⁺
½⁺ =  1⁺ //⁺ 2⁺

--------------------------------------------------------------------------------
-- ≈ᴿ⁺: Equivalence over ℚ⁺

infix 4 _≈ᴿ⁺_
_≈ᴿ⁺_ : ℚ⁺ → ℚ⁺ → Set₀
(a //⁺ b) ≈ᴿ⁺ (c //⁺ d) =  d *⁺ a ≡ b *⁺ c

abstract

  -- ≈ᴿ⁺ is reflexive

  ≈ᴿ⁺-refl :  p ≈ᴿ⁺ p
  ≈ᴿ⁺-refl {a //⁺ b} =  refl

  ≡⇒≈ᴿ⁺ :  p ≡ q →  p ≈ᴿ⁺ q
  ≡⇒≈ᴿ⁺ {p} refl =  ≈ᴿ⁺-refl {p}

  -- ≈ᴿ⁺ is symmetric

  ≈ᴿ⁺-sym :  p ≈ᴿ⁺ q →  q ≈ᴿ⁺ p
  ≈ᴿ⁺-sym {a //⁺ b} {c //⁺ d} =  ◠_

  -- ≈ᴿ⁺ is transitive

  ≈ᴿ⁺-trans :  p ≈ᴿ⁺ q →  q ≈ᴿ⁺ r →  p ≈ᴿ⁺ r
  ≈ᴿ⁺-trans {a //⁺ b} {c //⁺ d} {e //⁺ f} da≡bc fc≡de =  *⁺-injʳ {d} eq
   where
    eq :  d *⁺ (f *⁺ a) ≡ d *⁺ (b *⁺ e)
    eq =  cong (d *⁺_) (*⁺-comm {f} {a}) ◇ *⁺-assocʳ {d} {a} {f} ◇
      cong (_*⁺ f) da≡bc ◇ *⁺-assocˡ {b} {c} {f} ◇
      cong (b *⁺_) (*⁺-comm {c} {f} ◇ fc≡de) ◇ *⁺-actˡ-comm {b} {d} {e}

--------------------------------------------------------------------------------
-- ≈ᴿ⁺ᵇ: Boolean equivalence over ℚ⁺

infix 4 _≈ᴿ⁺ᵇ_
_≈ᴿ⁺ᵇ_ : ℚ⁺ → ℚ⁺ → Bool
(a //⁺ b) ≈ᴿ⁺ᵇ (c //⁺ d) =  d *⁺ a ≡⁺ᵇ b *⁺ c

abstract

  -- Conversion between ≈ᴿ⁺ᵇ and ≈ᴿ⁺

  ᵇ⇒≈ᴿ⁺ :  Tt (p ≈ᴿ⁺ᵇ q) →  p ≈ᴿ⁺ q
  ᵇ⇒≈ᴿ⁺ *≡⁺ᵇ* =  ⁺ᵇ⇒≡ *≡⁺ᵇ*

  ≈ᴿ⁺⇒ᵇ :  p ≈ᴿ⁺ q →  Tt (p ≈ᴿ⁺ᵇ q)
  ≈ᴿ⁺⇒ᵇ *≡⁺* =  ≡⇒⁺ᵇ *≡⁺*

--------------------------------------------------------------------------------
-- +ᴿ⁺: Addition over ℚ⁺

infixl 6 _+ᴿ⁺_
_+ᴿ⁺_ :  ℚ⁺ → ℚ⁺ → ℚ⁺
(a //⁺ b) +ᴿ⁺ (c //⁺ d) =  (d *⁺ a +⁺ b *⁺ c) //⁺ (b *⁺ d)
-- Unnormalized

abstract

  -- +ᴿ⁺ is commutative

  +ᴿ⁺-comm :  p +ᴿ⁺ q ≡ q +ᴿ⁺ p
  +ᴿ⁺-comm {a //⁺ b} {c //⁺ d} =  cong₂ _//⁺_ +⁺-comm (*⁺-comm {b} {d})

  -- +ᴿ⁺ is associative

  +ᴿ⁺-assocˡ :  (p +ᴿ⁺ q) +ᴿ⁺ r ≡ p +ᴿ⁺ (q +ᴿ⁺ r)
  +ᴿ⁺-assocˡ {a //⁺ b} {c //⁺ d} {e //⁺ f} =
    cong₂ _//⁺_ eq (*⁺-assocˡ {b} {d} {f})
   where
    eq :  f *⁺ (d *⁺ a +⁺ b *⁺ c) +⁺ (b *⁺ d) *⁺ e ≡
          (d *⁺ f) *⁺ a +⁺ b *⁺ (f *⁺ c +⁺ d *⁺ e)
    eq =
      flip (cong₂ _+⁺_) (*⁺-assocˡ {b} {d} {e})
        (*⁺-+⁺-distrʳ {f} {d *⁺ a} {b *⁺ c} ◇ cong₂ _+⁺_
          (*⁺-actˡ-comm {f} {d} {a} ◇ *⁺-assocʳ {d} {f} {a})
          (*⁺-actˡ-comm {f} {b} {c})) ◇
      +⁺-assocˡ ◇ cong (d *⁺ f *⁺ a +⁺_) $ ◠ *⁺-+⁺-distrʳ {b}

  +ᴿ⁺-assocʳ :  p +ᴿ⁺ (q +ᴿ⁺ r) ≡ (p +ᴿ⁺ q) +ᴿ⁺ r
  +ᴿ⁺-assocʳ {p} {q} {r} =  ◠ +ᴿ⁺-assocˡ {p} {q} {r}

  -- +ᴿ⁺ is congruent

  +ᴿ⁺-congˡ :  p ≈ᴿ⁺ q →  p +ᴿ⁺ r ≈ᴿ⁺ q +ᴿ⁺ r
  +ᴿ⁺-congˡ {a //⁺ b} {c //⁺ d} {e //⁺ f} da≡bc =
    *⁺-actʳ-comm {d} {f} ◇ cong (_*⁺ f) eq ◇ *⁺-actʳ-comm {b} {_} {f}
    -- (d *⁺ f) *⁺ (f *⁺ a +⁺ b *⁺ e) ≡ (b *⁺ f) *⁺ (f *⁺ c +⁺ d *⁺ e)
   where
    eq :  d *⁺ (f *⁺ a +⁺ b *⁺ e) ≡ b *⁺ (f *⁺ c +⁺ d *⁺ e)
    eq =  *⁺-+⁺-distrʳ {d} ◇
      flip (cong₂ _+⁺_) (*⁺-actˡ-comm {d} {b})
        (*⁺-actˡ-comm {d} {f} ◇ cong (f *⁺_) da≡bc ◇ *⁺-actˡ-comm {f} {b}) ◇
      ◠ *⁺-+⁺-distrʳ {b}

  +ᴿ⁺-congʳ :  ∀ {p q r} →  q ≈ᴿ⁺ r →  p +ᴿ⁺ q ≈ᴿ⁺ p +ᴿ⁺ r
  +ᴿ⁺-congʳ {p} {q} {r} q≈r =  subst₂ _≈ᴿ⁺_
    (+ᴿ⁺-comm {q} {p}) (+ᴿ⁺-comm {r} {p}) (+ᴿ⁺-congˡ {q} {r} {p} q≈r)

  +ᴿ⁺-cong :  p ≈ᴿ⁺ q →  r ≈ᴿ⁺ s →  p +ᴿ⁺ r ≈ᴿ⁺ q +ᴿ⁺ s
  +ᴿ⁺-cong {p} {q} {r} {s} p≈q r≈s =  ≈ᴿ⁺-trans {p +ᴿ⁺ r} {q +ᴿ⁺ r} {q +ᴿ⁺ s}
    (+ᴿ⁺-congˡ {p} {q} {r} p≈q) (+ᴿ⁺-congʳ {q} {r} {s} r≈s)

--------------------------------------------------------------------------------
-- /⁺: Dividing ℚ⁺ with ℕ⁺

infixl 7 _/⁺_
_/⁺_ :  ℚ⁺ → ℕ⁺ → ℚ⁺
(a //⁺ b) /⁺ c =  a //⁺ (c *⁺ b)

--------------------------------------------------------------------------------
-- ≤1ᴿ⁺: No more than 1ᴿ⁺

infix 4 _≤1ᴿ⁺
_≤1ᴿ⁺ :  ℚ⁺ → Set₀
a //⁺ b ≤1ᴿ⁺ =  a ≤⁺ b

abstract

  -- 1ᴿ⁺ satisfies ≤1ᴿ⁺
  1≤1ᴿ⁺ :  1ᴿ⁺ ≤1ᴿ⁺
  1≤1ᴿ⁺ =  ≤⁺-refl

  -- ≤1ᴿ⁺ holds after removing an addend

  ≤1ᴿ⁺-rem :  p +ᴿ⁺ q ≤1ᴿ⁺ →  q ≤1ᴿ⁺
  ≤1ᴿ⁺-rem {a //⁺ b} {c //⁺ d} da+bc≤bd  with cmp⁺ c d
  ... | inj₀ c<d =  <⁺⇒≤⁺ c<d
  ... | inj₁₀ refl =  ≤⁺-refl
  ... | inj₁₁ c>d =  absurd $ ≤⁺⇒¬>⁺ da+bc≤bd $
    <⁺-trans (*⁺-smonoʳ {b} c>d) +⁺-sincrˡ

  -- p +ᴿ⁺ 1ᴿ⁺ does not satisfy ≤1ᴿ⁺

  ?+1-not-≤1ᴿ⁺ :  ¬ p +ᴿ⁺ 1ᴿ⁺ ≤1ᴿ⁺
  ?+1-not-≤1ᴿ⁺ {a //⁺ b} 1a+b1≤b1 =  ≤⁺⇒¬>⁺ 1a+b1≤b1 +⁺-sincrˡ

  -- ≤1ᴿ⁺ respects ≈ᴿ⁺

  ≤1ᴿ⁺-resp :  p ≈ᴿ⁺ q →  p ≤1ᴿ⁺ →  q ≤1ᴿ⁺
  ≤1ᴿ⁺-resp {a //⁺ b} {c //⁺ d} da≡bc a≤b  with cmp⁺ c d
  ... | inj₀ c<d =  <⁺⇒≤⁺ c<d
  ... | inj₁₀ refl =  ≤⁺-refl
  ... | inj₁₁ c>d =  absurd $ ≡⇒¬<⁺ (da≡bc ◇ *⁺-comm {b} {c}) $
    <⁺-≤⁺-trans (*⁺-smonoˡ c>d) (*⁺-monoʳ {c} a≤b)

--------------------------------------------------------------------------------
-- ≤1ᴿ⁺ᵇ: Boolean version of ≤1ᴿ⁺

infix 4 _≤1ᴿ⁺ᵇ
_≤1ᴿ⁺ᵇ :  ℚ⁺ → Bool
a //⁺ b ≤1ᴿ⁺ᵇ =  a ≤⁺ᵇ b

abstract

  ᵇ⇒≤1ᴿ⁺ :  Tt (p ≤1ᴿ⁺ᵇ) →  p ≤1ᴿ⁺
  ᵇ⇒≤1ᴿ⁺ =  ᵇ⇒≤⁺

  ≤1ᴿ⁺⇒ᵇ :  p ≤1ᴿ⁺ →  Tt (p ≤1ᴿ⁺ᵇ)
  ≤1ᴿ⁺⇒ᵇ =  ≤⁺⇒ᵇ

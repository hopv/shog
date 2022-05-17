--------------------------------------------------------------------------------
-- Positive natural number
--------------------------------------------------------------------------------

{-# OPTIONS --without-K --safe #-}

module Base.NatPos where

open import Base.Nat using (ℕ; suc; _+_; _*_; _≡ᵇ_; +-comm; +-assocˡ; +-injˡ;
  *-comm; *-assocˡ; *-injˡ; *-+-distrˡ; ≡ᵇ⇒≡; ≡⇒≡ᵇ)
open import Base.Eq using (_≡_; refl⁼; sym⁼; _»⁼_; cong⁼; cong⁼₂)
open import Base.Func using (_$_)
open import Base.Bool using (Bool; Tt)

--------------------------------------------------------------------------------
-- ℕ⁺: Positive natural number

record  ℕ⁺ :  Set  where
  constructor 1+
  field  un1+ :  ℕ

private variable
  l m n :  ℕ⁺

--------------------------------------------------------------------------------
-- ℕ⁺⇒ℕ: Back to ℕ

ℕ⁺⇒ℕ :  ℕ⁺ →  ℕ
ℕ⁺⇒ℕ (1+ n⁰) =  suc n⁰

abstract

  -- ℕ⁺⇒ℕ is injective

  ℕ⁺⇒ℕ-inj :  ℕ⁺⇒ℕ m ≡ ℕ⁺⇒ℕ n →  m ≡ n
  ℕ⁺⇒ℕ-inj refl⁼ =  refl⁼

--------------------------------------------------------------------------------
-- +⁺: Addition

infixl 6 _+⁺_
_+⁺_ :  ℕ⁺ → ℕ⁺ → ℕ⁺
1+ m⁰ +⁺ 1+ n⁰ =  1+ $ m⁰ + (suc n⁰)
-- Defined so because "suc m⁰ + suc n⁰" reduces to "suc (m⁰ + (suc n⁰))"

abstract

  -- +⁺ is commutative

  +⁺-comm :  m +⁺ n ≡ n +⁺ m
  +⁺-comm {1+ m⁰} =  ℕ⁺⇒ℕ-inj $ +-comm {suc m⁰}

  -- +⁺ is associative

  +⁺-assocˡ :  (l +⁺ m) +⁺ n ≡ l +⁺ (m +⁺ n)
  +⁺-assocˡ {1+ l⁰} =  ℕ⁺⇒ℕ-inj $ +-assocˡ {suc l⁰}

  +⁺-assocʳ :  l +⁺ (m +⁺ n) ≡ (l +⁺ m) +⁺ n
  +⁺-assocʳ =  sym⁼ +⁺-assocˡ

  -- +⁺ is injective

  +⁺-injˡ :  ∀ {l m n} →  m +⁺ l ≡ n +⁺ l →  m ≡ n
  +⁺-injˡ {1+ l⁰} m+l≡n+l =  ℕ⁺⇒ℕ-inj $ +-injˡ $ cong⁼ ℕ⁺⇒ℕ m+l≡n+l

  +⁺-injʳ :  l +⁺ m ≡ l +⁺ n →  m ≡ n
  +⁺-injʳ {l} {m} {n} rewrite +⁺-comm {l} {m} | +⁺-comm {l} {n} =  +⁺-injˡ

--------------------------------------------------------------------------------
-- *⁺: Multiplication

infixl 7 _*⁺_
_*⁺_ :  ℕ⁺ → ℕ⁺ → ℕ⁺
1+ m⁰ *⁺ 1+ n⁰ =  1+ $ n⁰ + m⁰ * (suc n⁰)
-- Defined so because "suc m⁰ * suc n⁰" reduces to "suc (n⁰ + m⁰ * (suc n⁰))"

abstract

  -- *⁺ is commutative

  *⁺-comm :  m *⁺ n ≡ n *⁺ m
  *⁺-comm {1+ m⁰} =  ℕ⁺⇒ℕ-inj $ *-comm {suc m⁰}

  -- *⁺ is associative

  *⁺-assocˡ :  (l *⁺ m) *⁺ n ≡ l *⁺ (m *⁺ n)
  *⁺-assocˡ {1+ l⁰} {1+ m⁰} =  ℕ⁺⇒ℕ-inj $ *-assocˡ {suc l⁰} {suc m⁰}

  *⁺-assocʳ :  l *⁺ (m *⁺ n) ≡ (l *⁺ m) *⁺ n
  *⁺-assocʳ {l} {m} =  sym⁼ $ *⁺-assocˡ {l} {m}

  -- Commutativity over left/right actions

  *⁺-actˡ-comm :  l *⁺ (m *⁺ n) ≡ m *⁺ (l *⁺ n)
  *⁺-actˡ-comm {l} {m} {n} =  *⁺-assocʳ {l} {m} {n} »⁼
      cong⁼ (_*⁺ n) (*⁺-comm {l} {m}) »⁼ *⁺-assocˡ {m} {l} {n}

  *⁺-actʳ-comm :  (l *⁺ m) *⁺ n ≡ (l *⁺ n) *⁺ m
  *⁺-actʳ-comm {l} {m} {n} =  *⁺-assocˡ {l} {m} {n} »⁼
      cong⁼ (l *⁺_) (*⁺-comm {m} {n}) »⁼ *⁺-assocʳ {l} {n} {m}

  -- *⁺ is injective

  *⁺-injˡ :  ∀ {l m n} →  m *⁺ l ≡ n *⁺ l →  m ≡ n
  *⁺-injˡ {1+ l⁰} m*l≡n*l =  ℕ⁺⇒ℕ-inj $ *-injˡ $ cong⁼ ℕ⁺⇒ℕ m*l≡n*l

  *⁺-injʳ :  l *⁺ m ≡ l *⁺ n →  m ≡ n
  *⁺-injʳ {l} {m} {n} rewrite *⁺-comm {l} {m} | *⁺-comm {l} {n} =  *⁺-injˡ

  -- *⁺ is distributive over +⁺

  *⁺-+⁺-distrˡ :  (l +⁺ m) *⁺ n ≡ l *⁺ n +⁺ m *⁺ n
  *⁺-+⁺-distrˡ {1+ l⁰} =  ℕ⁺⇒ℕ-inj $ *-+-distrˡ {suc l⁰}

  *⁺-+⁺-distrʳ :  l *⁺ (m +⁺ n) ≡ l *⁺ m +⁺ l *⁺ n
  *⁺-+⁺-distrʳ {l} {m} {n} =  *⁺-comm {l} »⁼ *⁺-+⁺-distrˡ {m} »⁼
    cong⁼₂ _+⁺_ (*⁺-comm {m}) (*⁺-comm {n})

--------------------------------------------------------------------------------
-- Boolean equality

infix 4 _≡⁺ᵇ_
_≡⁺ᵇ_ :  ℕ⁺ → ℕ⁺ → Bool
1+ m⁰ ≡⁺ᵇ 1+ n⁰ =  m⁰ ≡ᵇ n⁰

abstract

  -- Convertion between ≡ᵇ and ≡

  ≡⁺ᵇ⇒≡ :  Tt (m ≡⁺ᵇ n) →  m ≡ n
  ≡⁺ᵇ⇒≡ {1+ m⁰} {1+ n⁰} m⁰≡ᵇn⁰ =  cong⁼ 1+ (≡ᵇ⇒≡ m⁰≡ᵇn⁰)

  ≡⇒≡⁺ᵇ :  m ≡ n →  Tt (m ≡⁺ᵇ n)
  ≡⇒≡⁺ᵇ {1+ m⁰} {1+ n⁰} refl⁼ =  ≡⇒≡ᵇ {m⁰} {n⁰} refl⁼

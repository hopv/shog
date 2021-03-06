--------------------------------------------------------------------------------
-- Level for universe levels
--------------------------------------------------------------------------------

{-# OPTIONS --without-K --safe #-}

module Base.Level where

open import Agda.Primitive public using (
  -- Level, in Set₀
  Level) renaming (
  -- Zero level, in Level
  lzero to 0ᴸ;
  -- Successor level, in Level → Level
  lsuc to sucᴸ;
  -- Maximum level, in Level → Level → Level
  _⊔_ to _⊔ᴸ_)

-- Shorthand for Level

1ᴸ 2ᴸ 3ᴸ :  Level
1ᴸ =  sucᴸ 0ᴸ
2ᴸ =  sucᴸ 1ᴸ
3ᴸ =  sucᴸ 2ᴸ

-- Up : Wrapper raising the level

infix 8 ↑_
record  Up {ℓ : Level} (A : Set ℓ) {ℓ' : Level} :  Set (ℓ ⊔ᴸ ℓ')  where
  -- ↑/↓ : Wrap into / unwrap from Up
  constructor ↑_
  infix 8 ↓_
  field  ↓_ :  A
open Up public

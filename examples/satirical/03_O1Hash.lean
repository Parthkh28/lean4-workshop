-- O(1) Hash: The Simplest Hash Function Ever Proven
-- Satirical proof demonstrating weak hash specifications
--
-- "A good hash function is deterministic. We're VERY deterministic!"

namespace O1Hash

-- The algorithm: hash is just the length!
-- This is O(1) for arrays (O(n) for lists, but let's ignore that...)
def hash : List α → Nat := List.length

-- Alternative: constant hash (even "faster")
def constantHash : List α → Nat := fun _ => 42

-- Weak specification: "same input gives same output"
-- WARNING: This is necessary but NOT sufficient for a good hash!
def isDeterministic {α : Type} (f : α → β) : Prop :=
  ∀ x, f x = f x

-- PROOF 1: Hash is deterministic
theorem hash_deterministic {α : Type} (xs : List α) :
    hash xs = hash xs := rfl

-- PROOF 2: Constant hash is also deterministic!
theorem constant_hash_deterministic {α : Type} (xs : List α) :
    constantHash xs = constantHash xs := rfl

-- PROOF 3: Hash of empty list is 0
theorem hash_empty {α : Type} : hash ([] : List α) = 0 := rfl

-- PROOF 4: Hash is non-negative (trivially true for Nat)
theorem hash_nonneg {α : Type} (xs : List α) : hash xs ≥ 0 := Nat.zero_le _

-- What's catastrophically wrong?
-- hash [1,2,3] = 3
-- hash [4,5,6] = 3
-- hash ["a","b","c"] = 3
-- All collide! Our "hash" only distinguishes by length!

-- constantHash is even worse:
-- constantHash [anything] = 42
-- Every input collides with every other input!

-- The lesson: A hash specification should verify:
-- 1. Determinism (we have this)
-- 2. Uniform distribution (we don't)
-- 3. Avalanche effect (we definitely don't)
-- 4. Collision resistance (we REALLY don't)

-- Bonus: Both functions DO satisfy "determinism" perfectly.
-- This proves determinism alone is meaningless for hash quality.

end O1Hash

-- O(1) Sort: The Fastest Algorithm Ever Proven
-- Satirical proof demonstrating importance of correct specifications
--
-- "Formal verification proves your code matches your spec.
--  It doesn't prove your spec is what you actually wanted."

namespace O1Sort

-- The algorithm: just the identity function!
-- In Lean 4, `id` is the built-in identity function: id x = x
-- We define sort as id to make the satire explicit
def sort {α : Type} : List α → List α := id

-- Alternative definitions (all equivalent):
-- def sort := @id (List α)           -- explicit id
-- def sort := fun x => x             -- lambda form
-- def sort := Function.id            -- qualified name

-- Helper: sum function
def sum : List Nat → Nat
  | [] => 0
  | x :: xs => x + sum xs

-- Helper: permutation check
-- WARNING: This is INTENTIONALLY WRONG! It only checks length equality,
-- not actual permutation. This is the crux of the satire - we "prove"
-- properties that don't actually ensure sorting because our spec is weak.
def isPermutation {α : Type} [BEq α] : List α → List α → Bool
  | xs, ys => xs.length == ys.length

-- PROOF 1: Idempotence
theorem sort_idempotent {α : Type} (xs : List α) :
  sort (sort (sort xs)) = sort xs := rfl

-- PROOF 2: Sum preservation
theorem sort_sum (xs : List Nat) :
  sum (sort xs) = sum xs := rfl

-- PROOF 3: Permutation
theorem sort_is_permutation {α : Type} [BEq α] (xs : List α) :
  isPermutation xs (sort xs) = true := by
  simp [sort, isPermutation]

-- COMBINED: All in-scope properties
theorem identity_is_good_sort {α : Type} [BEq α] (xs : List α) (xsNat : List Nat) :
  (sort (sort (sort xs)) = sort xs) ∧
  (sum (sort xsNat) = sum xsNat) ∧
  (isPermutation xs (sort xs) = true) := by
  constructor
  · exact sort_idempotent xs
  constructor
  · exact sort_sum xsNat
  · exact sort_is_permutation xs

end O1Sort

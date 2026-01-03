-- O(1) Sort: The Fastest Algorithm Ever Proven
-- Satirical proof demonstrating importance of correct specifications

namespace O1Sort

-- The algorithm
def sort {α : Type} : List α → List α := fun x => x

-- Helper: sum function
def sum : List Nat → Nat
  | [] => 0
  | x :: xs => x + sum xs

-- Helper: permutation check (simplified)
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

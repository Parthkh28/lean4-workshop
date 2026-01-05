-- Correct Sort Specification: What We Actually Need
-- Contrast with the satirical O1Sort example
--
-- "A correct spec is worth a thousand proofs of the wrong thing."

namespace CorrectSort

-- A CORRECT sort specification requires TWO properties:
-- 1. Output is SORTED (elements in non-decreasing order)
-- 2. Output is a PERMUTATION of input (same elements, possibly reordered)

-- Property 1: Sorted (each element ≤ next element)
def isSorted : List Nat → Bool
  | [] => true
  | [_] => true
  | x :: y :: xs => x ≤ y && isSorted (y :: xs)

-- Property 2: True permutation (same elements with same multiplicities)
-- Count occurrences of each element
def count (n : Nat) : List Nat → Nat
  | [] => 0
  | x :: xs => (if x == n then 1 else 0) + count n xs

-- Two lists are permutations if every element has same count in both
def isPermutation (xs ys : List Nat) : Prop :=
  ∀ n, count n xs = count n ys

-- A CORRECT sort must satisfy BOTH properties
def isCorrectSort (sort : List Nat → List Nat) : Prop :=
  ∀ xs, isSorted (sort xs) = true ∧ isPermutation xs (sort xs)

-- Simple insertion sort (actually sorts!)
def insert (x : Nat) : List Nat → List Nat
  | [] => [x]
  | y :: ys => if x ≤ y then x :: y :: ys else y :: insert x ys

def insertionSort : List Nat → List Nat
  | [] => []
  | x :: xs => insert x (insertionSort xs)

-- Now let's verify insertion sort is correct

-- Helper: insert preserves count
theorem insert_count (x n : Nat) (xs : List Nat) :
    count n (insert x xs) = (if x == n then 1 else 0) + count n xs := by
  induction xs with
  | nil => simp [insert, count]
  | cons y ys ih =>
    simp only [insert, count]
    split <;> simp [count, ih] <;> omega

-- Proof that insertionSort produces a permutation
theorem insertionSort_permutation (xs : List Nat) :
    isPermutation xs (insertionSort xs) := by
  induction xs with
  | nil => intro n; simp [insertionSort, count]
  | cons x xs ih =>
    intro n
    simp only [insertionSort, insert_count, count]
    have h := ih n
    omega

-- Why this matters:
-- O1Sort "permutation": only checked length equality
-- Correct permutation: checks every element count matches
--
-- O1Sort.isPermutation [1,2,3] [4,5,6] = true  -- WRONG!
-- isPermutation [1,2,3] [4,5,6] = false        -- CORRECT!

-- The satirical examples teach us:
-- 1. Specifications must capture the FULL intent
-- 2. Proving properties of weak specs proves nothing useful
-- 3. The hard part of verification is writing correct specs

end CorrectSort

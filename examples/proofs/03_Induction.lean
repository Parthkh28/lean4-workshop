-- Induction: Proving Properties of Recursive Structures
-- Demonstrates induction on Nat and List

namespace Induction

-- ===== NATURAL NUMBER INDUCTION =====

-- Principle: To prove P(n) for all n:
-- 1. Base case: Prove P(0)
-- 2. Inductive step: Assuming P(k), prove P(k+1)

-- Sum of first n natural numbers
def sumTo : Nat → Nat
  | 0 => 0
  | n + 1 => (n + 1) + sumTo n

-- Simple property: sumTo 0 = 0
example : sumTo 0 = 0 := rfl

-- sumTo 3 = 6
example : sumTo 3 = 6 := rfl

-- Factorial
def fact : Nat → Nat
  | 0 => 1
  | n + 1 => (n + 1) * fact n

-- Factorial is always positive
theorem fact_pos (n : Nat) : fact n > 0 := by
  induction n with
  | zero => simp [fact]
  | succ k ih =>
    simp [fact]
    omega

-- ===== LIST INDUCTION =====

-- Principle: To prove P(xs) for all lists xs:
-- 1. Base case: Prove P([])
-- 2. Inductive step: Assuming P(xs), prove P(x :: xs)

-- Length of append
theorem length_append (xs ys : List α) :
    (xs ++ ys).length = xs.length + ys.length := by
  induction xs with
  | nil => simp
  | cons x xs ih => simp [ih]; omega

-- Reverse reverse is identity
theorem reverse_reverse (xs : List α) : xs.reverse.reverse = xs := by
  induction xs with
  | nil => rfl
  | cons x xs ih => simp [ih]

-- Map preserves length
theorem map_length (f : α → β) (xs : List α) :
    (xs.map f).length = xs.length := by
  induction xs with
  | nil => rfl
  | cons x xs ih => simp [ih]

-- ===== INDUCTION ON CUSTOM TYPES =====

-- Binary trees
inductive Tree (α : Type) where
  | leaf : Tree α
  | node : Tree α → α → Tree α → Tree α
  deriving Repr

open Tree

-- Count nodes
def Tree.size : Tree α → Nat
  | leaf => 0
  | node l _ r => 1 + l.size + r.size

-- Mirror a tree
def Tree.mirror : Tree α → Tree α
  | leaf => leaf
  | node l x r => node r.mirror x l.mirror

-- Mirror mirror is identity
theorem mirror_mirror (t : Tree α) : t.mirror.mirror = t := by
  induction t with
  | leaf => rfl
  | node l x r ih_l ih_r =>
    simp [Tree.mirror, ih_l, ih_r]

-- Size of mirrored tree equals original
theorem mirror_size (t : Tree α) : t.mirror.size = t.size := by
  induction t with
  | leaf => rfl
  | node l x r ih_l ih_r =>
    simp [Tree.mirror, Tree.size, ih_l, ih_r]
    omega

-- ===== MUTUAL INDUCTION =====

-- Even and odd definitions
mutual
  def even : Nat → Bool
    | 0 => true
    | n + 1 => odd n

  def odd : Nat → Bool
    | 0 => false
    | n + 1 => even n
end

#eval even 10  -- true
#eval odd 7    -- true

-- Simple properties
example : even 0 = true := rfl
example : odd 1 = true := rfl
example : even 4 = true := rfl

end Induction

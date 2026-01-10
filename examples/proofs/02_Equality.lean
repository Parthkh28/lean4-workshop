-- Equality: Reflexivity, Rewriting, and Calculation
-- Demonstrates equality proofs with rfl, rw, calc

namespace Equality

-- ===== REFLEXIVITY =====

-- rfl proves definitional equality
example : 2 + 2 = 4 := rfl
example : "hello".length = 5 := rfl

-- Function application
def double (n : Nat) : Nat := n + n

example : double 3 = 6 := rfl

-- List operations
example : [1, 2, 3].length = 3 := rfl
example : [1, 2] ++ [3, 4] = [1, 2, 3, 4] := rfl

-- ===== SYMMETRY AND TRANSITIVITY =====

variable (a b c : Nat)

-- Eq.symm: if a = b then b = a
example (h : a = b) : b = a :=
  Eq.symm h

-- Eq.trans: if a = b and b = c then a = c
example (h1 : a = b) (h2 : b = c) : a = c :=
  Eq.trans h1 h2

-- ===== REWRITING WITH rw =====

-- rw [h] substitutes using hypothesis h
example (h : a = b) : a + c = b + c := by
  rw [h]

-- rw [← h] rewrites in reverse direction
example (h : a = b) : b + c = a + c := by
  rw [← h]

-- Multiple rewrites
example (d : Nat) (h1 : a = b) (h2 : c = d) : a + c = b + d := by
  rw [h1, h2]

-- Rewriting with lemmas
example (n : Nat) : n + 0 = n := by
  rw [Nat.add_zero]

example (n : Nat) : 0 + n = n := by
  rw [Nat.zero_add]

-- ===== CALC MODE =====

-- calc allows step-by-step equational reasoning
example (h1 : a = b) (h2 : b = c) : a = c :=
  calc a = b := h1
       _ = c := h2

-- ===== SIMP TACTIC =====

-- simp automatically applies simplification lemmas
example (n : Nat) : n + 0 = n := by simp

example (xs : List α) : xs ++ [] = xs := by simp

example (n : Nat) : 0 + n + 0 = n := by simp

-- simp with specific lemmas
example (h : a = b) : a + 0 = b := by simp [h]

-- ===== ARITHMETIC =====

-- omega solves linear arithmetic
example : (5 : Nat) + 3 = 8 := by omega

example (n : Nat) (h : n > 0) : n ≥ 1 := by omega

example (x y : Int) (h1 : x < y) (h2 : y < x + 2) : y = x + 1 := by omega

-- ===== SUBST =====

-- subst replaces variable with its equal
example (x : Nat) (h : x = 5) : x + 1 = 6 := by
  subst h
  rfl

-- ===== PROOFS ABOUT FUNCTIONS =====

theorem double_add (n : Nat) : double n = n + n := rfl

theorem double_double (n : Nat) : double (double n) = 4 * n := by
  simp only [double]
  omega

-- Function extensionality: two functions equal if equal on all inputs
example (f g : Nat → Nat) (h : ∀ x, f x = g x) : f = g := by
  funext x
  exact h x

end Equality

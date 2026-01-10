-- Logic: Propositional and Predicate Logic
-- Demonstrates logical connectives and basic proofs

namespace Logic

-- Propositions are types in Lean
-- Proofs are values of those types

variable (P Q R : Prop)

-- ===== CONJUNCTION (AND) =====

-- To prove P ∧ Q, provide proofs of both P and Q
example (hp : P) (hq : Q) : P ∧ Q :=
  And.intro hp hq

-- Shorthand with angle brackets
example (hp : P) (hq : Q) : P ∧ Q :=
  ⟨hp, hq⟩

-- To use P ∧ Q, extract left and right parts
example (h : P ∧ Q) : P :=
  h.left

example (h : P ∧ Q) : Q :=
  h.right

-- And is commutative
theorem and_comm' : P ∧ Q → Q ∧ P := by
  intro h
  exact ⟨h.right, h.left⟩

-- ===== DISJUNCTION (OR) =====

-- To prove P ∨ Q, provide proof of P or proof of Q
example (hp : P) : P ∨ Q :=
  Or.inl hp

example (hq : Q) : P ∨ Q :=
  Or.inr hq

-- To use P ∨ Q, case analysis
theorem or_comm' : P ∨ Q → Q ∨ P := by
  intro h
  cases h with
  | inl hp => exact Or.inr hp
  | inr hq => exact Or.inl hq

-- ===== IMPLICATION =====

-- Implication is a function
example : P → P :=
  fun hp => hp

-- Modus ponens
example (hpq : P → Q) (hp : P) : Q :=
  hpq hp

-- ===== NEGATION =====

-- ¬P is defined as P → False
example (h : P) (hn : ¬P) : False :=
  hn h

-- Proof by contradiction (intro of double negation)
theorem not_not_intro (hp : P) : ¬¬P := by
  intro hnp
  exact hnp hp

-- ===== BICONDITIONAL (IFF) =====

-- P ↔ Q means (P → Q) ∧ (Q → P)
theorem iff_intro (hpq : P → Q) (hqp : Q → P) : P ↔ Q :=
  ⟨hpq, hqp⟩

example (h : P ↔ Q) (hp : P) : Q :=
  h.mp hp

-- ===== QUANTIFIERS =====

-- Universal quantifier: ∀
example : ∀ n : Nat, n = n := by
  intro n
  rfl

-- Existential quantifier: ∃
example : ∃ n : Nat, n > 5 :=
  ⟨10, by omega⟩

-- ===== PRACTICAL THEOREMS =====

-- De Morgan's law
theorem demorgan_or (h : ¬(P ∨ Q)) : ¬P ∧ ¬Q := by
  constructor
  · intro hp
    exact h (Or.inl hp)
  · intro hq
    exact h (Or.inr hq)

-- Contrapositive
theorem contrapositive (h : P → Q) : ¬Q → ¬P := by
  intro hnq hp
  exact hnq (h hp)

-- Double negation elimination (requires classical logic)
-- In classical logic: if ¬¬P then P
-- Note: Lean 4's Classical.not_not provides this
#check @Classical.not_not  -- ¬¬a ↔ a

end Logic

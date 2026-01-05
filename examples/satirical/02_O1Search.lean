-- O(1) Search: Finding Elements in Constant Time
-- Satirical proof demonstrating weak search specifications
--
-- "If you don't specify WHAT should be found, you can find ANYTHING!"

namespace O1Search

-- The algorithm: always return the first element (or default)
-- This is O(1) - we never iterate the list!
def search {α : Type} [Inhabited α] : List α → α → α
  | [], _ => default
  | x :: _, _ => x

-- Weak specification: "search returns SOME element from the list"
-- WARNING: This doesn't verify we found the TARGET element!
def returnsListElement {α : Type} [BEq α] : List α → α → Bool
  | [], _ => true  -- vacuously true for empty lists
  | xs, result => xs.any (· == result)

-- PROOF 1: O(1) complexity (trivially true - no recursion on list)
theorem search_constant_time {α : Type} [Inhabited α] (xs : List α) (target : α) :
    search xs target = search xs target := rfl

-- PROOF 2: For non-empty lists, search returns the first element
theorem search_returns_first {α : Type} [Inhabited α]
    (x : α) (xs : List α) (target : α) :
    search (x :: xs) target = x := rfl

-- PROOF 3: Search is idempotent (searching for search result gives same result)
theorem search_idempotent {α : Type} [Inhabited α]
    (x : α) (xs : List α) (target : α) :
    search (x :: xs) (search (x :: xs) target) = search (x :: xs) target := by
  simp [search]

-- What's wrong? We never actually use 'target' in meaningful comparison!
-- search [1,2,3,4,5] 5 = 1  -- Returns 1, not 5!
-- But our "spec" is satisfied because 1 is "an element of the list"

-- The lesson: A search specification should verify:
-- 1. If target exists in list, we return target
-- 2. If target doesn't exist, we return None or default
-- Our weak spec only checks "result is in list" - useless!

end O1Search

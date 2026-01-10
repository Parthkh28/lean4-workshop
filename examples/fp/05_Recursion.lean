-- Recursion: Patterns and Termination
-- Demonstrates various recursion patterns in Lean 4

namespace Recursion

-- ===== STRUCTURAL RECURSION =====

-- Lean automatically proves termination for structural recursion
-- (recursing on structurally smaller arguments)

-- Factorial - structural on Nat
def factorial : Nat → Nat
  | 0 => 1
  | n + 1 => (n + 1) * factorial n

#eval factorial 5  -- 120

-- List length - structural on List
def length : List α → Nat
  | [] => 0
  | _ :: xs => 1 + length xs

#eval length [1, 2, 3, 4, 5]  -- 5

-- ===== PATTERN MATCHING RECURSION =====

-- Multiple patterns
def zip : List α → List β → List (α × β)
  | [], _ => []
  | _, [] => []
  | x :: xs, y :: ys => (x, y) :: zip xs ys

#eval zip [1, 2, 3] ["a", "b"]  -- [(1, "a"), (2, "b")]

-- Nested patterns
def flatten : List (List α) → List α
  | [] => []
  | [] :: xss => flatten xss
  | (x :: xs) :: xss => x :: flatten (xs :: xss)

#eval flatten [[1, 2], [3], [4, 5, 6]]  -- [1, 2, 3, 4, 5, 6]

-- ===== WELL-FOUNDED RECURSION =====

-- When structural recursion isn't obvious, use `termination_by`

-- Division by repeated subtraction (using partial for simplicity)
partial def div (n m : Nat) : Nat :=
  if m == 0 then 0
  else if n < m then 0
  else 1 + div (n - m) m

#eval div 17 5  -- 3

-- GCD using Euclidean algorithm (using partial for simplicity)
partial def gcd (a b : Nat) : Nat :=
  if b == 0 then a
  else gcd b (a % b)

#eval gcd 48 18  -- 6
#eval gcd 100 35  -- 5

-- ===== TAIL RECURSION =====

-- Tail recursive functions compile to loops
-- Use accumulator pattern

-- Non-tail-recursive sum
def sumList : List Nat → Nat
  | [] => 0
  | x :: xs => x + sumList xs

-- Tail-recursive sum with accumulator
def sumListTR (xs : List Nat) : Nat :=
  go xs 0
where
  go : List Nat → Nat → Nat
    | [], acc => acc
    | x :: xs, acc => go xs (acc + x)

#eval sumList [1, 2, 3, 4, 5]    -- 15
#eval sumListTR [1, 2, 3, 4, 5]  -- 15

-- Tail-recursive reverse
def reverseTR (xs : List α) : List α :=
  go xs []
where
  go : List α → List α → List α
    | [], acc => acc
    | x :: xs, acc => go xs (x :: acc)

#eval reverseTR [1, 2, 3, 4, 5]  -- [5, 4, 3, 2, 1]

-- ===== MUTUAL RECURSION =====

mutual
  def isEven : Nat → Bool
    | 0 => true
    | n + 1 => isOdd n

  def isOdd : Nat → Bool
    | 0 => false
    | n + 1 => isEven n
end

#eval isEven 10  -- true
#eval isOdd 7    -- true

-- ===== RECURSION ON MULTIPLE ARGUMENTS =====

-- Ackermann function (grows very fast!)
def ack : Nat → Nat → Nat
  | 0, n => n + 1
  | m + 1, 0 => ack m 1
  | m + 1, n + 1 => ack m (ack (m + 1) n)

#eval ack 0 5   -- 6
#eval ack 1 5   -- 7
#eval ack 2 5   -- 13
#eval ack 3 3   -- 61

-- ===== PARTIAL FUNCTIONS =====

-- Use `partial` for functions Lean can't prove terminate
-- Warning: partial functions are unsafe in proofs!

partial def collatz (n : Nat) : Nat :=
  if n ≤ 1 then 0
  else if n % 2 == 0 then 1 + collatz (n / 2)
  else 1 + collatz (3 * n + 1)

#eval collatz 27  -- 111 steps to reach 1

-- ===== FUEL PATTERN =====

-- Alternative to partial: limit recursion depth

-- Use match for cleaner termination
def collatzWithFuel : Nat → Nat → Option Nat
  | 0, _ => none
  | _, 0 => some 0
  | _, 1 => some 0
  | fuel + 1, n =>
    if n % 2 == 0 then (collatzWithFuel fuel (n / 2)).map (· + 1)
    else (collatzWithFuel fuel (3 * n + 1)).map (· + 1)

#eval collatzWithFuel 1000 27  -- some 111
#eval collatzWithFuel 10 27    -- none (ran out of fuel)

-- ===== RECURSION PRINCIPLES =====

-- List.rec is the recursion principle for lists
-- Can be used directly (rarely needed)

def myFoldr (f : α → β → β) (init : β) (xs : List α) : β :=
  match xs with
  | [] => init
  | x :: xs => f x (myFoldr f init xs)

#eval myFoldr (· + ·) 0 [1, 2, 3, 4, 5]  -- 15
#eval myFoldr (· :: ·) [] [1, 2, 3]       -- [1, 2, 3]

-- Express many functions using fold
def myLength (xs : List α) : Nat :=
  xs.foldl (fun acc _ => acc + 1) 0

def myReverse (xs : List α) : List α :=
  xs.foldl (fun acc x => x :: acc) []

def myMap (f : α → β) (xs : List α) : List β :=
  xs.foldr (fun x acc => f x :: acc) []

#eval myLength [1, 2, 3, 4]        -- 4
#eval myReverse [1, 2, 3, 4]       -- [4, 3, 2, 1]
#eval myMap (· * 2) [1, 2, 3, 4]   -- [2, 4, 6, 8]

end Recursion

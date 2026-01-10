-- Option Monad: Safe Handling of Missing Values
-- Demonstrates the Option type and monadic operations

namespace OptionMonad

-- Option type represents values that might be missing
-- Option α = some x | none

-- Safe list indexing returns Option
def safeHead : List α → Option α
  | [] => none
  | x :: _ => some x

def safeTail : List α → Option (List α)
  | [] => none
  | _ :: xs => some xs

-- Without monads: nested pattern matching gets ugly
def addFirstTwo_ugly (xs : List Nat) : Option Nat :=
  match xs[0]? with
  | none => none
  | some a =>
    match xs[1]? with
    | none => none
    | some b => some (a + b)

-- With bind (>>=): cleaner chaining
def addFirstTwo (xs : List Nat) : Option Nat :=
  xs[0]? >>= fun a =>
  xs[1]? >>= fun b =>
  some (a + b)

-- With do-notation: imperative style
def addFirstTwo_do (xs : List Nat) : Option Nat := do
  let a ← xs[0]?
  let b ← xs[1]?
  return a + b

-- Examples
#eval addFirstTwo [1, 2, 3]      -- some 3
#eval addFirstTwo [1]            -- none
#eval addFirstTwo ([] : List Nat) -- none

-- Chaining multiple optional operations
def sumFirstThree (xs : List Nat) : Option Nat := do
  let a ← xs[0]?
  let b ← xs[1]?
  let c ← xs[2]?
  return a + b + c

#eval sumFirstThree [10, 20, 30, 40]  -- some 60
#eval sumFirstThree [10, 20]          -- none

-- Option.map: apply function to value if present
#eval Option.map (· + 1) (some 5)  -- some 6
#eval Option.map (· + 1) none      -- none

-- Option.getD: provide default value
#eval (some 42).getD 0   -- 42
#eval none.getD 0        -- 0

-- Option.filter: keep value only if predicate holds
#eval (some 10).filter (· > 5)   -- some 10
#eval (some 3).filter (· > 5)    -- none

-- Practical example: safe division
def safeDiv (a b : Nat) : Option Nat :=
  if b == 0 then none else some (a / b)

def compute (a b c : Nat) : Option Nat := do
  let x ← safeDiv a b
  let y ← safeDiv x c
  return y + 1

#eval compute 100 5 2   -- some 11  (100/5=20, 20/2=10, 10+1=11)
#eval compute 100 0 2   -- none (division by zero)
#eval compute 100 5 0   -- none (division by zero)

end OptionMonad

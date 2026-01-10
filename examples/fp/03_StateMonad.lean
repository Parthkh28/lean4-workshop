-- State Monad: Threading State Through Computations
-- Demonstrates StateM for stateful programming

namespace StateMonad

-- StateM σ α represents a computation that:
-- - Has access to mutable state of type σ
-- - Returns a value of type α

-- Basic state operations:
-- get : StateM σ σ           -- read current state
-- set : σ → StateM σ Unit    -- replace state
-- modify : (σ → σ) → StateM σ Unit  -- transform state

-- Simple counter example
def increment : StateM Nat Unit :=
  modify (· + 1)

def decrement : StateM Nat Unit :=
  modify (· - 1)

def getCount : StateM Nat Nat :=
  get

-- Combine state operations
def countOperations : StateM Nat Nat := do
  increment
  increment
  increment
  decrement
  getCount

-- Run state computation with initial state
#eval countOperations.run 0      -- (2, 2) - (result, final state)
#eval countOperations.run 10     -- (12, 12)
#eval countOperations.run' 0     -- 2 (just the result)

-- More complex example: stack operations
abbrev Stack α := List α
abbrev StackM α β := StateM (Stack α) β

def push (x : α) : StackM α Unit :=
  modify (x :: ·)

def pop : StackM α (Option α) := do
  let stack ← get
  match stack with
  | [] => return none
  | x :: xs =>
    set xs
    return some x

def peek : StackM α (Option α) := do
  let stack ← get
  return stack.head?

def stackSize : StackM α Nat := do
  let stack ← get
  return stack.length

-- Stack computation example
def stackExample : StackM Nat (List (Option Nat)) := do
  push 1
  push 2
  push 3
  let a ← pop    -- some 3
  let b ← peek   -- some 2
  push 4
  let c ← pop    -- some 4
  let d ← pop    -- some 2
  return [a, b, c, d]

#eval stackExample.run []
-- ([some 3, some 2, some 4, some 2], [1])

-- Practical example: unique ID generator
structure IdGen where
  nextId : Nat
  deriving Repr

def freshId : StateM IdGen Nat := do
  let gen ← get
  set { gen with nextId := gen.nextId + 1 }
  return gen.nextId

def allocateIds (n : Nat) : StateM IdGen (List Nat) := do
  let mut ids := []
  for _ in [0:n] do
    let id ← freshId
    ids := ids ++ [id]
  return ids

#eval allocateIds 5 |>.run { nextId := 100 }
-- ([100, 101, 102, 103, 104], { nextId := 105 })

-- Combining State with other computations
def divideState (a b : Nat) : StateM (List String) (Option Nat) := do
  if b == 0 then
    modify (· ++ ["Division by zero attempted"])
    return none
  else
    modify (· ++ [s!"Computed {a} / {b} = {a/b}"])
    return some (a / b)

def loggedComputation : StateM (List String) (Option Nat) := do
  let r1 ← divideState 10 2
  let r2 ← divideState 20 4
  let r3 ← divideState 5 0   -- This logs an error
  match r1, r2 with
  | some x, some y => return some (x + y)
  | _, _ => return none

#eval loggedComputation.run []
-- (some 10, ["Computed 10 / 2 = 5", "Computed 20 / 4 = 5", "Division by zero attempted"])

end StateMonad

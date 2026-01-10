-- IO Monad: Side Effects in a Pure Language
-- Demonstrates IO operations and do-notation

namespace IOMonad

-- IO α represents a computation that may perform side effects
-- and produces a value of type α

-- Basic output
def hello : IO Unit := IO.println "Hello, Lean 4!"

-- Multiple actions with do-notation
def greet (name : String) : IO Unit := do
  IO.println s!"Hello, {name}!"
  IO.println "Welcome to Lean 4"

-- Reading and writing
def askName : IO String := do
  IO.println "What is your name?"
  let stdin ← IO.getStdin
  let name ← stdin.getLine
  return name.trim

def interactive : IO Unit := do
  let name ← askName
  IO.println s!"Nice to meet you, {name}!"

-- Combining IO with pure computations
def factorial : Nat → Nat
  | 0 => 1
  | n + 1 => (n + 1) * factorial n

def computeFactorial : IO Unit := do
  IO.println "Enter a number (0-10):"
  let stdin ← IO.getStdin
  let input ← stdin.getLine
  match input.trim.toNat? with
  | some n =>
    if n ≤ 10 then
      IO.println s!"{n}! = {factorial n}"
    else
      IO.println "Number too large!"
  | none =>
    IO.println "Invalid input!"

-- IO with loops
def countdown (n : Nat) : IO Unit := do
  for i in [0:n+1] do
    IO.println s!"{n - i}..."
  IO.println "Liftoff!"

-- File operations (conceptual - may need file to exist)
def writeFile (path content : String) : IO Unit := do
  IO.FS.writeFile path content
  IO.println s!"Wrote to {path}"

def readFile (path : String) : IO String := do
  let content ← IO.FS.readFile path
  return content

-- Error handling with IO
def safeDivIO (a b : Nat) : IO Nat := do
  if b == 0 then
    throw (IO.userError "Division by zero!")
  else
    return a / b

def divideWithError : IO Unit := do
  try
    let result ← safeDivIO 10 0
    IO.println s!"Result: {result}"
  catch e =>
    IO.println s!"Error: {e}"

-- Main entry point example
def main : IO Unit := do
  IO.println "=== IO Monad Demo ==="
  greet "Workshop Participant"
  IO.println ""
  IO.println "Factorial of 5:"
  IO.println s!"5! = {factorial 5}"
  IO.println ""
  countdown 3

-- Run with: lake env lean --run examples/fp/02_IOMonad.lean

end IOMonad

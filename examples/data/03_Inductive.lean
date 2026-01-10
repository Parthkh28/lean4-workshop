-- Inductive Types: Custom Data Structures
-- Demonstrates defining and using inductive types

namespace InductiveTypes

-- ===== ENUMERATIONS =====

-- Simple enumeration
inductive Weekday where
  | sunday
  | monday
  | tuesday
  | wednesday
  | thursday
  | friday
  | saturday
  deriving Repr, BEq

open Weekday

def isWeekend : Weekday → Bool
  | sunday => true
  | saturday => true
  | _ => false

#eval isWeekend friday    -- false
#eval isWeekend saturday  -- true

def nextDay : Weekday → Weekday
  | sunday => monday
  | monday => tuesday
  | tuesday => wednesday
  | wednesday => thursday
  | thursday => friday
  | friday => saturday
  | saturday => sunday

-- ===== SUM TYPES (VARIANTS) =====

-- Result type (like Rust's Result)
inductive Result (ε α : Type) where
  | ok : α → Result ε α
  | error : ε → Result ε α
  deriving Repr

open Result

def divide (a b : Int) : Result String Int :=
  if b == 0 then error "Division by zero"
  else ok (a / b)

#eval divide 10 3   -- ok 3
#eval divide 10 0   -- error "Division by zero"

def mapResult (f : α → β) : Result ε α → Result ε β
  | ok x => ok (f x)
  | error e => error e

-- ===== RECURSIVE TYPES =====

-- Natural numbers (Peano)
inductive MyNat where
  | zero : MyNat
  | succ : MyNat → MyNat
  deriving Repr

open MyNat

def myAdd : MyNat → MyNat → MyNat
  | m, zero => m
  | m, succ n => succ (myAdd m n)

def myMul : MyNat → MyNat → MyNat
  | _, zero => zero
  | m, succ n => myAdd m (myMul m n)

def toNat : MyNat → Nat
  | zero => 0
  | succ n => 1 + toNat n

def fromNat : Nat → MyNat
  | 0 => zero
  | n + 1 => succ (fromNat n)

#eval toNat (myMul (fromNat 3) (fromNat 4))  -- 12

-- ===== BINARY TREES =====

inductive BinTree (α : Type) where
  | empty : BinTree α
  | node : BinTree α → α → BinTree α → BinTree α
  deriving Repr

open BinTree

def singleton (x : α) : BinTree α :=
  node empty x empty

def insert [Ord α] (x : α) : BinTree α → BinTree α
  | empty => singleton x
  | node l y r =>
    match compare x y with
    | .lt => node (insert x l) y r
    | .eq => node l y r  -- already present
    | .gt => node l y (insert x r)

def contains [Ord α] (x : α) : BinTree α → Bool
  | empty => false
  | node l y r =>
    match compare x y with
    | .lt => contains x l
    | .eq => true
    | .gt => contains x r

def fromList [Ord α] (xs : List α) : BinTree α :=
  xs.foldl (fun t x => insert x t) empty

def BinTree.toList : BinTree α → List α
  | empty => []
  | node l x r => l.toList ++ [x] ++ r.toList

-- In-order traversal gives sorted list for BST
def sort [Ord α] (xs : List α) : List α :=
  (fromList xs).toList

#eval sort [3, 1, 4, 1, 5, 9, 2, 6]  -- [1, 2, 3, 4, 5, 6, 9]

-- ===== EXPRESSION TREES =====

inductive Expr where
  | const : Int → Expr
  | var : String → Expr
  | add : Expr → Expr → Expr
  | mul : Expr → Expr → Expr
  | neg : Expr → Expr
  deriving Repr

open Expr

-- Environment maps variable names to values
abbrev Env := String → Int

def eval (env : Env) : Expr → Int
  | const n => n
  | var x => env x
  | add e1 e2 => eval env e1 + eval env e2
  | mul e1 e2 => eval env e1 * eval env e2
  | neg e => - eval env e

-- Example: 2 * x + 3
def expr1 : Expr := add (mul (const 2) (var "x")) (const 3)

def env1 : Env := fun s => if s == "x" then 5 else 0

#eval eval env1 expr1  -- 2 * 5 + 3 = 13

-- Simplification
def simplify : Expr → Expr
  | add (const 0) e => simplify e
  | add e (const 0) => simplify e
  | mul (const 0) _ => const 0
  | mul _ (const 0) => const 0
  | mul (const 1) e => simplify e
  | mul e (const 1) => simplify e
  | neg (neg e) => simplify e
  | add e1 e2 => add (simplify e1) (simplify e2)
  | mul e1 e2 => mul (simplify e1) (simplify e2)
  | neg e => neg (simplify e)
  | e => e

-- ===== ROSE TREES (N-ARY TREES) =====

inductive RoseTree (α : Type) where
  | rnode : α → List (RoseTree α) → RoseTree α
  deriving Repr

def rtSize : RoseTree α → Nat
  | .rnode _ children => 1 + children.foldl (fun acc t => acc + rtSize t) 0

def rtDepth : RoseTree α → Nat
  | .rnode _ [] => 1
  | .rnode _ children => 1 + children.foldl (fun acc t => max acc (rtDepth t)) 0

-- File system example
def fileTree : RoseTree String :=
  .rnode "root" [
    .rnode "home" [
      .rnode "user" [
        .rnode "documents" [],
        .rnode "downloads" []
      ]
    ],
    .rnode "etc" [
      .rnode "config" []
    ],
    .rnode "var" []
  ]

#eval rtSize fileTree   -- 8
#eval rtDepth fileTree  -- 4

-- ===== INDEXED INDUCTIVE TYPES =====

-- Vector: list with length in the type
inductive Vec (α : Type) : Nat → Type where
  | nil : Vec α 0
  | cons : α → Vec α n → Vec α (n + 1)
  deriving Repr

open Vec

def vhead : Vec α (n + 1) → α
  | cons x _ => x

def vtail : Vec α (n + 1) → Vec α n
  | cons _ xs => xs

-- Type-safe! Can't call vhead on empty vector
def v123 : Vec Nat 3 := cons 1 (cons 2 (cons 3 nil))

#eval vhead v123  -- 1
#eval vtail v123  -- cons 2 (cons 3 nil)

-- vhead nil  -- Type error! nil has type Vec α 0, not Vec α (n + 1)

end InductiveTypes

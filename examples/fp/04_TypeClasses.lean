-- Type Classes: Polymorphism and Overloading
-- Demonstrates defining and using type classes

namespace TypeClasses

-- Type class: a collection of operations for a type
-- Think of it like an interface in OOP

-- Define a type class for things that can be "doubled"
class Doubleable (α : Type) where
  double : α → α

-- Instances: implementations for specific types
instance : Doubleable Nat where
  double := (· * 2)

instance : Doubleable Int where
  double := (· * 2)

instance : Doubleable String where
  double := fun s => s ++ s

instance : Doubleable (List α) where
  double := fun xs => xs ++ xs

-- Use the type class polymorphically
def quadruple [Doubleable α] (x : α) : α :=
  Doubleable.double (Doubleable.double x)

#eval quadruple (5 : Nat)        -- 20
#eval quadruple "ab"             -- "abababab"
#eval quadruple [1, 2]           -- [1, 2, 1, 2, 1, 2, 1, 2]

-- Built-in type classes

-- ToString: convert to string representation
instance : ToString Bool where
  toString b := if b then "yes" else "no"

#eval toString true   -- "yes"

-- BEq: boolean equality
structure Point where
  x : Int
  y : Int
  deriving Repr

instance : BEq Point where
  beq p1 p2 := p1.x == p2.x && p1.y == p2.y

#eval Point.mk 1 2 == Point.mk 1 2   -- true
#eval Point.mk 1 2 == Point.mk 1 3   -- false

-- Ord: ordering/comparison
instance : Ord Point where
  compare p1 p2 :=
    match compare p1.x p2.x with
    | .eq => compare p1.y p2.y
    | other => other

#eval compare (Point.mk 1 2) (Point.mk 2 1)  -- .lt

-- Add: addition operator
instance : Add Point where
  add p1 p2 := { x := p1.x + p2.x, y := p1.y + p2.y }

#eval Point.mk 1 2 + Point.mk 3 4   -- { x := 4, y := 6 }

-- Mul: scalar multiplication (HMul for heterogeneous)
instance : HMul Int Point Point where
  hMul n p := { x := n * p.x, y := n * p.y }

#eval (3 : Int) * Point.mk 2 5   -- { x := 6, y := 15 }

-- Combining type classes: requiring multiple constraints
def doubleAndShow [Doubleable α] [ToString α] (x : α) : String :=
  s!"Doubled: {Doubleable.double x}"

#eval doubleAndShow (7 : Nat)    -- "Doubled: 14"

-- Default implementations in type classes
class Measurable (α : Type) where
  size : α → Nat
  isEmpty : α → Bool := fun x => size x == 0

instance : Measurable String where
  size := String.length

instance : Measurable (List α) where
  size := List.length

#eval Measurable.size "hello"           -- 5
#eval Measurable.isEmpty ""             -- true
#eval Measurable.isEmpty [1, 2, 3]      -- false

-- Inheritance: extending type classes
class Printable (α : Type) extends ToString α where
  printLn : α → IO Unit := fun x => IO.println (toString x)

-- Deriving: automatic instance generation
structure Person where
  name : String
  age : Nat
  deriving Repr, BEq, Hashable

#eval Person.mk "Alice" 30 == Person.mk "Alice" 30  -- true
#eval repr (Person.mk "Bob" 25)  -- { name := "Bob", age := 25 }

end TypeClasses

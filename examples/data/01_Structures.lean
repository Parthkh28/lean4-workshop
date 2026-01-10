-- Structures: Records and Product Types
-- Demonstrates structure definitions and operations

namespace Structures

-- Basic structure definition
structure Point2D where
  x : Float
  y : Float
  deriving Repr

-- Creating instances
def origin : Point2D := { x := 0.0, y := 0.0 }
def p1 : Point2D := Point2D.mk 3.0 4.0
def p2 : Point2D := ⟨1.0, 2.0⟩  -- anonymous constructor

-- Field access with dot notation
#eval p1.x   -- 3.0
#eval p1.y   -- 4.0

-- Record update syntax (functional update)
def p3 : Point2D := { p1 with y := 10.0 }
#eval p3   -- { x := 3.0, y := 10.0 }

-- Methods on structures (using namespace)
namespace Point2D

def distance (p : Point2D) : Float :=
  Float.sqrt (p.x * p.x + p.y * p.y)

def add (p1 p2 : Point2D) : Point2D :=
  { x := p1.x + p2.x, y := p1.y + p2.y }

def scale (p : Point2D) (factor : Float) : Point2D :=
  { x := p.x * factor, y := p.y * factor }

end Point2D

-- Dot notation for methods
#eval p1.distance       -- 5.0 (3-4-5 triangle)
#eval p1.add p2         -- { x := 4.0, y := 6.0 }
#eval p1.scale 2.0      -- { x := 6.0, y := 8.0 }

-- Structure with default values
structure Config where
  host : String := "localhost"
  port : Nat := 8080
  debug : Bool := false
  deriving Repr

def defaultConfig : Config := {}
def customConfig : Config := { port := 3000, debug := true }

#eval defaultConfig   -- { host := "localhost", port := 8080, debug := false }
#eval customConfig    -- { host := "localhost", port := 3000, debug := true }

-- Nested structures
structure Rectangle where
  topLeft : Point2D
  bottomRight : Point2D
  deriving Repr

def rect : Rectangle := {
  topLeft := { x := 0.0, y := 10.0 }
  bottomRight := { x := 10.0, y := 0.0 }
}

namespace Rectangle

def width (r : Rectangle) : Float :=
  r.bottomRight.x - r.topLeft.x

def height (r : Rectangle) : Float :=
  r.topLeft.y - r.bottomRight.y

def area (r : Rectangle) : Float :=
  r.width * r.height

end Rectangle

#eval rect.area   -- 100.0

-- Structure inheritance with extends
structure Point3D extends Point2D where
  z : Float
  deriving Repr

def p3d : Point3D := { x := 1.0, y := 2.0, z := 3.0 }

-- Can access parent fields
#eval p3d.x          -- 1.0
#eval p3d.toPoint2D  -- { x := 1.0, y := 2.0 }

-- Parameterized structures (generic)
structure Pair (α β : Type) where
  fst : α
  snd : β
  deriving Repr

def intStringPair : Pair Nat String := ⟨42, "answer"⟩
#eval intStringPair.fst   -- 42
#eval intStringPair.snd   -- "answer"

-- Structure with computed field (using where)
structure Circle where
  center : Point2D
  radius : Float
  deriving Repr

namespace Circle

def diameter (c : Circle) : Float := c.radius * 2.0
def circumference (c : Circle) : Float := 2.0 * 3.14159 * c.radius
def area (c : Circle) : Float := 3.14159 * c.radius * c.radius

def contains (c : Circle) (p : Point2D) : Bool :=
  let dx := p.x - c.center.x
  let dy := p.y - c.center.y
  dx * dx + dy * dy <= c.radius * c.radius

end Circle

def unitCircle : Circle := { center := origin, radius := 1.0 }

#eval unitCircle.diameter        -- 2.0
#eval unitCircle.area            -- 3.14159...
#eval unitCircle.contains p1     -- false (p1 is at (3,4), distance 5)
#eval unitCircle.contains origin -- true

-- Conditionals on structures (pattern matching on Float not supported)
def describePoint (p : Point2D) : String :=
  if p.x == 0.0 && p.y == 0.0 then "origin"
  else if p.x == 0.0 then "on y-axis"
  else if p.y == 0.0 then "on x-axis"
  else "general point"

#eval describePoint origin        -- "origin"
#eval describePoint { x := 0.0, y := 5.0 }  -- "on y-axis"

end Structures

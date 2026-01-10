-- Arrays: Efficient Random Access Data Structures
-- Demonstrates Array operations and indexing

namespace Arrays

-- Arrays vs Lists:
-- - Array: O(1) random access, O(1) amortized push, contiguous memory
-- - List: O(n) random access, O(1) cons, linked structure

-- Creating arrays
def arr1 : Array Nat := #[1, 2, 3, 4, 5]
def arr2 : Array String := #["hello", "world"]
def empty : Array Int := #[]

-- Size and emptiness
#eval arr1.size      -- 5
#eval empty.isEmpty  -- true
#eval arr1.isEmpty   -- false

-- Indexing (multiple ways)
#eval arr1[0]        -- 1 (panics if out of bounds)
#eval arr1[0]!       -- 1 (same, panics)
#eval arr1[0]?       -- some 1 (returns Option)
#eval arr1[10]?      -- none

-- Safe indexing with proof
def safeIndex (arr : Array α) (i : Nat) (h : i < arr.size) : α :=
  arr[i]

-- Adding elements
#eval arr1.push 6           -- #[1, 2, 3, 4, 5, 6]
#eval #[0].append arr1      -- #[0, 1, 2, 3, 4, 5]
#eval arr1 ++ #[6, 7]       -- #[1, 2, 3, 4, 5, 6, 7]

-- Modifying elements
#eval arr1.set! 0 100       -- #[100, 2, 3, 4, 5]
#eval arr1.modify 0 (· + 10) -- #[11, 2, 3, 4, 5]

-- Removing elements
#eval arr1.pop              -- #[1, 2, 3, 4] (removes last)
#eval arr1.erase 3          -- #[1, 2, 4, 5] (removes first occurrence of 3)

-- Functional operations
#eval arr1.map (· * 2)              -- #[2, 4, 6, 8, 10]
#eval arr1.filter (· > 2)           -- #[3, 4, 5]
#eval arr1.foldl (· + ·) 0          -- 15
#eval arr1.any (· > 4)              -- true
#eval arr1.all (· < 10)             -- true

-- Finding elements
#eval arr1.find? (· > 3)            -- some 4
#eval arr1.findIdx? (· > 3)         -- some 3 (index)
#eval arr1.contains 3               -- true

-- Converting to/from List
#eval arr1.toList                   -- [1, 2, 3, 4, 5]
#eval [1, 2, 3].toArray             -- #[1, 2, 3]

-- Range operations
#eval arr1.extract 1 4              -- #[2, 3, 4] (slice from 1 to 4)
#eval arr1.take 3                   -- #[1, 2, 3]
#eval arr1.drop 2                   -- #[3, 4, 5]
#eval arr1.reverse                  -- #[5, 4, 3, 2, 1]

-- Zip operations
#eval arr1.zip #["a", "b", "c"]     -- #[(1, "a"), (2, "b"), (3, "c")]
#eval Array.zipWith (· + ·) arr1 #[10, 20, 30, 40, 50]  -- #[11, 22, 33, 44, 55]

-- Building arrays efficiently
def squares (n : Nat) : Array Nat := Id.run do
  let mut result := #[]
  for i in [0:n] do
    result := result.push (i * i)
  return result

#eval squares 5   -- #[0, 1, 4, 9, 16]

-- Array.range and Array.mkArray
#eval Array.range 5              -- #[0, 1, 2, 3, 4]
#eval Array.replicate 3 "x"      -- #["x", "x", "x"]

-- Sorting
#eval #[3, 1, 4, 1, 5, 9, 2, 6].qsort (· < ·)  -- #[1, 1, 2, 3, 4, 5, 6, 9]

-- Practical example: running sum
def runningSum (arr : Array Nat) : Array Nat := Id.run do
  let mut result := #[]
  let mut total := 0
  for x in arr do
    total := total + x
    result := result.push total
  return result

#eval runningSum #[1, 2, 3, 4, 5]   -- #[1, 3, 6, 10, 15]

-- Binary search on sorted array
partial def binarySearch (arr : Array Nat) (target : Nat) : Option Nat :=
  go 0 arr.size
where
  go (lo hi : Nat) : Option Nat :=
    if lo >= hi then none
    else
      let mid := (lo + hi) / 2
      if h : mid < arr.size then
        let midVal := arr[mid]
        if midVal == target then some mid
        else if midVal < target then go (mid + 1) hi
        else go lo mid
      else none

#eval binarySearch #[1, 3, 5, 7, 9, 11] 7   -- some 3
#eval binarySearch #[1, 3, 5, 7, 9, 11] 4   -- none

-- 2D array example (Array of Arrays)
def matrix : Array (Array Nat) := #[
  #[1, 2, 3],
  #[4, 5, 6],
  #[7, 8, 9]
]

#eval matrix[1]![1]!   -- 5 (row 1, col 1)

-- Flatten 2D array
#eval matrix.foldl (· ++ ·) #[]   -- #[1, 2, 3, 4, 5, 6, 7, 8, 9]

end Arrays

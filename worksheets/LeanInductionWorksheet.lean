import Mathlib
/-Made by Karl Schwede for the Fall 2026 Utah Lean Seminar
on September 15th, 2026
-/
--lets make a simple function
--things like "ring", "simp", "linarith", "omega" can simplify obvious things

def oddNum (x : ℕ) : ℕ := 2*x+1

--make sure it works
#eval oddNum 2

--sums are over finite sets
#eval Finset.range 2
#eval Finset.range 3
#eval Finset.Icc 0 2



example (n : ℕ) : ∑ i ∈ Finset.range n, oddNum i = n^2 := by
  induction n with
  | zero =>
    sorry --should be obvious
  | succ n ih => --ih is the name of the inductive hypothesis
    --we need to break off the last term in the sum
    --try searching for something like
    --"sum range plus last term" in
    --https://leansearch.net/
    --you might need to `unfold` our oddNum definition
    sorry




example (n : ℕ) : (∑ i ∈ Finset.range n, (i:ℚ)) = n*(n-1)/2 := by
  induction n with
  | zero =>
    sorry
  | succ n ih => --ih stands for induction hypothesis
    -- you can push casting to Q via `push_cast`
    sorry



example (n : ℕ) : 2*(∑ i ∈ Finset.range (n+1), i) = n*(n+1) := by
  induction n with
  | zero =>
    sorry
  | succ n ih =>
    --you'll need to distribute, try searching for things like
    --distribute multiplication in https://leansearch.net/
    sorry

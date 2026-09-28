import Mathlib

#check 2
-- type `\N` for `ℕ`
#check ℕ

def num : ℕ := 5

#check num
#eval num

def foo (a : ℕ) (b : ℕ) : ℕ := a + b

#check foo 5 7
#eval foo 5 (foo 2 3)

theorem nat_add_comm (a b : ℕ) : a + b = b + a := by ring
 import Mathlib

#check exists_rat_of_not_irrational

 example : ∃ (x y : ℝ), x ≥ 0 ∧
    Irrational x ∧
    Irrational y ∧
    ∃ (q : ℚ), x ^ y = q := by
  by_cases h : Irrational (√2 ^ √2)
  · use (√2 ^ √2)
    use √2
    constructor
    · apply Real.rpow_nonneg
      exact Real.sqrt_nonneg 2
    constructor
    · exact h
    constructor
    · exact irrational_sqrt_two
    use 2
    rw [← Real.rpow_mul (Real.sqrt_nonneg 2) √2 √2]
    simp
  use √2
  use √2
  constructor
  · exact Real.sqrt_nonneg 2
  constructor
  · exact irrational_sqrt_two
  constructor
  · exact irrational_sqrt_two
  exact exists_rat_of_not_irrational h

import Mathlib

/-!
# Lean Seminar, Sep 29
-/

open Filter Topology intervalIntegral

/-! ## Part 1: Manually defined convergence -/

def ConvergesTo (s : ℕ → ℝ) (a : ℝ) : Prop :=
  ∀ ε > 0, ∃ N, ∀ n ≥ N, |s n - a| < ε

theorem convergesTo_const (a : ℝ) : ConvergesTo (fun _ ↦ a) a := by
  sorry

theorem convergesTo_add {s t : ℕ → ℝ} {a b : ℝ}
    (hs : ConvergesTo s a) (ht : ConvergesTo t b) :
    ConvergesTo (s + t) (a + b) := by
  sorry

/-! ## Part 2: Filters

Mathlib does not define limits of sequences, limits of functions, one-sided
limits, limits at infinity, ... separately. Everything goes through filters.

A *filter* on `X` is a collection of subsets of `X` ("big" sets) that
contains `X` and is closed under both supersets and finite intersections.
* `atTop : Filter ℕ` consists of the sets containing a tail `{n | n ≥ N}`.
* `𝓝 a : Filter ℝ` consists of the neighbourhoods of `a`.

`Tendsto f F G` means: the preimage under `f` of every `G`-big set is `F`-big.
So `Tendsto s atTop (𝓝 a)` says every neighbourhood of `a` contains a tail of
`s`, which is exactly convergence.

`∀ᶠ x in F, p x` (read "eventually p") means `{x | p x}` is `F`-big.
-/

#check Tendsto
#check atTop
#check 𝓝
#check @nhds

-- Our definition agrees with Mathlib's.
-- Hint: don't unfold anything!
theorem convergesTo_iff_tendsto (s : ℕ → ℝ) (a : ℝ) :
    ConvergesTo s a ↔ Tendsto s atTop (𝓝 a) := by
  sorry

-- Thinking with filters: if `s → a > 0`, then `s` is eventually positive.
-- Try not to use `convergesTo_iff_tendsto`
theorem eventually_pos {s : ℕ → ℝ} {a : ℝ}
    (h : Tendsto s atTop (𝓝 a)) (ha : 0 < a) :
    ∃ N, ∀ n ≥ N, 0 < s n := by
  sorry

/-! ## Part 3: Using the convergence library
-/

example {s t : ℕ → ℝ} {a b : ℝ} (hs : ConvergesTo s a) (ht : ConvergesTo t b) :
    ConvergesTo (s + t) (a + b) := by
  sorry

example {s t : ℕ → ℝ} {a b : ℝ} (hs : ConvergesTo s a) (ht : ConvergesTo t b) :
    ConvergesTo (s * t) (a * b) := by
  sorry

example {s : ℕ → ℝ} {a b : ℝ} (ha : ConvergesTo s a) (hb : ConvergesTo s b) :
    a = b := by
  sorry

/-! ## Part 4: Differentiation

`HasDerivAt f f' x` says `f'` is the derivative of `f` at `x`. The API is
compositional: `.add`, `.mul`, `.comp`, ... build derivatives out of pieces.
-/

example (x : ℝ) : HasDerivAt (fun x ↦ x * Real.exp x) (Real.exp x + x * Real.exp x) x := by
  have heq : (1:ℝ) * Real.exp x + x * Real.exp x = Real.exp x + x * Real.exp x := by ring
  rw [← heq]
  exact (hasDerivAt_id x).mul (Real.hasDerivAt_exp x)

example (x : ℝ) :
    HasDerivAt (fun x ↦ Real.sin (x ^ 2)) (Real.cos (x ^ 2) * (2 * x)) x := by
  sorry

-- `fun_prop` closes "obviously nice" (differentiability/continuity) goals outright.
example : Differentiable ℝ (fun x : ℝ ↦ x ^ 3 * Real.sin x + Real.exp x) := by
  fun_prop

/-! ## Part 5: Integration

`∫ x in a..b, f x` is the integral of `f` over `[a, b]`. Common closed forms are
`simp` lemmas.
-/

-- Closed forms just compute.
example : ∫ x in (0:ℝ)..1, x ^ 2 = 1 / 3 := by simp; norm_num

example : ∫ x in (0:ℝ)..2, (3 * x ^ 2 - 1) = 6 := by
  sorry

-- FTC-2: knowing a derivative computes the integral.
example : ∫ x in (0:ℝ)..1, (2 * x) = 1 := by
  have h : ∫ x in (0:ℝ)..1, (2 * x) = (1:ℝ) ^ 2 - (0:ℝ) ^ 2 :=
    integral_eq_sub_of_hasDerivAt (f := fun x => x ^ 2)
      (fun x _ => by simpa using hasDerivAt_pow 2 x)
      ((continuous_const.mul continuous_id).intervalIntegrable _ _)
  simpa using h

-- Integration by parts.
example :
    ∫ x in (0:ℝ)..Real.pi, x * Real.cos x =
      Real.pi * Real.sin Real.pi - 0 * Real.sin 0 - ∫ x in (0:ℝ)..Real.pi, Real.sin x := by
  have h := integral_mul_deriv_eq_deriv_mul_of_hasDerivAt
    (u := fun x : ℝ => x) (v := Real.sin) (u' := fun _ : ℝ => (1:ℝ)) (v' := Real.cos)
    (a := 0) (b := Real.pi)
    (by fun_prop) (by fun_prop)
    (fun x _ => hasDerivAt_id x) (fun x _ => Real.hasDerivAt_sin x)
    (continuous_const.intervalIntegrable _ _) (Real.continuous_cos.intervalIntegrable _ _)
  simpa using h

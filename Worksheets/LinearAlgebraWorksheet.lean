import Mathlib

/-
Fall 2026 Utah Lean Seminar, October 6th, 2026
Vector spaces, modules, and related things in Mathlib

We'll actually start with modules over a ring.
-/

section Modules

--So here R is a ring acting on a module M.  the multiplication action is
--written with • `\smul` (scalar multiplication)
example (R : Type) [CommRing R] (M : Type) [AddCommGroup M] [Module R M]
  (r : R) (a b : M) : r • (a + b) = r • a + r • b := by
  --which theorem should you call (simp? will tell you)
  sorry

example (R : Type) [CommRing R] (M : Type) [AddCommGroup M] [Module R M]
  (m : M) : (0 : R) • m = 0 := by
  --prove this without using simp or zero_smul
  --in other words, I am asking you to reprove zero_smul
  --Prove it the way we do in a class using things like
  --`add_smul`, `add_zero`, `add_left_cancel` etc
  sorry

--the following notation will be useful

#check ![7,9,5]  --a function from the 3-element set 0,1,2 to ℕ
#eval ![7,9,5] 1


/-We can assert that some vectors are linearly independent by `LinearIndependent R v`    where R is
 a ring and v is an indexing function from some type to a vector space (or module),
 frequently the source is a finset.
 For example, if you want to say that `a b c : M` are linearly independent
 over `R` you might write `LinearIndependent R ![a,b,c]`.
-/

--the next exercise can be solved quickly with the right tools from Mathlib,
--or you can do it more slowly, which might be more illuminating
--either way, one way to explore this is to search for `LinearIndependent pair`

example (R : Type) [Field R] (M : Type) [AddCommGroup M] [Module R M] (v w : M)
  : ¬ LinearIndependent R ![v,w] ↔ v = 0 ∨ ∃ (r : R), r • v = w := by
  sorry

--in a 3 dimensional vector space, a linearly indepent set of 3 elements spans the vector space.
--There are some Mathlib theorems that will make this very short

example (R : Type) [Field R] (M : Type) [AddCommGroup M] [Module R M] (hM : Module.finrank R M = 3)
  (a b c : M) (h : LinearIndependent R ![a,b,c]) : Submodule.span R (Set.range ![a,b,c]) = ⊤ := by
  sorry

--It may also be worth exploring how Set.range works

#check Set.range ![7,8,5]
example : Set.range ![7,8,5] = ({5,7,8} : Finset ℕ) := by
    --`aesop` will close it with a big hammer and a loud boom, you can also do this directly.
    --to do that you probably would start with something like `ext i`
    sorry

example (R : Type) [CommRing R] (M : Type) [AddCommGroup M] [Module R M] (a b : M) :
    Set.range ![a,b] = ({a,b} : Set M) := by
    sorry


--ok, lets more explicitly prove we have a spanning set.
-- the fact that we are working with a `pair` might give you easier to use tools
example (R : Type) [Field R] (M : Type) [AddCommGroup M] [Module R M] (hM : Module.finrank R M = 2)
  (a b : M) (h : LinearIndependent R ![a, b]) (x : M) :
  ∃ r s : R, x = r • a + s • b := by
  sorry

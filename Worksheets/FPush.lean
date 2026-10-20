import Mathlib

/- The following two lines say "Let `R` be a commutative ring of prime characteric `p` and
let `M` be an `R` module" -/
variable (R : Type) [CommRing R] (M : Type) [AddCommGroup M] [Module R M] (p : ℕ) [Fact p.Prime] [CharP R p]

/- `FPush M p` is what `F_* M` is in the literature. It is the same
`M` but we will give it an unusual `R`-module structure. Ignore the `set_option` line -/
set_option linter.unusedVariables false in
def FPush (M : Type) [AddCommGroup M] (p : ℕ) : Type := M
deriving AddCommGroup

/-- This lets us view an element `m` of `M` as an element of `F_* M`. In the literature,
this is `F_* m`. -/
def toFPush (p : ℕ) : M ≃+ (FPush M p) := AddEquiv.refl _

/-- We define the ring structure on `F_* R` to be the same as that of `R`. -/
instance : CommRing (FPush R p) := inferInstanceAs (CommRing R)

instance : CharP (FPush R p) p := inferInstanceAs (CharP R p)

/-- This is `toFPush` but as a ring iso. -/
def toFPushRingEquiv : R ≃+* (FPush R p) := RingEquiv.refl _

/-- We give `F_* M` the usual module structure as an `F_* R` module -/
instance : Module (FPush R p) (FPush M p) := inferInstanceAs (Module R M)

/-- We define the `R` algebra structure on `F_* R` via the frobenius map. To refer to
the frobenius as a map from `R` to `F_* R`, write `algebraMap R (FPush R p)` -/
instance : Algebra R (FPush R p) :=
  ((toFPushRingEquiv R p).toRingHom.comp (frobenius R p)).toAlgebra

/-- Now we can finally give `F_* M` its weird `R`-module structure. Since it already has
an `F_* R` module structure and `F_* R` is an `R` algebra, we can define its `R` module
structure via the algebra map `R → F_* R` -/
instance : Module R (FPush M p) := Module.compHom _ (algebraMap R (FPush R p))

/- Now that everything is defined, we can begin the "messing around" portion of this file,
first, lets define some local notation so we don't have to write things out. -/

local notation "Fᵣ" => (toFPushRingEquiv R p)

local notation "Fₘ" => (toFPush M p)

variable (r r₁ r₂ : R) (m m₁ m₂ : M)

/- Many basic properties that we want are defeqs (definitional equalities) which means
they can be proved by `rfl` -/

example : r • Fₘ m = Fₘ (r ^ p • m) := rfl

example : Fᵣ r • Fₘ m = Fₘ (r • m) := rfl

/- In general, using definitional equality to prove things is frowned upon (called defeq abuse)
as these proofs will break if the definitions ever change. To get around this, new definitions
have basic API lemmas proven for them (defeq abuse is ok for these) and all other proofs should
only use these API lemmas. That way, if the definition needs to be changed, all you have to do
is reprove the API lemmas and nothing else will break. -/

/- You can run `#simp` to see how far the `simp` tactic will simplify an expression. In the case
below, it won't simplify at all (which makes sense since we haven't proven anything yet) -/

#simp Fₘ (r₁ • m₁)

/- Now we can prove an API lemma and tag it with `@[simp]`. This tells the `simp` tactic to
replace the LHS of the equality with the RHS whenever it sees it. Ignore the `omit` line. -/

omit [Fact (Nat.Prime p)] [CharP R p] in
@[simp]
lemma toFPush_smul_apply : toFPush M p (r • m) = toFPushRingEquiv R p r • toFPush M p m := rfl

/- Now it will simplify -/

#simp Fₘ (r₁ • m₁)

@[simp]
lemma FPush_smul_def (m : FPush M p) : r • m = toFPushRingEquiv R p r ^ p • m := rfl

/- With just these two API lemmas, `simp` (along with tactics like `ring` and `module`) should
be able to solve most equalities that come up while working with `F_* M`. -/

#simp (r₁ ^ 2 + r₂) • Fₘ (2 • m₁ + m₂)

example : (r₁ ^ 2 + r₂) • Fₘ (2 • m₁) = Fᵣ r₁ ^ (2 * p) • 2 • Fₘ m₁ + Fᵣ r₂ ^ p • 2 • Fₘ m₁ := by
  simp [add_pow_char]
  module

/- Feel free to stress test this, there are certainly more API lemmas needed! -/

/- We can also check to make sure some other "obvious" compatibilites hold. -/

example : toFPush R p r = toFPushRingEquiv R p r := rfl

example : algebraMap R (FPush R p) = (toFPushRingEquiv R p).toRingHom.comp (frobenius R p) := rfl

example : algebraMap R (FPush R p) = (frobenius (FPush R p) p).comp (toFPushRingEquiv R p).toRingHom := rfl

/- This currently doesn't simplify, we should probably choose what we want it to simp to. -/
#simp algebraMap R (FPush R p) r

/- Maybe this? -/
@[simp]
lemma FPush_algebra_map_apply : algebraMap R (FPush R p) r = toFPushRingEquiv R p r ^ p := rfl

#simp algebraMap R (FPush R p) r

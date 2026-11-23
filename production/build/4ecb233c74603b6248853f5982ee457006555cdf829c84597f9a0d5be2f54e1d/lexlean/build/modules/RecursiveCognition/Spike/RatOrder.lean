module
public import Init
public import LexLeanRuntime.Portable
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 1000000000
set_option linter.constructorNameAsVariable false
namespace RecursiveCognition.Spike.RatOrder

public structure RationalScaled where
  numerator : Nat
  denominator : Nat

@[expose] public def oneThird : RationalScaled := ({ numerator := 1, denominator := 3 } : RationalScaled)

@[expose] public def oneHalf : RationalScaled := ({ numerator := 1, denominator := 2 } : RationalScaled)

@[expose] public def ratLt (a : RationalScaled) (b : RationalScaled) : Bool := (Nat.blt ((LexLeanRuntime.multiply ((a).numerator) ((b).denominator) : Nat)) ((LexLeanRuntime.multiply ((b).numerator) ((a).denominator) : Nat)))

public theorem rat_order_helper : (ratLt (oneThird) (oneHalf) = true) := by
  rfl

end RecursiveCognition.Spike.RatOrder

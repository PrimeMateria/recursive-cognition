module
public import Init
public import LexLeanRuntime.Portable
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 1000000000
set_option linter.constructorNameAsVariable false
namespace RecursiveCognition.Spike.DtCbf

public structure DtCbfState where
  hScaled : Nat
  hNextScaled : Nat
  mInterScaled : Nat
  gammaNum : Nat
  gammaDen : Nat

@[expose] public def defaultDtCbfState : DtCbfState := ({ hScaled := 800, hNextScaled := 410, mInterScaled := 10, gammaNum := 1, gammaDen := 2 } : DtCbfState)

@[expose] public def dtCbfHolds (s : DtCbfState) : Bool := (Nat.ble (((LexLeanRuntime.multiply ((LexLeanRuntime.subtract ((s).gammaDen) ((s).gammaNum) : Nat)) ((s).hScaled) : Nat) + (LexLeanRuntime.multiply ((s).gammaDen) ((s).mInterScaled) : Nat))) ((LexLeanRuntime.multiply ((s).gammaDen) ((s).hNextScaled) : Nat)))

public theorem dt_cbf_forward_invariant : (dtCbfHolds (defaultDtCbfState) = true) := by
  rfl

end RecursiveCognition.Spike.DtCbf

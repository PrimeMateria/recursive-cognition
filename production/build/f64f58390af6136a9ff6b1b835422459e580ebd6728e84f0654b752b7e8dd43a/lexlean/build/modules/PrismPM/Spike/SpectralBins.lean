module
public import Init
set_option autoImplicit false
set_option maxRecDepth 100000
set_option maxHeartbeats 1000000000
set_option linter.constructorNameAsVariable false
namespace PrismPM.Spike.SpectralBins

public structure SpectralBin where
  lowerHz : Nat
  upperExclusiveHz : Nat

public structure PrimeBinPartition where
  bin01 : SpectralBin
  bin02 : SpectralBin
  bin03 : SpectralBin
  bin04 : SpectralBin
  bin05 : SpectralBin
  bin06 : SpectralBin
  bin07 : SpectralBin
  bin08 : SpectralBin
  bin09 : SpectralBin
  bin10 : SpectralBin
  bin11 : SpectralBin

@[expose] public def makeBin (lo : Nat) (hi : Nat) : SpectralBin := ({ lowerHz := lo, upperExclusiveHz := hi } : SpectralBin)

@[expose] public def defaultPartition : PrimeBinPartition := ({ bin01 := makeBin (1) (2), bin02 := makeBin (2) (3), bin03 := makeBin (3) (5), bin04 := makeBin (5) (7), bin05 := makeBin (7) (11), bin06 := makeBin (11) (13), bin07 := makeBin (13) (17), bin08 := makeBin (17) (19), bin09 := makeBin (19) (23), bin10 := makeBin (23) (29), bin11 := makeBin (29) (31) } : PrimeBinPartition)

@[expose] public def binLower (b : SpectralBin) : Nat := (b).lowerHz

@[expose] public def binUpper (b : SpectralBin) : Nat := (b).upperExclusiveHz

@[expose] public def binWellFormed (b : SpectralBin) : Bool := (Nat.blt (binLower (b)) (binUpper (b)))

@[expose] public def adjacent (a : SpectralBin) (b : SpectralBin) : Bool := (Nat.beq (binUpper (a)) (binLower (b)))

@[expose] public def isPrimeBoundary (n : Nat) : Bool := ((((((((((Nat.beq (n) (2)) || (Nat.beq (n) (3))) || (Nat.beq (n) (5))) || (Nat.beq (n) (7))) || (Nat.beq (n) (11))) || (Nat.beq (n) (13))) || (Nat.beq (n) (17))) || (Nat.beq (n) (19))) || (Nat.beq (n) (23))) || (Nat.beq (n) (29)))

@[expose] public def primeBinPartitionHolds (p : PrimeBinPartition) : Bool := (((((((((((((((((((((((((((((((((Nat.beq (binLower ((p).bin01)) (1)) && (Nat.beq (binUpper ((p).bin11)) (31))) && binWellFormed ((p).bin01)) && binWellFormed ((p).bin02)) && binWellFormed ((p).bin03)) && binWellFormed ((p).bin04)) && binWellFormed ((p).bin05)) && binWellFormed ((p).bin06)) && binWellFormed ((p).bin07)) && binWellFormed ((p).bin08)) && binWellFormed ((p).bin09)) && binWellFormed ((p).bin10)) && binWellFormed ((p).bin11)) && adjacent ((p).bin01) ((p).bin02)) && adjacent ((p).bin02) ((p).bin03)) && adjacent ((p).bin03) ((p).bin04)) && adjacent ((p).bin04) ((p).bin05)) && adjacent ((p).bin05) ((p).bin06)) && adjacent ((p).bin06) ((p).bin07)) && adjacent ((p).bin07) ((p).bin08)) && adjacent ((p).bin08) ((p).bin09)) && adjacent ((p).bin09) ((p).bin10)) && adjacent ((p).bin10) ((p).bin11)) && isPrimeBoundary (binUpper ((p).bin01))) && isPrimeBoundary (binUpper ((p).bin02))) && isPrimeBoundary (binUpper ((p).bin03))) && isPrimeBoundary (binUpper ((p).bin04))) && isPrimeBoundary (binUpper ((p).bin05))) && isPrimeBoundary (binUpper ((p).bin06))) && isPrimeBoundary (binUpper ((p).bin07))) && isPrimeBoundary (binUpper ((p).bin08))) && isPrimeBoundary (binUpper ((p).bin09))) && isPrimeBoundary (binUpper ((p).bin10)))

public theorem prime_bin_partition : (primeBinPartitionHolds (defaultPartition) = true) := by
  rfl

end PrismPM.Spike.SpectralBins

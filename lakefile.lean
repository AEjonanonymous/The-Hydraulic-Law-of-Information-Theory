import Lake
open Lake DSL

package «TheHydraulicLawOfInformationTheory» where

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git" @ "v4.30.0"

@[default_target]
lean_lib «Deterministic_Law_of_Data_Movement» where
  srcDir := "."

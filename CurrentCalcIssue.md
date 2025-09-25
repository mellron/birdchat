# Current Calculation Issue

## Context
- Project: BSDRateBusiness / BSDRateUI
- Focus: Calculated rate for short name `tenyr10am` and FTP Calculator tab calculations.

## Findings
- `CALCAMORT` formulas invoke `CalculatedRateBuilder.CalculateAmort(term, amort, curveName)` in `BSDRateBusiness/Utilities/CalculatedRateBuilder.vb`. For `tenyr10am` the call is `CALCAMORT(120, 120, "L0P0B360")` using the `L0P0B360` curve.
- `CalculateAmort` loads `L0P0B360` through `_curveBuilder.GetCurve` and, if necessary, calls `CalculateCurveRates` to build it. When the rate table is available, the term-specific FTP value is accessed at `curve.Rows(term - 1)("value")` (line 641).
- `CurveBuilder` has separate spline-generation logic for `L0P0B360` (`BSDRateBusiness/Utilities/CurveBuilder.vb:171-226`). It expands the 29-point `L0P0B` source into a 360-point monthly curve **without** the day-one element; terms are stored as integers 1..360.
- The FTP Calculator tab (`BSDRateUI/Calculators/CalculatorsForm.vb`) relies on `FTPRateCalculator.COF`, which ultimately calls `Calculator.CalculateStandardCOF`. That method, in `BSDRateBusiness/Calculators/Calculator.vb:309-420`, pulls the `L0P0BFULL` curve. If the full 361-point curve is not cached, it is built from the same 29-point `L0P0B` base but inserts a day-one value at term `1/30` plus monthly terms 1..360.

## Implication
- CALCAMORT-based calculations (e.g., `tenyr10am`) and FTP calculator COF results use curves generated from the same base (`L0P0B`) but different spline-build routines (`L0P0B360` vs `L0P0BFULL`). The presence of the day-one point in `L0P0BFULL` and its absence in `L0P0B360` can produce mismatched cost-of-funds inputs. Any investigation comparing FTP Calculator COF outputs to CALCAMORT results must account for the curve variant being used.

## Next Steps
1. Confirm whether the differing spline constructions are intentional for CALCAMORT vs FTP COF. If alignment is needed, evaluate modifying `CalculateAmort` or the curve builder to consume the same curve variant.
2. If parity is required, consider generating both curves from a shared helper to ensure consistent term sets and interpolation rules.
3. Document the curve-selection behavior for analysts using BSDRate calculators to avoid confusion when reconciling COF values.

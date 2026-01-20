# BSDRate.Tests - Unit Test Project

## Overview

This project contains unit tests for validating the TPP-9855 changes to `CalculatorsForm.vb`. The tests verify that the `String.IsNullOrWhiteSpace` validation logic works correctly for the Spread and All-In Cust. Rate fields.

## What Was Added

### Files Created

| File | Description |
|------|-------------|
| `BSDRate.Tests/BSDRate.Tests.csproj` | C# Console Application project targeting .NET Framework 4.5 |
| `BSDRate.Tests/Program.cs` | Test runner with validation test cases |
| `BSDRate.Tests/UnitTest.md` | This documentation file |

### Solution Changes

- `BSDRate.sln` updated to include the `BSDRate.Tests` project

## TPP-9855 Changes Being Tested

The TPP-9855 story modified validation logic in `CalculatorsForm.vb` for four calculator tabs:
- FHLB360
- FTP
- CIP
- ALS

### Key Changes

1. **Replaced** `String.Empty` checks with `String.IsNullOrWhiteSpace()` for robust empty/whitespace detection
2. **Added** user notification (MessageBox) when both Spread and All-In Cust. Rate are filled
3. **Validation Rule**: Exactly one of Spread or All-In Cust. Rate must be filled (XOR logic)

## Test Cases

| # | Test Name | Spread Input | Rate Input | Expected Result |
|---|-----------|--------------|------------|-----------------|
| 1 | Only Spread filled | `"1.5"` | `""` | Valid |
| 2 | Only Rate filled | `""` | `"5.25"` | Valid |
| 3 | Both filled | `"1.5"` | `"5.25"` | Invalid |
| 4 | Neither filled | `""` | `""` | Invalid |
| 5 | Whitespace Spread + Rate (TPP-9855) | `"   "` | `"5.25"` | Valid |
| 6 | Tab+Spaces Spread + Rate (TPP-9855) | `"\t  "` | `"5.25"` | Valid |
| 7 | Only whitespace in both | `" "` | `"  "` | Invalid |
| 8 | Null Spread + Rate | `null` | `"5.25"` | Valid |
| 9 | Both null | `null` | `null` | Invalid |
| 10 | Complex whitespace + Rate | `"  \t\n  "` | `"3.75"` | Valid |

Tests 5, 6, 8, and 10 specifically validate the TPP-9855 fix where whitespace-only strings are now correctly treated as empty.

## How to Build

### Visual Studio

1. Open `BSDRate.sln` in Visual Studio
2. Right-click on `BSDRate.Tests` project in Solution Explorer
3. Select **Build**

### Command Line (MSBuild)

```cmd
msbuild BSDRate.Tests\BSDRate.Tests.csproj /p:Configuration=Debug
```

## How to Run Tests

### From Visual Studio

1. Build the project
2. Press `Ctrl+F5` to run without debugging, or
3. Set `BSDRate.Tests` as startup project and press `F5`

### From Command Line

```cmd
BSDRate.Tests\bin\Debug\BSDRate.Tests.exe
```

## Expected Output

```
TPP-9855 Validation Tests
=========================

Testing String.IsNullOrWhiteSpace validation for Spread/All-In Cust. Rate fields

  [PASS] Only Spread filled
  [PASS] Only Rate filled
  [PASS] Both filled
  [PASS] Neither filled
  [PASS] Whitespace Spread + Rate (TPP-9855)
  [PASS] Tab+Spaces Spread + Rate (TPP-9855)
  [PASS] Only whitespace in both
  [PASS] Null Spread + Rate
  [PASS] Both null
  [PASS] Complex whitespace + Rate

=========================
Results: 10 passed, 0 failed

ALL TESTS PASSED

Press any key to exit...
```

## Validation Logic

The test mirrors the validation logic from `CalculatorsForm.vb`:

```csharp
bool spreadFilled = !string.IsNullOrWhiteSpace(spread);
bool rateFilled = !string.IsNullOrWhiteSpace(rate);
bool isValid = spreadFilled ^ rateFilled;  // XOR - exactly one must be filled
```

This ensures:
- If only Spread is filled → Valid (calculates Rate)
- If only Rate is filled → Valid (calculates Spread)
- If both are filled → Invalid (shows error message)
- If neither is filled → Invalid (no calculation performed)

## Related Story

- **Story**: TPP-9855
- **Description**: Fixed validation logic for Spread and All-In Cust. Rate fields
- **Modified File**: `BSDRateUI/Calculators/CalculatorsForm.vb`

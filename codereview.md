# Code Review — `RunBestFitAutoAllocation`

**Date:** 2025-08-20  
**Scope:** Review of T-SQL stored procedure `dbo.RunBestFitAutoAllocation`

---

## Summary
Overall, the procedure implements a two-phase “best fit” ticket selection for pledging/unpledging. There are several correctness risks, transaction-handling concerns, and type inconsistencies that could lead to failures or non-deterministic behavior. Below are prioritized findings with concrete fixes.

---

## Highest-Impact Issues (Fix First)

1. **Open transaction on early `RETURN`**
   - You begin a transaction before validating inputs. The “Not a valid pledge detail id” branch issues a `RETURN` without `COMMIT/ROLLBACK` → leaves the transaction open.
   - **Fix:**
     ```sql
     SET XACT_ABORT ON; -- at top of the proc (recommended)

     IF ISNULL(@PldgCd,'')='' OR ISNULL(@Cusip,'')='' OR ISNULL(@Amt,0)=0
     BEGIN
         EXEC InsertAutoAlgorithmLog @Header,'ERROR','Not a valid pledge detail id','Not a valid pledge detail id';
         ROLLBACK TRANSACTION; -- ensure cleanup
         RETURN;
     END
     ```

2. **Type mismatch for `@FirstTotAmt` used in arithmetic**
   - Declared as `VARCHAR(MAX)` but used in `@RemAmt = @Amt - @FirstTotAmt`. This relies on implicit conversion and may error or truncate.
   - **Fix:** declare numeric and null-safe math.
     ```sql
     DECLARE @FirstTotAmt DECIMAL(20,4) = 0; -- not VARCHAR

     SELECT TOP (1)
       @SelectedTicketsAmt = AvailableAmtCombination,
       @FirstSelTickets    = TicketCombination,
       @FirstTotAmt        = ISNULL(TotalAmount,0)
     FROM @FirstBestFitTicketsCombinations;

     SET @RemAmt = ISNULL(@Amt,0) - ISNULL(@FirstTotAmt,0);
     ```

3. **Wrong variable in error message**
   - You compare `@Amt` to `@TotUnpledgedAmt` but log `@TargetAmt` (NULL in normal runs).
   - **Fix:**
     ```sql
     UPDATE AutoAlgorithmLog
     SET LogStatus='Failed',
         ErrorMessage='Amount to be pledged ('+CAST(ISNULL(@Amt,0) AS VARCHAR(50))+') exceeds the available face ('+CAST(ISNULL(@TotUnpledgedAmt,0) AS VARCHAR(50))+')'
     WHERE Id=@AlgorithmId;
     ```

4. **Non-deterministic `TOP 1` selections**
   - Several `TOP 1` queries have no `ORDER BY`. This can pick arbitrary combinations or `NULL` values.
   - **Fix:** add business-rule-aligned ordering (example):
     ```sql
     SELECT TOP (1)
       @SelectedTickets    = COALESCE(NULLIF(@SelectedTickets,'' ) + ',', '') + TicketCombination,
       @SelectedTicketsAmt = COALESCE(NULLIF(@SelectedTicketsAmt,'') + ',', '') + AvailableAmtCombination
     FROM @AutoAllocationTicketCombinations
     ORDER BY RankingPercent DESC, Overage ASC, TotalAmount DESC;
     ```

5. **Currency precision drift (`MONEY` vs `DECIMAL`)**
   - Mixed use of `MONEY` and `DECIMAL(18,2)` risks rounding inconsistencies.
   - **Fix:** standardize on `DECIMAL(19,4)` (or your org standard) for all amounts and temp columns.

---

## Logic & Robustness

6. **Redundant assignment**
   - `SET @SelectedTicketsAmt = @SelectedTicketsAmt` is a no-op. Remove it.

7. **Null-safety when phase 1 returns no rows**
   - If `@FirstBestFitTicketsCombinations` is empty, subsequent math and splits can be `NULL`.
   - **Fix:** use `ISNULL` defaults (see #2) and branch to phase 2 for full amount when phase 1 returns nothing.

8. **Trim when splitting and ensure dense ordinals**
   - `fnSplitString` values may include whitespace. Also ensure ordinals are dense 1..N to align amounts to tickets.
   - **Fix:**
     ```sql
     SELECT Ordinal, CAST(LTRIM(RTRIM([Value])) AS INT)
     FROM dbo.fnSplitString(@SelectedTickets, ',');

     SELECT Ordinal, CAST(LTRIM(RTRIM([Value])) AS DECIMAL(19,4))
     FROM dbo.fnSplitString(@SelectedTicketsAmt, ',');
     ```

9. **Insert timestamps differ between pledge/unpledge**
   - Pledging uses `@PldgDt` (based on `GETDATE()` or migration target); unpledging uses `GETDATE()` directly. Confirm the intended rule and align if needed.

10. **Failure path continues execution**
    - After setting `LogStatus='Failed'` for insufficient unpledged face, the proc continues. Consider exiting early.
    - **Fix (optional):**
      ```sql
      IF (@Amt > @TotUnpledgedAmt)
      BEGIN
          UPDATE AutoAlgorithmLog ...;
          ROLLBACK TRANSACTION; -- or COMMIT if you want a “logged failure” without changes
          RETURN;
      END
      ```

11. **Potential join multiplicity in `INSERT INTO TicketDtl`**
    - The long join chain can duplicate rows if upstream tables aren’t one-to-one. If not guaranteed by constraints, add guards (e.g., `DISTINCT`) or validate uniqueness.

12. **Deterministic unpledging order**
    - Current ORDER BY may still tie; add tie-breakers (e.g., `TicketNo`) to ensure stable allocation.

13. **Cursor in unpledging**
    - Can be converted to a set-based window approach for performance/clarity (future refactor).

---

## Unused Variables (remove)

- `@TicketHeldBlkId`
- `@SelTickets`
- `@FirstUsedAmt`
- `@LOGStatus`

Removing these reduces noise and confusion.

---

## Suggested Patchlets

**A) Transaction & CATCH with error logging**
```sql
SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    -- ... body ...

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

    DECLARE @ErrMsg NVARCHAR(4000)=ERROR_MESSAGE(),
            @ErrNum INT=ERROR_NUMBER(),
            @ErrSev INT=ERROR_SEVERITY(),
            @ErrSta INT=ERROR_STATE(),
            @ErrLine INT=ERROR_LINE(),
            @ErrProc NVARCHAR(200)=ERROR_PROCEDURE();

    IF @AlgorithmId IS NOT NULL
    BEGIN
        UPDATE AutoAlgorithmLog
        SET LogStatus='Failed',
            ErrorMessage=CONCAT('Err ',@ErrNum,' (',@ErrSev,'/',@ErrSta,') at line ',@ErrLine,' in ',ISNULL(@ErrProc,'<adhoc>')),
            LogMessage=@ErrMsg
        WHERE Id=@AlgorithmId;
    END
END CATCH
```

**B) Standardize amount types**  
Change `@Amt`, `@RemAmt`, `@FirstTotAmt`, temp-table amount columns, and `@TicketsAmt.[Value]` to `DECIMAL(19,4)`.

**C) Deterministic picks**  
Add `ORDER BY` to all `TOP (1)` selections using your defined ranking: `RankingPercent DESC, Overage ASC, TotalAmount DESC` (or the correct business rule).

---

## Nice-to-Haves

- Schema-qualify all objects (e.g., `dbo.vwPledgeTicketDtl`) for plan stability.
- Validate `@RunType` to accepted values early.
- Replace magic literals (`'Unpledged'`, `'System'`) with constants/config if reused.
- Consider moving ticket/amount lists to TVPs to avoid string-splitting entirely.

---

## Final Thought
Address the five high-impact items first. That will eliminate transaction leaks, type pitfalls, and non-deterministic picks—the main sources of bugs in this routine—while keeping behavior stable.

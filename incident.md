# Incident Report: SSIS Load Ticket Holding Failure

**Date/Time:** 2025-08-26 02:30 AM  
**System:** CPMS  
**Process:** SSIS Package `cpmsipcusdskholdloc.dtsx` → Stored Procedure `[dbo].[SSISLoadTicketHolding]`  
**Error:** Foreign Key Constraint Violation (`FK_TicketDtl_TicketHolding`)

---

## Summary
The nightly SSIS job `cpmsipcusdskholdloc` failed while executing the stored procedure `[dbo].[SSISLoadTicketHolding]`.  
The failure occurred during the **DELETE operation** on the `TicketHolding` table due to a **foreign key constraint violation** with the `TicketDtl` table.

---

## Impact
- SSIS package terminated with `DTSER_FAILURE (1)`.  
- Ticket holding records for process date **2025-08-25** were not fully updated.  
- Downstream reporting may reflect stale or inconsistent ticket holding information.  

---

## Technical Details
### Error Message (from SSIS log):
```
The DELETE statement conflicted with the REFERENCE constraint "FK_TicketDtl_TicketHolding".
The conflict occurred in database "CPMS", table "dbo.TicketDtl", column 'TicketHeldBlkId'.
```

### Root Cause
1. The stored procedure identifies “dropped” tickets with **no pledges** and attempts to **DELETE them from `TicketHolding`**.  
2. However, some of those ticket holdings still have related rows in **`TicketDtl`** (child table).  
3. The foreign key constraint `FK_TicketDtl_TicketHolding` prevents deleting a parent row in `TicketHolding` while children exist in `TicketDtl`.  
4. As a result, the DELETE fails and the entire SSIS package aborts.

### Relationship Diagram
```
TicketHolding (Parent)        TicketDtl (Child)
---------------------         -----------------
TicketHeldBlk   <----------   TicketHeldBlkId
Ticket
SfkpAcctID                     TicketDtlId
                               (other columns)
```

---

## Evidence
- Rows logged in `PledgedUnavailableTicket` for `AsOfDate = 2025-08-25` show tickets dropped with *“no pledges”* branch.  
- Example:  
  - Ticket `403012154`  
  - Ticket `403012155`  
- These holdings still have child records in `TicketDtl`, which triggered the FK violation.

---

## Resolution Plan
**Short-term mitigation:**
- Modify `[SSISLoadTicketHolding]` to handle “dropped & no pledges” rows safely:
  - If **no children in `TicketDtl`** → hard delete from `TicketHolding`.  
  - If **children exist** → retain the holding row and zero out `Amt`, `CurrentFace`, `MarketValue`.  

**Long-term fixes:**
- Add diagnostic logging for tickets skipped/zeroed due to children.  
- Evaluate business rules:  
  - If `TicketDtl` detail is only derivative, consider enabling `ON DELETE CASCADE` on the FK.  
  - Otherwise, preserve details by avoiding deletes when children exist.  

---

## Next Steps
- Patch stored procedure to apply orphan-vs-child logic.  
- Re-run job for process date `2025-08-25`.  
- Verify downstream reports.  
- Review whether constraint should allow cascade deletes or always enforce zero-out approach.

---


---

## Step-by-step Summary (Plain English)

1. **`dbo.TicketHolding` is the parent table** (primary key: `TicketHeldBlk`).  
2. **`dbo.TicketDtl` is the child table** with a foreign key column `TicketHeldBlkId` → `TicketHolding.TicketHeldBlk`.  
3. In the **“dropped & no pledges”** branch, the procedure tries to **DELETE** from `TicketHolding`.  
4. If **any child rows** exist in `dbo.TicketDtl` that still point to that parent, SQL Server **blocks the delete** to preserve referential integrity.

**Summary**
- ✅ If a holding **has no children**, the delete **succeeds**.  
- ❌ If a holding **has children**, the delete **fails** with the FK error.  

**Fix Options**
- **Preferred:** Zero out those holdings (set `Amt`, `CurrentFace`, `MarketValue` to 0) instead of deleting when children exist.  
- **Alternative:** Switch the foreign key to **`ON DELETE CASCADE`** (only if it’s acceptable to delete the related detail rows in `TicketDtl`).

---

**Status:** Open (awaiting stored procedure patch)  
**Owner:** [Assign DBA / Developer Name]  
**Priority:** High (blocks nightly load)  

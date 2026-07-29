/*=============================================================================
  INC30712391 — ROLLBACK VERIFICATION  (post-implementation check)
  Read-only. Run AFTER INC30712391_rollback.sql.

  HOW IT WORKS: the deploy (INC30712391_DEPLOY.sql) embeds 'INC30712391' fix
  markers INSIDE each object's body; the original (pre-fix) bodies contain none.
  So marker absent = object reverted to original.

  PASS  = all 3 rows show Status 'REVERTED (ok)', FixMarkerCount 0, and a
          modify_date matching the rollback run time.
  FAIL  = any row shows 'STILL FIXED - ROLLBACK FAILED' (marker still present)
          or 'OBJECT MISSING'.

  TIP: run this BEFORE the rollback too — it should read 'STILL FIXED' for all 3
       (proof the deploy is in and there is something to revert), then 'REVERTED'
       after. Same query serves as the before/after evidence for the CR.
=============================================================================*/

;WITH expected(name) AS (
    VALUES ('spInsertValsToAdjValTemp'),
           ('vw_curr_InTraderOps1'),
           ('vw_hist_InTraderOps1')
)
SELECT
    ObjectName     = 'dbo.' + e.name,
    Present        = CASE WHEN o.object_id IS NULL THEN 'MISSING' ELSE o.type_desc END,
    o.modify_date,                                   -- should equal the rollback run time
    FixMarkerCount = ISNULL(
                        (LEN(m.definition) - LEN(REPLACE(m.definition,'INC30712391','')))
                        / LEN('INC30712391'), 0),     -- occurrences of 'INC30712391' in the body
    Status         = CASE
                        WHEN o.object_id IS NULL              THEN '*** OBJECT MISSING ***'
                        WHEN m.definition LIKE '%INC30712391%' THEN '*** STILL FIXED - ROLLBACK FAILED ***'
                        ELSE 'REVERTED (ok)'
                     END
FROM        expected e
LEFT JOIN   sys.objects     o ON o.name = e.name AND o.schema_id = SCHEMA_ID('dbo')
LEFT JOIN   sys.sql_modules m ON m.object_id = o.object_id
ORDER BY    e.name;

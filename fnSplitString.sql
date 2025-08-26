-- A) What @ProcessDt would the proc use?
DECLARE @ProcessDt DATETIME = (SELECT MAX(processdate) FROM InputData.IPCUSDHoldings);
SELECT @ProcessDt AS ProcessDt;

-- B) Recompute the proc’s "#TicketsDropped" candidate set (the ones it wants to DELETE)
;WITH PledgeAgg AS (
    SELECT
        cusip,
        ticket,
        locationid,
        acctcode,
        SUM(originalface) AS originalface,
        SUM(CASE WHEN pldgcode = 'Unpledged' THEN originalface ELSE 0 END) AS unpledgedamt,
        SUM(CASE WHEN pldgcode = 'Unpledged' THEN 0 ELSE originalface END) AS pledgedamt
    FROM dbo.vwPledgeTicketDtl
    GROUP BY cusip, ticket, locationid, acctcode
),
TicketHoldingSource AS (
    SELECT
        th.Ticket,
        sa.SfkpId AS locationid,
        th.SfkpAcctID,
        th.TicketHeldBlk
    FROM dbo.TicketHolding th
    JOIN dbo.tblSfkpAcct sa ON sa.SfkpAcctID = th.SfkpAcctID
)
SELECT
    d.cusip, d.ticket, d.locationid, d.acctcode,
    d.originalface, d.pledgedamt, d.unpledgedamt,
    s.TicketHeldBlk, s.SfkpAcctID
INTO #ToRemove
FROM PledgeAgg d
LEFT JOIN TicketHoldingSource s
       ON s.ticket = d.ticket AND s.locationid = d.locationid
WHERE s.ticket IS NOT NULL      -- there is a holding row
  AND ISNULL(d.pledgedamt,0) = 0;  -- the proc will try to DELETE these

-- C) Which of those rows have children in TicketDtl (=> will fail)?
SELECT r.*, COUNT(td.TicketDtlId) AS ChildRowCount
FROM #ToRemove r
JOIN dbo.TicketDtl td ON td.TicketHeldBlkId = r.TicketHeldBlk
GROUP BY r.cusip, r.ticket, r.locationid, r.acctcode, r.originalface, r.pledgedamt, r.unpledgedamt, r.TicketHeldBlk, r.SfkpAcctID
ORDER BY ChildRowCount DESC;

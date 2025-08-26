/* 0) What date would the procedure use? */
DECLARE @ProcessDt DATETIME = (SELECT MAX(processdate) FROM InputData.IPCUSDHoldings);
SELECT @ProcessDt AS ProcessDt;

/* 1) Rebuild the same file-derived #TicketHolding that the proc builds (no table abbreviations) */
IF OBJECT_ID('tempdb..#TicketHolding_File') IS NOT NULL DROP TABLE #TicketHolding_File;

SELECT *
INTO #TicketHolding_File
FROM (
    /* Non-split rows from vwIntraderTicketData */
    SELECT
        vwIntraderTicketData.Ticket,
        vwIntraderTicketData.SfkpId AS locationid,
        COALESCE(
            tblSfkpAcct.SfkpAcctId,
            (SELECT SfkpAcctId
             FROM dbo.tblSfkpAcct
             WHERE tblSfkpAcct.LEID = '010' AND tblSfkpAcct.SfkpId = vwIntraderTicketData.SfkpId)
        ) AS SfkpAcctId,
        vwIntraderTicketData.OriginalFace,
        CASE WHEN ISNULL(vwIntraderTicketData.USBNAFlag,'') = '' THEN 0 ELSE 1 END AS USB,
        GETDATE() AS RecordedAddedDateTime,
        vwIntraderTicketData.currentface,
        vwIntraderTicketData.marketvalue
    FROM dbo.vwIntraderTicketData
    LEFT JOIN dbo.tblSfkpAcct
      ON tblSfkpAcct.SfkpId = vwIntraderTicketData.SfkpId
     AND tblSfkpAcct.LEID = dbo.fnGetLegalEntityId(vwIntraderTicketData.Portfolio)
    WHERE vwIntraderTicketData.processdate = @ProcessDt
      AND vwIntraderTicketData.sfkpid <> 'split'

    UNION ALL

    /* Split rows joined to IPCUSDskholdloc and tblScrty */
    SELECT
        vwIntraderTicketData.Ticket,
        IPCUSDskholdloc.skcode AS locationid,
        COALESCE(
            tblSfkpAcct.SfkpAcctId,
            (SELECT SfkpAcctId
             FROM dbo.tblSfkpAcct
             WHERE tblSfkpAcct.LEID = '010' AND tblSfkpAcct.SfkpId = IPCUSDskholdloc.skcode)
        ) AS SfkpAcctId,
        IPCUSDskholdloc.ParOriginalFace AS OriginalFace,
        CASE WHEN ISNULL(vwIntraderTicketData.USBNAFlag,'') = '' THEN 0 ELSE 1 END AS USB,
        GETDATE() AS RecordedAddedDateTime,
        IPCUSDskholdloc.currentface,
        (IPCUSDskholdloc.ParOriginalFace * tblScrty.ParFact * tblScrty.MktPrc) AS marketvalue
    FROM dbo.vwIntraderTicketData
    INNER JOIN InputData.IPCUSDskholdloc
            ON CAST(IPCUSDskholdloc.ticket AS INT) = CAST(vwIntraderTicketData.ticket AS INT)
    INNER JOIN dbo.tblScrty
            ON vwIntraderTicketData.cusip = tblScrty.cusip
    LEFT JOIN dbo.tblSfkpAcct
           ON IPCUSDskholdloc.skcode = tblSfkpAcct.SfkpId
          AND tblSfkpAcct.LEID = dbo.fnGetLegalEntityId(vwIntraderTicketData.Portfolio)
    WHERE vwIntraderTicketData.sfkpid = 'split'
      AND vwIntraderTicketData.processdate = @ProcessDt
      AND IPCUSDskholdloc.processdate = @ProcessDt
) AS TicketHolding_File;

/* 2) Aggregate pledge detail exactly like the proc does */
WITH PledgeAggregate AS (
    SELECT
        dbo.vwPledgeTicketDtl.cusip,
        dbo.vwPledgeTicketDtl.ticket,
        dbo.vwPledgeTicketDtl.locationid,
        dbo.vwPledgeTicketDtl.acctcode,
        SUM(dbo.vwPledgeTicketDtl.originalface) AS originalface,
        SUM(CASE WHEN dbo.vwPledgeTicketDtl.pldgcode = 'Unpledged'
                 THEN dbo.vwPledgeTicketDtl.originalface ELSE 0 END) AS unpledgedamt,
        SUM(CASE WHEN dbo.vwPledgeTicketDtl.pldgcode = 'Unpledged'
                 THEN 0 ELSE dbo.vwPledgeTicketDtl.originalface END) AS pledgedamt
    FROM dbo.vwPledgeTicketDtl
    GROUP BY dbo.vwPledgeTicketDtl.cusip,
             dbo.vwPledgeTicketDtl.ticket,
             dbo.vwPledgeTicketDtl.locationid,
             dbo.vwPledgeTicketDtl.acctcode
),

/* 3) Tickets considered "dropped": present in pledge detail but NOT in today's file-derived #TicketHolding */
DroppedTickets AS (
    SELECT PledgeAggregate.*
    FROM PledgeAggregate
    LEFT JOIN #TicketHolding_File
           ON #TicketHolding_File.ticket = PledgeAggregate.ticket
          AND #TicketHolding_File.locationid = PledgeAggregate.locationid
    WHERE #TicketHolding_File.ticket IS NULL
),

/* 4) Map those dropped tickets to existing rows in the persistent table dbo.TicketHolding */
TargetsForDelete AS (
    SELECT
        DroppedTickets.cusip,
        DroppedTickets.ticket,
        DroppedTickets.locationid,
        DroppedTickets.acctcode,
        DroppedTickets.originalface,
        DroppedTickets.pledgedamt,
        DroppedTickets.unpledgedamt,
        dbo.TicketHolding.TicketHeldBlk,
        dbo.TicketHolding.SfkpAcctID
    FROM DroppedTickets
    INNER JOIN dbo.tblSfkpAcct
            ON tblSfkpAcct.SfkpId = DroppedTickets.locationid
    INNER JOIN dbo.TicketHolding
            ON TicketHolding.Ticket = DroppedTickets.ticket
           AND TicketHolding.SfkpAcctID = tblSfkpAcct.SfkpAcctID
    WHERE ISNULL(DroppedTickets.pledgedamt, 0) = 0  /* "no pledges" branch = DELETE in the proc */
)

/* 5) Final result: everything the proc intends to DELETE, with child counts (which will cause FK failures) */
SELECT
    TargetsForDelete.cusip,
    TargetsForDelete.ticket,
    TargetsForDelete.locationid,
    TargetsForDelete.acctcode,
    TargetsForDelete.originalface,
    TargetsForDelete.pledgedamt,
    TargetsForDelete.unpledgedamt,
    TargetsForDelete.TicketHeldBlk,
    TargetsForDelete.SfkpAcctID,
    COUNT(dbo.TicketDtl.TicketDtlId) AS ChildRowCount
FROM TargetsForDelete
LEFT JOIN dbo.TicketDtl
       ON dbo.TicketDtl.TicketHeldBlkId = TargetsForDelete.TicketHeldBlk
GROUP BY
    TargetsForDelete.cusip,
    TargetsForDelete.ticket,
    TargetsForDelete.locationid,
    TargetsForDelete.acctcode,
    TargetsForDelete.originalface,
    TargetsForDelete.pledgedamt,
    TargetsForDelete.unpledgedamt,
    TargetsForDelete.TicketHeldBlk,
    TargetsForDelete.SfkpAcctID
ORDER BY ChildRowCount DESC, TargetsForDelete.ticket, TargetsForDelete.locationid;

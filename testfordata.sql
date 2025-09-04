/*
  testdates.sql

  Purpose: Find usable dates for staging DBC/DB2 curves.

  Contains two queries:
    1) Latest date where ALL DBC/DB2 ExportRateIDs have a verified calendar row
       and a value on/before that date (calculated or source, per BaseRateType).
    2) Top 10 candidate dates with counts of how many rates can stage.

  Usage: Run as-is. Optionally wrap in your favorite tooling. No writes.
*/

/* ======================================================================= */
/* 1) Latest fully-ready date (all rates have values and verified calendar) */
/* ======================================================================= */

;with DBCDB2 as (
  select erd.ExportRateID, erd.BaseRateType, erd.BaseRateID
  from ExportRateDefinitions erd
  join LExportTypes et on et.IID = erd.ExportTypeID and et.Code in ('DBC','DB2')
),
Eligible as (
  select d.ExportRateID, d.BaseRateType, d.BaseRateID, ec.ProcessDate
  from DBCDB2 d
  join ExportRateCalendar ec
    on ec.ExportRateID = d.ExportRateID
   and ec.VerifiedBy is not null
),
Status as (
  select e.ProcessDate, e.ExportRateID,
         HasValue =
           case when e.BaseRateType = 'C' and exists (
                    select 1
                    from CalculatedRateValues crv
                    where crv.CalculatedRateID = e.BaseRateID
                      and crv.CalculatedDate <= e.ProcessDate)
                then 1
                when e.BaseRateType = 'S' and exists (
                    select 1
                    from SourceRateValues srv
                    where srv.SourceRateID = e.BaseRateID
                      and srv.RateDate <= e.ProcessDate)
                then 1
                else 0
           end
  from Eligible e
)
select top (1) s.ProcessDate as LatestReadyDate
from Status s
group by s.ProcessDate
having sum(case when s.HasValue = 1 then 0 else 1 end) = 0
order by s.ProcessDate desc;

/* ======================================================================= */
/* 2) Top 10 candidate dates with readiness counts                         */
/* ======================================================================= */

;with DBCDB2 as (
  select erd.ExportRateID, erd.BaseRateType, erd.BaseRateID
  from ExportRateDefinitions erd
  join LExportTypes et on et.IID = erd.ExportTypeID and et.Code in ('DBC','DB2')
),
Eligible as (
  select d.ExportRateID, d.BaseRateType, d.BaseRateID, ec.ProcessDate
  from DBCDB2 d
  join ExportRateCalendar ec
    on ec.ExportRateID = d.ExportRateID
   and ec.VerifiedBy is not null
),
Status as (
  select e.ProcessDate, e.ExportRateID,
         HasValue =
           case when e.BaseRateType = 'C' and exists (
                    select 1 from CalculatedRateValues
                    where CalculatedRateID = e.BaseRateID and CalculatedDate <= e.ProcessDate)
                then 1
                when e.BaseRateType = 'S' and exists (
                    select 1 from SourceRateValues
                    where SourceRateID = e.BaseRateID and RateDate <= e.ProcessDate)
                then 1
                else 0
           end
  from Eligible e
)
select top (10)
  s.ProcessDate,
  ReadyCount = sum(case when s.HasValue = 1 then 1 else 0 end),
  TotalRates = count(*)
from Status s
group by s.ProcessDate
order by s.ProcessDate desc;


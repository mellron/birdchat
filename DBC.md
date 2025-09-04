# DBC/DB2 Staging Quick Checks

These checks validate prerequisites for `dbo.SSISStageAnnualRatesForDBC` to populate `ExportRateValues` for export type codes `DBC` and `DB2` on a given `@exportDate`.

> Tip: Define the date once for all queries.
>
> ```sql
> DECLARE @exportDate date = '2025-08-31'; -- set to target export date
> ```

## Required Objects

- `LExportTypes`: Must contain rows with `Code in ('DBC','DB2')`.
- `ExportRateDefinitions`: Definitions for those export types, with valid `BaseRateType` and `BaseRateID`.
- `ExportRateCalendar`: A verified row per `ExportRateID` where `ProcessDate = @exportDate`.
- Value sources on/before `@exportDate`:
  - `CalculatedRateValues` for `BaseRateType = 'C'` (by `CalculatedRateID = BaseRateID`).
  - `SourceRateValues` for `BaseRateType = 'S'` (by `SourceRateID = BaseRateID`).

## Quick Checks

1) Export type codes exist

```sql
select Code, IID
from LExportTypes
where Code in ('DBC','DB2');
```

2) Definitions under DBC/DB2

```sql
select erd.ExportRateID, erd.ShortName, erd.BaseRateType, erd.BaseRateID, erd.TerminationDate
from ExportRateDefinitions erd
join LExportTypes et on et.IID = erd.ExportTypeID and et.Code in ('DBC','DB2')
order by erd.ShortName;
```

3) Calendar gate (missing or unverified for @exportDate)

```sql
select erd.ExportRateID, erd.ShortName, erc.ProcessDate, erc.VerifiedBy
from ExportRateDefinitions erd
join LExportTypes et on et.IID = erd.ExportTypeID and et.Code in ('DBC','DB2')
left join ExportRateCalendar erc
  on erc.ExportRateID = erd.ExportRateID
 and erc.ProcessDate = @exportDate
where erc.VerifiedBy is null;  -- if any rows return, staging will skip those IDs
```

4) Missing calculated values on/before date

```sql
select erd.ExportRateID, erd.ShortName, erd.BaseRateID
from ExportRateDefinitions erd
join LExportTypes et on et.IID = erd.ExportTypeID and et.Code in ('DBC','DB2')
where erd.BaseRateType = 'C'
  and isnull(erd.TerminationDate, @exportDate) <= @exportDate
  and not exists (
        select 1
        from CalculatedRateValues crv
        where crv.CalculatedRateID = erd.BaseRateID
          and crv.CalculatedDate <= @exportDate
  );
```

5) Missing source values on/before date

```sql
select erd.ExportRateID, erd.ShortName, erd.BaseRateID
from ExportRateDefinitions erd
join LExportTypes et on et.IID = erd.ExportTypeID and et.Code in ('DBC','DB2')
where erd.BaseRateType = 'S'
  and isnull(erd.TerminationDate, @exportDate) <= @exportDate
  and not exists (
        select 1
        from SourceRateValues srv
        where srv.SourceRateID = erd.BaseRateID
          and srv.RateDate <= @exportDate
  );
```

6) Rows that would be deleted on run (existing staged rows for date)

```sql
select count(*) as RowsToDelete
from ExportRateValues erv
join ExportRateDefinitions erd on erd.ExportRateID = erv.ExportRateID
join LExportTypes et on et.IID = erd.ExportTypeID and et.Code in ('DBC','DB2')
where erv.ExportDate = @exportDate;
```

## Preview Staging (No Writes)

Calculated-rate rows that would be inserted:

```sql
select
    erd.ExportRateID,
    ExportDate   = erc.ProcessDate,
    EffectiveDate= erc.EffectiveDate,
    RateDate     = crv.CalculatedDate,
    Value        = crv.Value
from ExportRateDefinitions erd
join LExportTypes et
  on et.IID = erd.ExportTypeID and et.Code in ('DBC','DB2')
join ExportRateCalendar erc
  on erc.ExportRateID = erd.ExportRateID
 and erc.ProcessDate = @exportDate
 and erc.VerifiedBy is not null
join CalculatedRateValues crv
  on crv.CalculatedRateID = erd.BaseRateID
 and crv.CalculatedDate = (
        select max(CalculatedDate)
        from CalculatedRateValues
        where CalculatedRateID = erd.BaseRateID
          and CalculatedDate <= @exportDate)
where erd.BaseRateType = 'C'
  and isnull(erd.TerminationDate, @exportDate) <= @exportDate
order by erd.ExportRateID;
```

Source-rate rows that would be inserted:

```sql
select
    erd.ExportRateID,
    ExportDate   = erc.ProcessDate,
    EffectiveDate= erc.EffectiveDate,
    RateDate     = srv.RateDate,
    Value        = srv.Value
from ExportRateDefinitions erd
join LExportTypes et
  on et.IID = erd.ExportTypeID and et.Code in ('DBC','DB2')
join ExportRateCalendar erc
  on erc.ExportRateID = erd.ExportRateID
 and erc.ProcessDate = @exportDate
 and erc.VerifiedBy is not null
join SourceRateValues srv
  on srv.SourceRateID = erd.BaseRateID
 and srv.RateDate = (
        select max(RateDate)
        from SourceRateValues
        where SourceRateID = erd.BaseRateID
          and RateDate <= @exportDate)
where erd.BaseRateType = 'S'
  and isnull(erd.TerminationDate, @exportDate) <= @exportDate
order by erd.ExportRateID;
```

## Post-Run Verification

- Count rows staged:

```sql
select et.Code as ExportType, count(*) as RowsInserted
from ExportRateValues erv
join ExportRateDefinitions erd on erd.ExportRateID = erv.ExportRateID
join LExportTypes et on et.IID = erd.ExportTypeID and et.Code in ('DBC','DB2')
where erv.ExportDate = @exportDate
group by et.Code;
```

- Spot-check recent values by rate:

```sql
select top (50)
    et.Code as ExportType,
    erd.ShortName,
    erv.*
from ExportRateValues erv
join ExportRateDefinitions erd on erd.ExportRateID = erv.ExportRateID
join LExportTypes et on et.IID = erd.ExportTypeID and et.Code in ('DBC','DB2')
where erv.ExportDate = @exportDate
order by erd.ShortName, erv.RateDate desc;
```


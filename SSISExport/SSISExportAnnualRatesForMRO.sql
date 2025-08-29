

USE [BSDRate]
GO

/****** Object:  StoredProcedure [dbo].[SSISExportAnnualRatesForMRO]    Script Date: 8/29/2025 2:05:06 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*****************************************************************************
Description: Select combined MRO data from ExportRateValues and related tables
             for SSIS package. See also SSISStageAnnualRatesForMRO.

Used By: BSDRate

Created by: jrhald
Created when: 02/11/2014
Modifications:

Date        By      Changes Made
----------  ------- ----------------------------------------------------------
10/13/2021  stsadiq modifying to add the bsby/SOFR Term curve to the file
*****************************************************************************/
CREATE OR ALTER PROCEDURE [dbo].[SSISExportAnnualRatesForMRO]
     @exportDate date = null
AS
BEGIN
    declare @exportTypeCode varchar(3) = 'MRA'
    
    --since SSIS does not allow a NULL date parameter, we use 12/30/1899 to represent NULL
    if (isnull(@exportDate, '12/30/1899') = '12/30/1899')
    begin
        set @exportDate = cast(getdate() as date)
    end

    ; with ZeroCouponRateValues as
    (
        select 
            CurrencyCode,
            RateDate, 
            zerodayl0p0bzca,
            onedayl0p0bzca, 
            sevendayl0p0bzca, 
            fourteendayl0p0bzca,
            twentyonedayl0p0bzca,
            onemol0p0bzca,
            twomol0p0bzca,
            threemol0p0bzca,
            fourmol0p0bzca,
            fivemol0p0bzca,
            sixmol0p0bzca,
            sevenmol0p0bzca,
            eightmol0p0bzca,
            ninemol0p0bzca,
            tenmol0p0bzca,
            elevenmol0p0bzca,
            twelvemol0p0bzca,
            twoyrl0p0bzca,
            threeyrl0p0bzca,
            fouryrl0p0bzca,
            fiveyrl0p0bzca,
            sixyrl0p0bzca,
            sevenyrl0p0bzca,
            tenyrl0p0bzca,
            fifteenyrl0p0bzca,
            twentyyrl0p0bzca,
            thirtyyrl0p0bzca,
            fedtarzca
        from 
            (select 
                CurrencyCode = c.Code,
                erv.RateDate,
                erd.ShortName,
                erv.Value
             from ExportRateDefinitions erd
             join LExportTypes et on
                et.IID = erd.ExportTypeID and et.Code = @exportTypeCode
             join CalculatedRateDefinitions crd on
                crd.CalculatedRateID = erd.BaseRateID
             join LCurrencies c on
                c.IID = crd.CurrencyID
             join ExportRateValues erv on
                erv.ExportRateID = erd.ExportRateID
                and erv.ExportDate = @exportDate
             where
                erd.ShortName in ('zerodayl0p0bzca','onedayl0p0bzca','sevendayl0p0bzca','fourteendayl0p0bzca',
                                  'twentyonedayl0p0bzca','onemol0p0bzca','twomol0p0bzca',
                                  'threemol0p0bzca','fourmol0p0bzca','fivemol0p0bzca',
                                  'sixmol0p0bzca','sevenmol0p0bzca','eightmol0p0bzca',
                                  'ninemol0p0bzca','tenmol0p0bzca','elevenmol0p0bzca','twelvemol0p0bzca',
                                  'twoyrl0p0bzca','threeyrl0p0bzca','fouryrl0p0bzca',
                                  'fiveyrl0p0bzca','sixyrl0p0bzca','sevenyrl0p0bzca',
                                  'tenyrl0p0bzca','fifteenyrl0p0bzca','twentyyrl0p0bzca',
                                  'thirtyyrl0p0bzca','fedtarzca')) as unpivoted
        pivot (max(Value) for ShortName in ([zerodayl0p0bzca],[onedayl0p0bzca],[sevendayl0p0bzca],[fourteendayl0p0bzca],
                                            [twentyonedayl0p0bzca],[onemol0p0bzca],[twomol0p0bzca],
                                            [threemol0p0bzca],[fourmol0p0bzca],[fivemol0p0bzca],
                                            [sixmol0p0bzca],[sevenmol0p0bzca],[eightmol0p0bzca],
                                            [ninemol0p0bzca],[tenmol0p0bzca],[elevenmol0p0bzca],[twelvemol0p0bzca],
                                            [twoyrl0p0bzca],[threeyrl0p0bzca],[fouryrl0p0bzca],
                                            [fiveyrl0p0bzca],[sixyrl0p0bzca],[sevenyrl0p0bzca],
                                            [tenyrl0p0bzca],[fifteenyrl0p0bzca],[twentyyrl0p0bzca],
                                            [thirtyyrl0p0bzca],[fedtarzca])) as pivoted
    ),
    BSBYZeroCouponRateValues as
    (
        select 
            CurrencyCode,
            RateDate, 
            BSBYON,
            BSBY1M,
            BSBY3M,
            BSBY6M,
            BSBY12M
        from 
            (select 
                CurrencyCode = ecv.Value,
                erv.RateDate,
                erd.ShortName,
                erv.Value
             from ExportRateDefinitions erd
             join LExportTypes et on
                et.IID = erd.ExportTypeID and et.Code = @exportTypeCode
             join SourceRateDefinitions srd on
                srd.SourceRateID = erd.BaseRateID
             join LCurrencies c on
                c.IID = srd.CurrencyID
             join ExportRateValues erv on
                erv.ExportRateID = erd.ExportRateID
                and erv.ExportDate = @exportDate
            join exportcolumnvalues ecv on ecv.ExportRateID = erd.ExportRateID 
             ) as unpivoted
        pivot (max(Value) for ShortName in (BSBYON,BSBY1M,BSBY3M,BSBY6M,
                                            BSBY12M)) as pivoted
    ),
    SOFRZeroCouponRateValues as
    (
        select 
            CurrencyCode,
            RateDate, 
            SOFR1MTermNY,
            SOFR3MTermNY,
            SOFR6MTermNY,
            SOFR12MTermNY
        from 
            (select 
                CurrencyCode = ecv.Value,
                erv.RateDate,
                erd.ShortName,
                erv.Value
             from ExportRateDefinitions erd
             join LExportTypes et on
                et.IID = erd.ExportTypeID and et.Code = @exportTypeCode
             join SourceRateDefinitions srd on
                srd.SourceRateID = erd.BaseRateID
             join LCurrencies c on
                c.IID = srd.CurrencyID
             join ExportRateValues erv on
                erv.ExportRateID = erd.ExportRateID
                and erv.ExportDate = @exportDate
            join exportcolumnvalues ecv on ecv.ExportRateID = erd.ExportRateID 
             ) as unpivoted
        pivot (max(Value) for ShortName in (SOFR1MTermNY,SOFR3MTermNY,SOFR6MTermNY,SOFR12MTermNY
                                            )) as pivoted
    ),
        AmeriborZeroCouponRateValues as
    (
        select 
            CurrencyCode,
            RateDate, 
            ameriborterm30,
            ameriborterm90
        from 
            (select 
                CurrencyCode = ecv.Value,
                erv.RateDate,
                erd.ShortName,
                erv.Value
             from ExportRateDefinitions erd
             join LExportTypes et on
                et.IID = erd.ExportTypeID and et.Code = @exportTypeCode
             join SourceRateDefinitions srd on
                srd.SourceRateID = erd.BaseRateID
             join LCurrencies c on
                c.IID = srd.CurrencyID
             join ExportRateValues erv on
                erv.ExportRateID = erd.ExportRateID
                and erv.ExportDate = @exportDate
            join exportcolumnvalues ecv on ecv.ExportRateID = erd.ExportRateID 
             ) as unpivoted
        pivot (max(Value) for ShortName in (ameriborterm30,ameriborterm90
                                            )) as pivoted
    ),
    ZeroCouponRateAverages as
    (
        select
            CurrencyCode,
            RateDate, 
            zerodayl0p0bzcaavg,
            onedayl0p0bzcaavg,
            sevendayl0p0bzcaavg,
            fourteendayl0p0bzcaavg,
            twentyonedayl0p0bzcaavg,
            onemol0p0bzcaavg,
            twomol0p0bzcaavg,
            threemol0p0bzcaavg,
            fourmol0p0bzcaavg,
            fivemol0p0bzcaavg,
            sixmol0p0bzcaavg,
            sevenmol0p0bzcaavg,
            eightmol0p0bzcaavg,
            ninemol0p0bzcaavg,
            tenmol0p0bzcaavg,
            elevenmol0p0bzcaavg,
            twelvemol0p0bzcaavg,
            twoyrl0p0bzcaavg,
            threeyrl0p0bzcaavg,
            fouryrl0p0bzcaavg,
            fiveyrl0p0bzcaavg,
            sixyrl0p0bzcaavg,
            sevenyrl0p0bzcaavg,
            tenyrl0p0bzcaavg,
            fifteenyrl0p0bzcaavg,
            twentyyrl0p0bzcaavg,
            thirtyyrl0p0bzcaavg,
            fedtarzcaavg
        from
            (select 
                CurrencyCode = c.Code,
                erv.RateDate,
                erd.ShortName,
                erv.Value
             from ExportRateDefinitions erd
             join LExportTypes et on
                et.IID = erd.ExportTypeID and et.Code = @exportTypeCode
             join CalculatedRateDefinitions crd on
                crd.CalculatedRateID = erd.BaseRateID
             join LCurrencies c on
                c.IID = crd.CurrencyID
             join ExportRateValues erv on
                erv.ExportRateID = erd.ExportRateID
                and erv.ExportDate = @exportDate
             where
                erd.ShortName in ('zerodayl0p0bzcaavg','onedayl0p0bzcaavg','sevendayl0p0bzcaavg','fourteendayl0p0bzcaavg',
                                  'twentyonedayl0p0bzcaavg','onemol0p0bzcaavg','twomol0p0bzcaavg',
                                  'threemol0p0bzcaavg','fourmol0p0bzcaavg','fivemol0p0bzcaavg',
                                  'sixmol0p0bzcaavg','sevenmol0p0bzcaavg','eightmol0p0bzcaavg',
                                  'ninemol0p0bzcaavg','tenmol0p0bzcaavg','elevenmol0p0bzcaavg','twelvemol0p0bzcaavg',
                                  'twoyrl0p0bzcaavg','threeyrl0p0bzcaavg','fouryrl0p0bzcaavg',
                                  'fiveyrl0p0bzcaavg','sixyrl0p0bzcaavg','sevenyrl0p0bzcaavg',
                                  'tenyrl0p0bzcaavg','fifteenyrl0p0bzcaavg','twentyyrl0p0bzcaavg',
                                  'thirtyyrl0p0bzcaavg','fedtarzcaavg')) as unpivoted
        pivot (max(Value) for ShortName in ([zerodayl0p0bzcaavg],[onedayl0p0bzcaavg],[sevendayl0p0bzcaavg],[fourteendayl0p0bzcaavg],
                                            [twentyonedayl0p0bzcaavg],[onemol0p0bzcaavg],[twomol0p0bzcaavg],
                                            [threemol0p0bzcaavg],[fourmol0p0bzcaavg],[fivemol0p0bzcaavg],
                                            [sixmol0p0bzcaavg],[sevenmol0p0bzcaavg],[eightmol0p0bzcaavg],
                                            [ninemol0p0bzcaavg],[tenmol0p0bzcaavg],[elevenmol0p0bzcaavg],[twelvemol0p0bzcaavg],
                                            [twoyrl0p0bzcaavg],[threeyrl0p0bzcaavg],[fouryrl0p0bzcaavg],
                                            [fiveyrl0p0bzcaavg],[sixyrl0p0bzcaavg],[sevenyrl0p0bzcaavg],
                                            [tenyrl0p0bzcaavg],[fifteenyrl0p0bzcaavg],[twentyyrl0p0bzcaavg],
                                            [thirtyyrl0p0bzcaavg],[fedtarzcaavg])) as pivoted
    ),
    L0P0BAverages as
    (
        select
            CurrencyCode,
            RateDate, 
            zerodayl0p0bavg,
            onedayl0p0bavg,
            sevendayl0p0bavg,
            fourteendayl0p0bavg,
            twentyonedayl0p0bavg,
            onemol0p0bavg,
            twomol0p0bavg,
            threemol0p0bavg,
            fourmol0p0bavg,
            fivemol0p0bavg,
            sixmol0p0bavg,
            sevenmol0p0bavg,
            eightmol0p0bavg,
            ninemol0p0bavg,
            tenmol0p0bavg,
            elevenmol0p0bavg,
            twelvemol0p0bavg,
            twoyrl0p0bavg,
            threeyrl0p0bavg,
            fouryrl0p0bavg,
            fiveyrl0p0bavg,
            sixyrl0p0bavg,
            sevenyrl0p0bavg,
            tenyrl0p0bavg,
            fifteenyrl0p0bavg,
            twentyyrl0p0bavg,
            thirtyyrl0p0bavg,
            fedtaravg
        from
            (select 
                CurrencyCode = c.Code,
                erv.RateDate,
                erd.ShortName,
                erv.Value
             from ExportRateDefinitions erd
             join LExportTypes et on
                et.IID = erd.ExportTypeID and et.Code = @exportTypeCode
             join CalculatedRateDefinitions crd on
                crd.CalculatedRateID = erd.BaseRateID
             join LCurrencies c on
                c.IID = crd.CurrencyID
             join ExportRateValues erv on
                erv.ExportRateID = erd.ExportRateID
                and erv.ExportDate = @exportDate
             where
                erd.ShortName in ('zerodayl0p0bavg','onedayl0p0bavg','sevendayl0p0bavg','fourteendayl0p0bavg',
                                  'twentyonedayl0p0bavg','onemol0p0bavg','twomol0p0bavg',
                                  'threemol0p0bavg','fourmol0p0bavg','fivemol0p0bavg',
                                  'sixmol0p0bavg','sevenmol0p0bavg','eightmol0p0bavg',
                                  'ninemol0p0bavg','tenmol0p0bavg','elevenmol0p0bavg','twelvemol0p0bavg',
                                  'twoyrl0p0bavg','threeyrl0p0bavg','fouryrl0p0bavg',
                                  'fiveyrl0p0bavg','sixyrl0p0bavg','sevenyrl0p0bavg',
                                  'tenyrl0p0bavg','fifteenyrl0p0bavg','twentyyrl0p0bavg',
                                  'thirtyyrl0p0bavg','fedtaravg')) as unpivoted
        pivot (max(Value) for ShortName in ([zerodayl0p0bavg],[onedayl0p0bavg],[sevendayl0p0bavg],[fourteendayl0p0bavg],
                                            [twentyonedayl0p0bavg],[onemol0p0bavg],[twomol0p0bavg],
                                            [threemol0p0bavg],[fourmol0p0bavg],[fivemol0p0bavg],
                                            [sixmol0p0bavg],[sevenmol0p0bavg],[eightmol0p0bavg],
                                            [ninemol0p0bavg],[tenmol0p0bavg],[elevenmol0p0bavg],[twelvemol0p0bavg],
                                            [twoyrl0p0bavg],[threeyrl0p0bavg],[fouryrl0p0bavg],
                                            [fiveyrl0p0bavg],[sixyrl0p0bavg],[sevenyrl0p0bavg],
                                            [tenyrl0p0bavg],[fifteenyrl0p0bavg],[twentyyrl0p0bavg],
                                            [thirtyyrl0p0bavg],[fedtaravg])) as pivoted
    ),
    Combined as
    (
        select 
            [GroupSort]       = case CurrencyCode when 'USD' then 1 when 'CAD' then 2 end
            ,[CURVE]          = CurrencyCode
            ,[Date]           = convert(varchar, RateDate, 101)
            ,[O/N]            = case CurrencyCode when 'USD'
                                    then cast((onedayl0p0bzca * 100) as varchar)
                                    else cast((zerodayl0p0bzca * 100) as varchar)
                                end
            ,[7D]             = cast((sevendayl0p0bzca * 100) as varchar) 
            ,[14D]            = cast((fourteendayl0p0bzca * 100) as varchar)
            ,[21D]            = cast((twentyonedayl0p0bzca * 100) as varchar)
            ,[1M]             = cast((onemol0p0bzca * 100) as varchar)
            ,[2M]             = cast((twomol0p0bzca * 100) as varchar)
            ,[3M]             = cast((threemol0p0bzca * 100) as varchar)
            ,[4M]             = cast((fourmol0p0bzca * 100) as varchar)
            ,[5M]             = cast((fivemol0p0bzca * 100) as varchar)
            ,[6M]             = cast((sixmol0p0bzca * 100) as varchar)
            ,[7M]             = cast((sevenmol0p0bzca * 100) as varchar)
            ,[8M]             = cast((eightmol0p0bzca * 100) as varchar)
            ,[9M]             = cast((ninemol0p0bzca * 100) as varchar)
            ,[10M]            = cast((tenmol0p0bzca * 100) as varchar)
            ,[11M]            = cast((elevenmol0p0bzca * 100) as varchar)
            ,[12M]            = cast((twelvemol0p0bzca * 100) as varchar)
            ,[24M]            = cast((twoyrl0p0bzca * 100) as varchar)
            ,[36M]            = cast((threeyrl0p0bzca * 100) as varchar)
            ,[48M]            = cast((fouryrl0p0bzca * 100) as varchar)
            ,[60M]            = cast((fiveyrl0p0bzca * 100) as varchar)
            ,[72M]            = cast((sixyrl0p0bzca * 100) as varchar)
            ,[84M]            = cast((sevenyrl0p0bzca * 100) as varchar)
            ,[120M]           = cast((tenyrl0p0bzca * 100) as varchar)
            ,[180M]           = cast((fifteenyrl0p0bzca * 100) as varchar)
            ,[240M]           = cast((twentyyrl0p0bzca * 100) as varchar)
            ,[360M]           = cast((thirtyyrl0p0bzca * 100) as varchar)
            ,[Fedtar]         = cast((fedtarzca * 100) as varchar)
        from ZeroCouponRateValues
        union all
        select
            [GroupSort]       = case CurrencyCode when 'USD' then 1 when 'CAD' then 2 end
            ,[CURVE]          = case CurrencyCode when 'USD' then 'USDAVG' when 'CAD' then 'CADAVG' end
            ,[Date]           = convert(varchar, RateDate, 101)
            ,[O/N]            = case CurrencyCode when 'USD'
                                    then cast((onedayl0p0bzcaavg * 100) as varchar)
                                    else cast((zerodayl0p0bzcaavg * 100) as varchar)
                                end
            ,[7D]             = cast((sevendayl0p0bzcaavg * 100) as varchar)
            ,[14D]            = cast((fourteendayl0p0bzcaavg * 100) as varchar)
            ,[21D]            = cast((twentyonedayl0p0bzcaavg * 100) as varchar)
            ,[1M]             = cast((onemol0p0bzcaavg * 100) as varchar)
            ,[2M]             = cast((twomol0p0bzcaavg * 100) as varchar)
            ,[3M]             = cast((threemol0p0bzcaavg * 100) as varchar)
            ,[4M]             = cast((fourmol0p0bzcaavg * 100) as varchar)
            ,[5M]             = cast((fivemol0p0bzcaavg * 100) as varchar)
            ,[6M]             = cast((sixmol0p0bzcaavg * 100) as varchar)
            ,[7M]             = cast((sevenmol0p0bzcaavg * 100) as varchar)
            ,[8M]             = cast((eightmol0p0bzcaavg * 100) as varchar)
            ,[9M]             = cast((ninemol0p0bzcaavg * 100) as varchar)
            ,[10M]            = cast((tenmol0p0bzcaavg * 100) as varchar)
            ,[11M]            = cast((elevenmol0p0bzcaavg * 100) as varchar)
            ,[12M]            = cast((twelvemol0p0bzcaavg * 100) as varchar)
            ,[24M]            = cast((twoyrl0p0bzcaavg * 100) as varchar)
            ,[36M]            = cast((threeyrl0p0bzcaavg * 100) as varchar)
            ,[48M]            = cast((fouryrl0p0bzcaavg * 100) as varchar)
            ,[60M]            = cast((fiveyrl0p0bzcaavg * 100) as varchar)
            ,[72M]            = cast((sixyrl0p0bzcaavg * 100) as varchar)
            ,[84M]            = cast((sevenyrl0p0bzcaavg * 100) as varchar)
            ,[120M]           = cast((tenyrl0p0bzcaavg * 100) as varchar)
            ,[180M]           = cast((fifteenyrl0p0bzcaavg * 100) as varchar)
            ,[240M]           = cast((twentyyrl0p0bzcaavg * 100) as varchar)
            ,[360M]           = cast((thirtyyrl0p0bzcaavg * 100) as varchar)
            ,[Fedtar]         = cast((fedtarzcaavg * 100) as varchar)
        from ZeroCouponRateAverages
        union all
        select
            [GroupSort]       = case CurrencyCode when 'USD' then 1 when 'CAD' then 2 end
            ,[CURVE]          = case CurrencyCode when 'USD' then 'USDWAVG' when 'CAD' then 'CADWAVG' end
            ,[Date]           = convert(varchar, RateDate, 101)
            ,[O/N]            = case CurrencyCode when 'USD'
                                    then cast((onedayl0p0bavg * 100) as varchar)
                                    else cast((zerodayl0p0bavg * 100) as varchar)
                                end
            ,[7D]             = cast((sevendayl0p0bavg * 100) as varchar)
            ,[14D]            = cast((fourteendayl0p0bavg * 100) as varchar)
            ,[21D]            = cast((twentyonedayl0p0bavg * 100) as varchar)
            ,[1M]             = cast((onemol0p0bavg * 100) as varchar)
            ,[2M]             = cast((twomol0p0bavg * 100) as varchar)
            ,[3M]             = cast((threemol0p0bavg * 100) as varchar)
            ,[4M]             = cast((fourmol0p0bavg * 100) as varchar)
            ,[5M]             = cast((fivemol0p0bavg * 100) as varchar)
            ,[6M]             = cast((sixmol0p0bavg * 100) as varchar)
            ,[7M]             = cast((sevenmol0p0bavg * 100) as varchar)
            ,[8M]             = cast((eightmol0p0bavg * 100) as varchar)
            ,[9M]             = cast((ninemol0p0bavg * 100) as varchar)
            ,[10M]            = cast((tenmol0p0bavg * 100) as varchar)
            ,[11M]            = cast((elevenmol0p0bavg * 100) as varchar)
            ,[12M]            = cast((twelvemol0p0bavg * 100) as varchar)
            ,[24M]            = cast((twoyrl0p0bavg * 100) as varchar)
            ,[36M]            = cast((threeyrl0p0bavg * 100) as varchar)
            ,[48M]            = cast((fouryrl0p0bavg * 100) as varchar)
            ,[60M]            = cast((fiveyrl0p0bavg * 100) as varchar)
            ,[72M]            = cast((sixyrl0p0bavg * 100) as varchar)
            ,[84M]            = cast((sevenyrl0p0bavg * 100) as varchar)
            ,[120M]           = cast((tenyrl0p0bavg * 100) as varchar)
            ,[180M]           = cast((fifteenyrl0p0bavg * 100) as varchar)
            ,[240M]           = cast((twentyyrl0p0bavg * 100) as varchar)
            ,[360M]           = cast((thirtyyrl0p0bavg * 100) as varchar)
            ,[Fedtar]         = cast((fedtaravg * 100) as varchar)
        from L0P0BAverages
        union all
        select 
        [GroupSort] =  case CurrencyCode when 'USD' then 1 when 'CAD' then 2 when 'BSBY' then 3 when 'SOFR' then 4 end
        ,[CURVE]       = currencyCode
        ,[Date]           = convert(varchar, RateDate, 101)
        ,[O/N]            = cast((BSBYON * 100) as varchar)
        ,[7D]            = null 
        ,[14D]            = null
        ,[21D]            = null 
        ,[1M]             = cast((BSBY1M * 100) as varchar)
        ,[2M]             = null 
        ,[3M]             = cast((BSBY3M * 100) as varchar) 
        ,[4M]             = null 
        ,[5M]             = null 
        ,[6M]             = cast((BSBY6M * 100) as varchar) 
        ,[7M]             = null 
        ,[8M]             = null 
        ,[9M]             = null 
        ,[10M]            = null 
        ,[11M]            = null 
        ,[12M]            =cast((BSBY12M * 100) as varchar) 
        ,[24M]            = null 
        ,[36M]            = null 
        ,[48M]            = null 
        ,[60M]            = null 
        ,[72M]            = null 
        ,[84M]            = null 
        ,[120M]           = null 
        ,[180M]           = null 
        ,[240M]           = null 
        ,[360M]           = null 
        ,[Fedtar]         = null 
        from BSBYZeroCouponRateValues
        where CurrencyCode = 'BSBY'
                union all
        select 
        [GroupSort] =  case CurrencyCode when 'USD' then 1 when 'CAD' then 2 when 'BSBY' then 3 when 'SOFR' then 4 end
        ,[CURVE]       = currencyCode
        ,[Date]           = convert(varchar, RateDate, 101)
        ,[O/N]            = null
        ,[7D]            = null 
        ,[14D]            = null
        ,[21D]            = null 
        ,[1M]             = cast((SOFR1MTermNY * 100) as varchar)
        ,[2M]             = null 
        ,[3M]             = cast((SOFR3MTermNY * 100) as varchar) 
        ,[4M]             = null 
        ,[5M]             = null 
        ,[6M]             = cast((SOFR6MTermNY * 100) as varchar) 
        ,[7M]             = null 
        ,[8M]             = null 
        ,[9M]             = null 
        ,[10M]            = null 
        ,[11M]            = null 
        ,[12M]            =cast((SOFR12MTermNY * 100) as varchar) 
        ,[24M]            = null 
        ,[36M]            = null 
        ,[48M]            = null 
        ,[60M]            = null 
        ,[72M]            = null 
        ,[84M]            = null 
        ,[120M]           = null 
        ,[180M]           = null 
        ,[240M]           = null 
        ,[360M]           = null 
        ,[Fedtar]         = null 
        from SOFRZeroCouponRateValues
        where CurrencyCode = 'SOFR'
        union all
        select 
        [GroupSort] =  case CurrencyCode when 'USD' then 1 when 'CAD' then 2 when 'BSBY' then 3 when 'SOFR' then 4 when 'ameri' then 5 end
        ,[CURVE]       = currencyCode
        ,[Date]           = convert(varchar, RateDate, 101)
        ,[O/N]            = null
        ,[7D]            = null 
        ,[14D]            = null
        ,[21D]            = null 
        ,[1M]             = cast((ameriborterm30 * 100) as varchar)
        ,[2M]             = null 
        ,[3M]             = cast((ameriborterm90 * 100) as varchar) 
        ,[4M]             = null 
        ,[5M]             = null 
        ,[6M]             = null
        ,[7M]             = null 
        ,[8M]             = null 
        ,[9M]             = null 
        ,[10M]            = null 
        ,[11M]            = null 
        ,[12M]           = null
        ,[24M]            = null 
        ,[36M]            = null 
        ,[48M]            = null 
        ,[60M]            = null 
        ,[72M]            = null 
        ,[84M]            = null 
        ,[120M]           = null 
        ,[180M]           = null 
        ,[240M]           = null 
        ,[360M]           = null 
        ,[Fedtar]         = null 
        from AmeriborZeroCouponRateValues
        where CurrencyCode = 'ameri'
    )

    select
        [CURVE]
        ,[Date]
        ,[O/N]
        ,[7D]
        ,[14D]
        ,[21D]
        ,[1M]
        ,[2M]
        ,[3M]
        ,[4M]
        ,[5M]
        ,[6M]
        ,[7M]
        ,[8M]
        ,[9M]
        ,[10M]
        ,[11M]
        ,[12M]
        ,[24M]
        ,[36M]
        ,[48M]
        ,[60M]
        ,[72M]
        ,[84M]
        ,[120M]
        ,[180M]
        ,[240M]
        ,[360M]
        ,[Fedtar]
    from Combined
    order by GroupSort, CURVE, Date



END

GO




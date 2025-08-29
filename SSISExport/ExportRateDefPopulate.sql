

USE BSDRate
GO

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '1daybulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1, 'C', 4, 2, 2, '1daybulletcurve', '1 day Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 1, NULL, '', NULL, 'TPP-8278', '2025-06-24 15:13:52.837', 'TPP-8278', '2025-07-02 11:31:33.960'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '7daybulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        2, 'C', 4, 2, 2, '7daybulletcurve', '7 day Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 2, NULL, '', NULL, 'TPP-8278', '2025-06-24 15:16:15.183', 'TPP-8278', '2025-06-30 11:02:56.690'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '14daybulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        3, 'C', 4, 2, 2, '14daybulletcurve', '14 day Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 3, NULL, '', NULL, 'TPP-8278', '2025-06-24 15:17:47.250', 'TPP-8278', '2025-06-24 15:17:47.250'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '21daybulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        4, 'C', 4, 2, 2, '21daybulletcurve', '21 day Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 4, NULL, '', NULL, 'TPP-8278', '2025-06-30 10:34:56.030', 'TPP-8278', '2025-06-30 10:34:56.030'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '1mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        5, 'C', 4, 2, 2, '1mobulletcurve', '1 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 5, NULL, '', NULL, 'TPP-8278', '2025-06-30 10:38:11.410', 'TPP-8278', '2025-07-02 11:31:59.530'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '2mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        6, 'C', 4, 2, 2, '2mobulletcurve', '2 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 6, NULL, '', NULL, 'TPP-8278', '2025-06-30 11:06:57.563', 'TPP-8278', '2025-07-02 12:03:32.383'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '3mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        7, 'C', 4, 2, 2, '3mobulletcurve', '3 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 7, NULL, '', NULL, 'TPP-8278', '2025-06-30 11:24:13.873', 'TPP-8278', '2025-07-02 12:03:19.217'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '4mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        8, 'C', 4, 2, 2, '4mobulletcurve', '4 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 8, NULL, '', NULL, 'TPP-8278', '2025-06-30 11:25:43.103', 'TPP-8278', '2025-07-02 12:02:42.297'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '5mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        9, 'C', 4, 2, 2, '5mobulletcurve', '5 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 9, NULL, '', NULL, 'TPP-8278', '2025-06-30 11:29:29.530', 'TPP-8278', '2025-07-02 12:01:55.273'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '6mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        10, 'C', 4, 2, 2, '6mobulletcurve', '6 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 10, NULL, '', NULL, 'TPP-8278', '2025-06-30 11:47:23.747', 'TPP-8278', '2025-07-02 12:00:19.177'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '7mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1242, 'C', 4, 2, 2, '7mobulletcurve', '7 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 11, NULL, '', NULL, 'TPP-8278', '2025-06-30 11:48:37.043', 'TPP-8278', '2025-07-02 12:00:04.047'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '8mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1243, 'C', 4, 2, 2, '8mobulletcurve', '8 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 12, NULL, '', NULL, 'TPP-8278', '2025-06-30 11:50:39.897', 'TPP-8278', '2025-07-02 11:57:44.477'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '9mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        11, 'C', 4, 2, 2, '9mobulletcurve', '9 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 13, NULL, '', NULL, 'TPP-8278', '2025-06-30 11:52:22.317', 'TPP-8278', '2025-07-02 11:53:18.113'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '10mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1244, 'C', 4, 2, 2, '10mobulletcurve', '10 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 14, NULL, '', NULL, 'TPP-8278', '2025-06-30 11:55:50.973', 'TPP-8278', '2025-07-02 11:51:57.177'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '11mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1245, 'C', 4, 2, 2, '11mobulletcurve', '11 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 15, NULL, '', NULL, 'TPP-8278', '2025-06-30 12:09:51.000', 'TPP-8278', '2025-07-02 11:49:41.563'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '12mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        12, 'C', 4, 2, 2, '12mobulletcurve', '12 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 16, NULL, '', NULL, 'TPP-8278', '2025-06-30 12:11:14.080', 'TPP-8278', '2025-07-02 11:46:35.510'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '13mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1246, 'C', 4, 2, 2, '13mobulletcurve', '13 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 17, NULL, '', NULL, 'TPP-8278', '2025-06-30 12:13:20.393', 'TPP-8278', '2025-07-02 11:45:12.523'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '14mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1247, 'C', 4, 2, 2, '14mobulletcurve', '14 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 18, NULL, '', NULL, 'TPP-8278', '2025-06-30 12:18:54.047', 'TPP-8278', '2025-07-02 11:43:16.500'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '15mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        13, 'C', 4, 2, 2, '15mobulletcurve', '15 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 19, NULL, '', NULL, 'TPP-8278', '2025-06-30 12:23:28.663', 'TPP-8278', '2025-07-02 11:41:15.010'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '16mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1248, 'C', 4, 2, 2, '16mobulletcurve', '16 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 20, NULL, '', NULL, 'TPP-8278', '2025-06-30 12:27:25.680', 'TPP-8278', '2025-07-02 11:39:01.427'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '17mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1249, 'C', 4, 2, 2, '17mobulletcurve', '17 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 21, NULL, '', NULL, 'TPP-8278', '2025-06-30 12:30:55.670', 'TPP-8278', '2025-07-02 11:37:01.640'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '18mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        14, 'C', 4, 2, 2, '18mobulletcurve', '18 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 22, NULL, '', NULL, 'TPP-8278', '2025-06-30 12:33:51.477', 'TPP-8278', '2025-07-02 11:35:00.160'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '19mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1250, 'C', 4, 2, 2, '19mobulletcurve', '19 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 23, NULL, '', NULL, 'TPP-8278', '2025-06-30 12:37:13.810', 'TPP-8278', '2025-07-02 11:33:45.690'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '20mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1251, 'C', 4, 2, 2, '20mobulletcurve', '20 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 24, NULL, '', NULL, 'TPP-8278', '2025-06-30 12:40:38.690', 'TPP-8278', '2025-07-02 11:31:12.640'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '21mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        15, 'C', 4, 2, 2, '21mobulletcurve', '21 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 25, NULL, '', NULL, 'TPP-8278', '2025-06-30 12:43:24.160', 'TPP-8278', '2025-07-02 11:30:48.470'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '22mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1252, 'C', 4, 2, 2, '22mobulletcurve', '22 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 26, NULL, '', NULL, 'TPP-8278', '2025-06-30 12:46:53.300', 'TPP-8278', '2025-07-02 11:21:32.133'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '23mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1253, 'C', 4, 2, 2, '23mobulletcurve', '23 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 27, NULL, '', NULL, 'TPP-8278', '2025-06-30 12:48:59.540', 'TPP-8278', '2025-07-02 09:14:00.493'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '24mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        16, 'C', 4, 2, 2, '24mobulletcurve', '24 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 28, NULL, '', NULL, 'TPP-8278', '2025-06-30 12:51:09.200', 'TPP-8278', '2025-07-01 12:37:38.237'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '25mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1254, 'C', 4, 2, 2, '25mobulletcurve', '25 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 29, NULL, '', NULL, 'TPP-8278', '2025-06-30 12:52:50.200', 'TPP-8278', '2025-07-01 12:36:12.380'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '26mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1255, 'C', 4, 2, 2, '26mobulletcurve', '26 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 30, NULL, '', NULL, 'TPP-8278', '2025-06-30 12:58:23.983', 'TPP-8278', '2025-07-01 12:34:31.747'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '27mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1256, 'C', 4, 2, 2, '27mobulletcurve', '27 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 31, NULL, '', NULL, 'TPP-8278', '2025-06-30 15:44:30.927', 'TPP-8278', '2025-07-01 12:32:39.513'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '28mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1257, 'C', 4, 2, 2, '28mobulletcurve', '28 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 32, NULL, '', NULL, 'TPP-8278', '2025-06-30 15:50:13.517', 'TPP-8278', '2025-07-01 12:15:27.040'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '29mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1258, 'C', 4, 2, 2, '29mobulletcurve', '29 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 33, NULL, '', NULL, 'TPP-8278', '2025-06-30 16:00:13.290', 'TPP-8278', '2025-07-01 12:11:09.723'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '33mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1261, 'C', 4, 2, 2, '33mobulletcurve', '33 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 37, NULL, '', NULL, 'TPP-8278', '2025-06-30 16:04:38.347', 'TPP-8278', '2025-07-01 12:07:59.327'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '100mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1322, 'C', 4, 2, 2, '100mobulletcurve', '100 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 104, NULL, '', NULL, 'TPP-8278', '2025-06-30 16:07:33.920', 'TPP-8278', '2025-07-02 12:04:57.690'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '101mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1323, 'C', 4, 2, 2, '101mobulletcurve', '101 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 105, NULL, '', NULL, 'TPP-8278', '2025-06-30 16:08:45.397', 'TPP-8278', '2025-07-02 12:05:35.800'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '30mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        17, 'C', 4, 2, 2, '30mobulletcurve', '30 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 34, NULL, '', NULL, 'TPP-8278', '2025-07-01 10:59:01.807', 'TPP-8278', '2025-07-01 10:59:01.807'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '31mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1259, 'C', 4, 2, 2, '31mobulletcurve', '31 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 35, NULL, '', NULL, 'TPP-8278', '2025-07-01 11:12:15.467', 'TPP-8278', '2025-07-01 11:12:15.467'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '32mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1260, 'C', 4, 2, 2, '32mobulletcurve', '32 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 36, NULL, '', NULL, 'TPP-8278', '2025-07-01 11:13:34.710', 'TPP-8278', '2025-07-01 11:13:34.710'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '34mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1262, 'C', 4, 2, 2, '34mobulletcurve', '34 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 38, NULL, '', NULL, 'TPP-8278', '2025-07-01 11:29:10.367', 'TPP-8278', '2025-07-01 11:29:10.367'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '35mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1263, 'C', 4, 2, 2, '35mobulletcurve', '35 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 39, NULL, '', NULL, 'TPP-8278', '2025-07-01 11:32:18.143', 'TPP-8278', '2025-07-01 11:32:18.143'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '36mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        18, 'C', 4, 2, 2, '36mobulletcurve', '36 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 40, NULL, '', NULL, 'TPP-8278', '2025-07-01 11:33:29.347', 'TPP-8278', '2025-07-01 11:33:29.347'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '37mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1264, 'C', 4, 2, 2, '37mobulletcurve', '37 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 41, NULL, '', NULL, 'TPP-8278', '2025-07-01 11:34:58.570', 'TPP-8278', '2025-07-01 11:34:58.570'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '38mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1265, 'C', 4, 2, 2, '38mobulletcurve', '38 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 42, NULL, '', NULL, 'TPP-8278', '2025-07-01 11:36:26.107', 'TPP-8278', '2025-07-01 11:36:26.107'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '39mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1266, 'C', 4, 2, 2, '39mobulletcurve', '39 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 43, NULL, '', NULL, 'TPP-8278', '2025-07-01 11:37:34.387', 'TPP-8278', '2025-07-01 11:37:34.387'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '40mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1267, 'C', 4, 2, 2, '40mobulletcurve', '40 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 44, NULL, '', NULL, 'TPP-8278', '2025-07-01 11:39:04.407', 'TPP-8278', '2025-07-01 11:39:04.407'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '41mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1268, 'C', 4, 2, 2, '41mobulletcurve', '41 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 45, NULL, '', NULL, 'TPP-8278', '2025-07-01 11:40:20.177', 'TPP-8278', '2025-07-01 11:40:20.177'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '42mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1269, 'C', 4, 2, 2, '42mobulletcurve', '42 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 46, NULL, '', NULL, 'TPP-8278', '2025-07-01 11:41:23.277', 'TPP-8278', '2025-07-01 11:41:23.277'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '43mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1270, 'C', 4, 2, 2, '43mobulletcurve', '43 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 47, NULL, '', NULL, 'TPP-8278', '2025-07-01 12:07:36.637', 'TPP-8278', '2025-07-01 12:07:36.637'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '44mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1271, 'C', 4, 2, 2, '44mobulletcurve', '44 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 48, NULL, '', NULL, 'TPP-8278', '2025-07-01 12:08:58.543', 'TPP-8278', '2025-07-01 12:08:58.543'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '45mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1272, 'C', 4, 2, 2, '45mobulletcurve', '45 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 49, NULL, '', NULL, 'TPP-8278', '2025-07-01 12:10:35.407', 'TPP-8278', '2025-07-01 12:10:35.407'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '46mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1273, 'C', 4, 2, 2, '46mobulletcurve', '46 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 50, NULL, '', NULL, 'TPP-8278', '2025-07-01 12:14:59.060', 'TPP-8278', '2025-07-01 12:14:59.060'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '47mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1274, 'C', 4, 2, 2, '47mobulletcurve', '47 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 51, NULL, '', NULL, 'TPP-8278', '2025-07-01 12:32:19.157', 'TPP-8278', '2025-07-01 12:32:19.157'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '48mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        19, 'C', 4, 2, 2, '48mobulletcurve', '48 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 52, NULL, '', NULL, 'TPP-8278', '2025-07-01 12:34:08.493', 'TPP-8278', '2025-07-01 12:34:08.493'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '49mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1275, 'C', 4, 2, 2, '49mobulletcurve', '49 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 53, NULL, '', NULL, 'TPP-8278', '2025-07-01 12:35:50.910', 'TPP-8278', '2025-07-01 12:35:50.910'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '50mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1276, 'C', 4, 2, 2, '50mobulletcurve', '50 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 54, NULL, '', NULL, 'TPP-8278', '2025-07-01 12:37:20.217', 'TPP-8278', '2025-07-01 12:37:20.217'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '51mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1277, 'C', 4, 2, 2, '51mobulletcurve', '51 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 55, NULL, '', NULL, 'TPP-8278', '2025-07-02 08:34:34.910', 'TPP-8278', '2025-07-02 08:34:34.910'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '52mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1278, 'C', 4, 2, 2, '52mobulletcurve', '52 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 56, NULL, '', NULL, 'TPP-8278', '2025-07-02 09:19:59.710', 'TPP-8278', '2025-07-02 09:19:59.710'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '53mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1279, 'C', 4, 2, 2, '53mobulletcurve', '53 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 57, NULL, '', NULL, 'TPP-8278', '2025-07-02 11:11:16.813', 'TPP-8278', '2025-07-02 11:11:16.813'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '54mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1280, 'C', 4, 2, 2, '54mobulletcurve', '54 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 58, NULL, '', NULL, 'TPP-8278', '2025-07-02 11:23:09.090', 'TPP-8278', '2025-07-02 11:23:09.090'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '80mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1304, 'C', 4, 2, 2, '80mobulletcurve', '80 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 84, NULL, '', NULL, 'TPP-8278', '2025-07-02 11:23:12.717', 'TPP-8278', '2025-07-02 11:23:12.717'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '81mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1305, 'C', 4, 2, 2, '81mobulletcurve', '81 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 85, NULL, '', NULL, 'TPP-8278', '2025-07-02 11:25:43.310', 'TPP-8278', '2025-07-02 11:25:43.310'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '82mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1306, 'C', 4, 2, 2, '82mobulletcurve', '82 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 86, NULL, '', NULL, 'TPP-8278', '2025-07-02 11:26:54.660', 'TPP-8278', '2025-07-02 11:26:54.660'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '83mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1307, 'C', 4, 2, 2, '83mobulletcurve', '83 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 87, NULL, '', NULL, 'TPP-8278', '2025-07-02 11:29:11.390', 'TPP-8278', '2025-07-02 11:29:11.390'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '55mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1281, 'C', 4, 2, 2, '55mobulletcurve', '55 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 59, NULL, '', NULL, 'TPP-8278', '2025-07-02 11:29:44.730', 'TPP-8278', '2025-07-02 11:29:44.730'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '84mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        22, 'C', 4, 2, 2, '84mobulletcurve', '84 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 88, NULL, '', NULL, 'TPP-8278', '2025-07-02 11:30:45.657', 'TPP-8278', '2025-07-02 11:30:45.657'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '85mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1308, 'C', 4, 2, 2, '85mobulletcurve', '85 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 89, NULL, '', NULL, 'TPP-8278', '2025-07-02 11:33:01.207', 'TPP-8278', '2025-07-02 11:33:01.207'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '56mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1282, 'C', 4, 2, 2, '56mobulletcurve', '56 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 60, NULL, '', NULL, 'TPP-8278', '2025-07-02 11:33:28.037', 'TPP-8278', '2025-07-02 11:33:28.037'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '86mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1309, 'C', 4, 2, 2, '86mobulletcurve', '86 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 90, NULL, '', NULL, 'TPP-8278', '2025-07-02 11:34:01.543', 'TPP-8278', '2025-07-02 11:34:01.543'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '57mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1283, 'C', 4, 2, 2, '57mobulletcurve', '57 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 61, NULL, '', NULL, 'TPP-8278', '2025-07-02 11:34:45.257', 'TPP-8278', '2025-07-02 11:34:45.257'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '87mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1310, 'C', 4, 2, 2, '87mobulletcurve', '87 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 91, NULL, '', NULL, 'TPP-8278', '2025-07-02 11:34:48.297', 'TPP-8278', '2025-07-02 11:34:48.297'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '58mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1284, 'C', 4, 2, 2, '58mobulletcurve', '58 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 62, NULL, '', NULL, 'TPP-8278', '2025-07-02 11:35:54.880', 'TPP-8278', '2025-07-02 11:35:54.880'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '88mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1311, 'C', 4, 2, 2, '88mobulletcurve', '88 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 92, NULL, '', NULL, 'TPP-8278', '2025-07-02 11:36:12.193', 'TPP-8278', '2025-07-02 11:36:12.193'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '89mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1312, 'C', 4, 2, 2, '89mobulletcurve', '89 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 93, NULL, '', NULL, 'TPP-8278', '2025-07-02 11:37:34.190', 'TPP-8278', '2025-07-02 11:37:34.190'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '59mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1285, 'C', 4, 2, 2, '59mobulletcurve', '59 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 63, NULL, '', NULL, 'TPP-8278', '2025-07-02 11:38:11.673', 'TPP-8278', '2025-07-02 11:38:11.673'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '90mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1313, 'C', 4, 2, 2, '90mobulletcurve', '90 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 94, NULL, '', NULL, 'TPP-8278', '2025-07-02 11:38:48.990', 'TPP-8278', '2025-07-02 11:38:48.990'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '91mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1314, 'C', 4, 2, 2, '91mobulletcurve', '91 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 95, NULL, '', NULL, 'TPP-8278', '2025-07-02 11:40:11.897', 'TPP-8278', '2025-07-02 11:40:11.897'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '60mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        20, 'C', 4, 2, 2, '60mobulletcurve', '60 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 64, NULL, '', NULL, 'TPP-8278', '2025-07-02 11:40:51.283', 'TPP-8278', '2025-07-02 11:40:51.283'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '92mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1315, 'C', 4, 2, 2, '92mobulletcurve', '92 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 96, NULL, '', NULL, 'TPP-8278', '2025-07-02 11:41:26.267', 'TPP-8278', '2025-07-02 11:41:26.267'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '61mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1286, 'C', 4, 2, 2, '61mobulletcurve', '61 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 65, NULL, '', NULL, 'TPP-8278', '2025-07-02 11:42:31.180', 'TPP-8278', '2025-07-02 11:42:31.180'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '93mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1316, 'C', 4, 2, 2, '93mobulletcurve', '93 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 97, NULL, '', NULL, 'TPP-8278', '2025-07-02 11:43:52.900', 'TPP-8278', '2025-07-02 11:43:52.900'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '62mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1287, 'C', 4, 2, 2, '62mobulletcurve', '62 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 66, NULL, '', NULL, 'TPP-8278', '2025-07-02 11:44:37.523', 'TPP-8278', '2025-07-02 11:44:37.523'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '94mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1317, 'C', 4, 2, 2, '94mobulletcurve', '94 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 98, NULL, '', NULL, 'TPP-8278', '2025-07-02 11:44:47.067', 'TPP-8278', '2025-07-02 11:44:47.067'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '95mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1318, 'C', 4, 2, 2, '95mobulletcurve', '95 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 99, NULL, '', NULL, 'TPP-8278', '2025-07-02 11:45:41.090', 'TPP-8278', '2025-07-02 11:45:41.090'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '63mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1288, 'C', 4, 2, 2, '63mobulletcurve', '63 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 67, NULL, '', NULL, 'TPP-8278', '2025-07-02 11:46:10.757', 'TPP-8278', '2025-07-02 11:46:10.757'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '96mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        23, 'C', 4, 2, 2, '96mobulletcurve', '96 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 100, NULL, '', NULL, 'TPP-8278', '2025-07-02 11:47:30.307', 'TPP-8278', '2025-07-02 11:47:30.307'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '64mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1289, 'C', 4, 2, 2, '64mobulletcurve', '64 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 68, NULL, '', NULL, 'TPP-8278', '2025-07-02 11:48:22.660', 'TPP-8278', '2025-07-02 11:48:22.660'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '97mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1319, 'C', 4, 2, 2, '97mobulletcurve', '97 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 101, NULL, '', NULL, 'TPP-8278', '2025-07-02 11:48:42.437', 'TPP-8278', '2025-07-02 11:48:42.437'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '98mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1320, 'C', 4, 2, 2, '98mobulletcurve', '98 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 102, NULL, '', NULL, 'TPP-8278', '2025-07-02 11:49:35.340', 'TPP-8278', '2025-07-02 11:49:35.340'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '99mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1321, 'C', 4, 2, 2, '99mobulletcurve', '99 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 103, NULL, '', NULL, 'TPP-8278', '2025-07-02 11:50:43.330', 'TPP-8278', '2025-07-02 11:50:43.330'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '65mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1290, 'C', 4, 2, 2, '65mobulletcurve', '65 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 69, NULL, '', NULL, 'TPP-8278', '2025-07-02 11:51:23.080', 'TPP-8278', '2025-07-02 11:51:23.080'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '66mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1291, 'C', 4, 2, 2, '66mobulletcurve', '66 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 70, NULL, '', NULL, 'TPP-8278', '2025-07-02 11:53:02.320', 'TPP-8278', '2025-07-02 11:53:02.320'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '102mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1324, 'C', 4, 2, 2, '102mobulletcurve', '102 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 106, NULL, '', NULL, 'TPP-8278', '2025-07-02 11:53:21.043', 'TPP-8278', '2025-07-02 11:53:21.043'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '103mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1325, 'C', 4, 2, 2, '103mobulletcurve', '103 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 107, NULL, '', NULL, 'TPP-8278', '2025-07-02 11:54:09.090', 'TPP-8278', '2025-07-02 11:54:09.090'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '104mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1326, 'C', 4, 2, 2, '104mobulletcurve', '104 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 108, NULL, '', NULL, 'TPP-8278', '2025-07-02 11:55:16.757', 'TPP-8278', '2025-07-02 11:55:16.757'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '105mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1327, 'C', 4, 2, 2, '105mobulletcurve', '105 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 109, NULL, '', NULL, 'TPP-8278', '2025-07-02 11:56:15.930', 'TPP-8278', '2025-07-02 11:56:15.930'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '67mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1292, 'C', 4, 2, 2, '67mobulletcurve', '67 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 71, NULL, '', NULL, 'TPP-8278', '2025-07-02 11:57:13.880', 'TPP-8278', '2025-07-02 11:57:13.880'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '106mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1328, 'C', 4, 2, 2, '106mobulletcurve', '106 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 110, NULL, '', NULL, 'TPP-8278', '2025-07-02 11:58:15.900', 'TPP-8278', '2025-07-02 11:58:15.900'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '107mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1329, 'C', 4, 2, 2, '107mobulletcurve', '107 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 111, NULL, '', NULL, 'TPP-8278', '2025-07-02 11:59:16.177', 'TPP-8278', '2025-07-02 11:59:16.177'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '108mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        24, 'C', 4, 2, 2, '108mobulletcurve', '108 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 112, NULL, '', NULL, 'TPP-8278', '2025-07-02 12:00:13.577', 'TPP-8278', '2025-07-02 12:00:13.577'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '109mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1330, 'C', 4, 2, 2, '109mobulletcurve', '109 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 113, NULL, '', NULL, 'TPP-8278', '2025-07-02 12:01:50.883', 'TPP-8278', '2025-07-02 12:01:50.883'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '110mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1331, 'C', 4, 2, 2, '110mobulletcurve', '110 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 114, NULL, '', NULL, 'TPP-8278', '2025-07-02 12:03:29.857', 'TPP-8278', '2025-07-02 12:03:29.857'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '111mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1332, 'C', 4, 2, 2, '111mobulletcurve', '111 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 115, NULL, '', NULL, 'TPP-8278', '2025-07-02 12:06:55.490', 'TPP-8278', '2025-07-02 12:06:55.490'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '68mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1293, 'C', 4, 2, 2, '68mobulletcurve', '68 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 72, NULL, '', NULL, 'TPP-8278', '2025-07-02 12:07:31.943', 'TPP-8278', '2025-07-02 12:07:31.943'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '112mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1333, 'C', 4, 2, 2, '112mobulletcurve', '112 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 116, NULL, '', NULL, 'TPP-8278', '2025-07-02 12:07:58.800', 'TPP-8278', '2025-07-02 12:07:58.800'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '113mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1334, 'C', 4, 2, 2, '113mobulletcurve', '113 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 117, NULL, '', NULL, 'TPP-8278', '2025-07-02 12:09:45.967', 'TPP-8278', '2025-07-02 12:09:45.967'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '69mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1294, 'C', 4, 2, 2, '69mobulletcurve', '69 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 73, NULL, '', NULL, 'TPP-8278', '2025-07-02 12:10:53.403', 'TPP-8278', '2025-07-02 12:10:53.403'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '114mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1335, 'C', 4, 2, 2, '114mobulletcurve', '114 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 118, NULL, '', NULL, 'TPP-8278', '2025-07-02 12:11:05.900', 'TPP-8278', '2025-07-02 12:11:05.900'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '115mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1336, 'C', 4, 2, 2, '115mobulletcurve', '115 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 119, NULL, '', NULL, 'TPP-8278', '2025-07-02 12:12:06.800', 'TPP-8278', '2025-07-02 12:12:06.800'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '116mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1337, 'C', 4, 2, 2, '116mobulletcurve', '116 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 120, NULL, '', NULL, 'TPP-8278', '2025-07-02 12:13:10.513', 'TPP-8278', '2025-07-02 12:13:10.513'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '117mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1338, 'C', 4, 2, 2, '117mobulletcurve', '117 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 121, NULL, '', NULL, 'TPP-8278', '2025-07-02 12:14:21.237', 'TPP-8278', '2025-07-02 12:14:21.237'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '70mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1295, 'C', 4, 2, 2, '70mobulletcurve', '70 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 74, NULL, '', NULL, 'TPP-8278', '2025-07-02 12:14:30.280', 'TPP-8278', '2025-07-02 12:14:30.280'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '118mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1339, 'C', 4, 2, 2, '118mobulletcurve', '118 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 122, NULL, '', NULL, 'TPP-8278', '2025-07-02 12:15:31.597', 'TPP-8278', '2025-07-02 12:15:31.597'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '119mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1340, 'C', 4, 2, 2, '119mobulletcurve', '119 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 123, NULL, '', NULL, 'TPP-8278', '2025-07-02 12:16:23.487', 'TPP-8278', '2025-07-08 11:53:37.697'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '71mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1296, 'C', 4, 2, 2, '71mobulletcurve', '71 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 75, NULL, '', NULL, 'TPP-8278', '2025-07-02 12:16:24.307', 'TPP-8278', '2025-07-02 12:16:24.307'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '72mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        21, 'C', 4, 2, 2, '72mobulletcurve', '72 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 76, NULL, '', NULL, 'TPP-8278', '2025-07-02 12:17:23.160', 'TPP-8278', '2025-07-08 11:54:30.083'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '73mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1297, 'C', 4, 2, 2, '73mobulletcurve', '73 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 77, NULL, '', NULL, 'TPP-8278', '2025-07-02 12:19:10.753', 'TPP-8278', '2025-07-02 12:19:10.753'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '120mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        25, 'C', 4, 2, 2, '120mobulletcurve', '120 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 124, NULL, '', NULL, 'TPP-8278', '2025-07-02 12:20:27.907', 'TPP-8278', '2025-07-08 11:55:36.120'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '121mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1341, 'C', 4, 2, 2, '121mobulletcurve', '121 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 125, NULL, '', NULL, 'TPP-8278', '2025-07-02 12:21:40.680', 'TPP-8278', '2025-07-02 12:21:40.680'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '122mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1342, 'C', 4, 2, 2, '122mobulletcurve', '122 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 126, NULL, '', NULL, 'TPP-8278', '2025-07-02 12:23:16.920', 'TPP-8278', '2025-07-02 12:23:16.920'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '123mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1343, 'C', 4, 2, 2, '123mobulletcurve', '123 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 127, NULL, '', NULL, 'TPP-8278', '2025-07-02 12:25:06.350', 'TPP-8278', '2025-07-02 12:25:06.350'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '74mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1298, 'C', 4, 2, 2, '74mobulletcurve', '74 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 78, NULL, '', NULL, 'TPP-8278', '2025-07-02 12:25:06.687', 'TPP-8278', '2025-07-02 12:25:06.687'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '124mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1344, 'C', 4, 2, 2, '124mobulletcurve', '124 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 128, NULL, '', NULL, 'TPP-8278', '2025-07-02 12:27:44.770', 'TPP-8278', '2025-07-02 12:27:44.770'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '125mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1345, 'C', 4, 2, 2, '125mobulletcurve', '125 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 129, NULL, '', NULL, 'TPP-8278', '2025-07-02 12:30:11.160', 'TPP-8278', '2025-07-02 12:30:11.160'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '126mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1346, 'C', 4, 2, 2, '126mobulletcurve', '126 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 130, NULL, '', NULL, 'TPP-8278', '2025-07-02 12:32:06.227', 'TPP-8278', '2025-07-02 12:32:06.227'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '127mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1347, 'C', 4, 2, 2, '127mobulletcurve', '127 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 131, NULL, '', NULL, 'TPP-8278', '2025-07-02 12:33:31.177', 'TPP-8278', '2025-07-02 12:33:31.177'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '75mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1299, 'C', 4, 2, 2, '75mobulletcurve', '75 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 79, NULL, '', NULL, 'TPP-8278', '2025-07-02 12:35:20.910', 'TPP-8278', '2025-07-02 12:35:20.910'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '128mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1348, 'C', 4, 2, 2, '128mobulletcurve', '128 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 132, NULL, '', NULL, 'TPP-8278', '2025-07-02 12:35:33.223', 'TPP-8278', '2025-07-02 12:35:33.223'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '76mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1300, 'C', 4, 2, 2, '76mobulletcurve', '76 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 80, NULL, '', NULL, 'TPP-8278', '2025-07-02 12:37:12.280', 'TPP-8278', '2025-07-02 12:37:12.280'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '129mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1349, 'C', 4, 2, 2, '129mobulletcurve', '129 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 133, NULL, '', NULL, 'TPP-8278', '2025-07-02 12:37:14.843', 'TPP-8278', '2025-07-02 12:37:14.843'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '130mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1350, 'C', 4, 2, 2, '130mobulletcurve', '130 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 134, NULL, '', NULL, 'TPP-8278', '2025-07-02 12:38:31.397', 'TPP-8278', '2025-07-02 12:38:31.397'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '77mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1301, 'C', 4, 2, 2, '77mobulletcurve', '77 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 81, NULL, '', NULL, 'TPP-8278', '2025-07-02 12:42:45.493', 'TPP-8278', '2025-07-02 12:42:45.493'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '78mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1302, 'C', 4, 2, 2, '78mobulletcurve', '78 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 82, NULL, '', NULL, 'TPP-8278', '2025-07-02 12:46:59.217', 'TPP-8278', '2025-07-02 12:46:59.217'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '79mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1303, 'C', 4, 2, 2, '79mobulletcurve', '79 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 83, NULL, '', NULL, 'TPP-8278', '2025-07-02 12:48:07.387', 'TPP-8278', '2025-07-02 12:48:07.387'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '180mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        27, 'C', 4, 2, 2, '180mobulletcurve', '180 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 184, NULL, '', NULL, 'TPP-8278', '2025-07-08 10:33:34.323', 'TPP-8278', '2025-07-08 10:33:34.323'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '179mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1398, 'C', 4, 2, 2, '179mobulletcurve', '179 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 183, NULL, '', NULL, 'TPP-8278', '2025-07-08 10:34:54.100', 'TPP-8278', '2025-07-08 10:34:54.100'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '178mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1397, 'C', 4, 2, 2, '178mobulletcurve', '178 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 182, NULL, '', NULL, 'TPP-8278', '2025-07-08 10:36:07.530', 'TPP-8278', '2025-07-08 10:36:07.530'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '177mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1396, 'C', 4, 2, 2, '177mobulletcurve', '177 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 181, NULL, '', NULL, 'TPP-8278', '2025-07-08 10:37:47.567', 'TPP-8278', '2025-07-08 10:37:47.567'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '176mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1395, 'C', 4, 2, 2, '176mobulletcurve', '176 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 180, NULL, '', NULL, 'TPP-8278', '2025-07-08 10:39:02.310', 'TPP-8278', '2025-07-08 10:39:02.310'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '175mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1394, 'C', 4, 2, 2, '175mobulletcurve', '175 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 179, NULL, '', NULL, 'TPP-8278', '2025-07-08 10:40:04.650', 'TPP-8278', '2025-07-08 10:40:04.650'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '174mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1393, 'C', 4, 2, 2, '174mobulletcurve', '174 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 178, NULL, '', NULL, 'TPP-8278', '2025-07-08 10:41:38.373', 'TPP-8278', '2025-07-08 11:54:05.383'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '173mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1392, 'C', 4, 2, 2, '173mobulletcurve', '173 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 177, NULL, '', NULL, 'TPP-8278', '2025-07-08 10:44:15.390', 'TPP-8278', '2025-07-08 10:44:15.390'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '172mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1391, 'C', 4, 2, 2, '172mobulletcurve', '172 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 176, NULL, '', NULL, 'TPP-8278', '2025-07-08 10:47:51.650', 'TPP-8278', '2025-07-08 10:47:51.650'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '131mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1351, 'C', 4, 2, 2, '131mobulletcurve', '131 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 135, NULL, '', NULL, 'TPP-8278', '2025-07-08 10:48:06.603', 'TPP-8278', '2025-07-08 10:48:06.603'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '171mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1390, 'C', 4, 2, 2, '171mobulletcurve', '171 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 175, NULL, '', NULL, 'TPP-8278', '2025-07-08 10:49:09.383', 'TPP-8278', '2025-07-08 10:49:09.383'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '132mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1352, 'C', 4, 2, 2, '132mobulletcurve', '132 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 136, NULL, '', NULL, 'TPP-8278', '2025-07-08 10:49:43.317', 'TPP-8278', '2025-07-08 10:49:43.317'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '170mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1389, 'C', 4, 2, 2, '170mobulletcurve', '170 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 174, NULL, '', NULL, 'TPP-8278', '2025-07-08 10:51:41.347', 'TPP-8278', '2025-07-08 10:51:41.347'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '169mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1388, 'C', 4, 2, 2, '169mobulletcurve', '169 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 173, NULL, '', NULL, 'TPP-8278', '2025-07-08 10:53:44.280', 'TPP-8278', '2025-07-08 10:53:44.280'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '133mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1353, 'C', 4, 2, 2, '133mobulletcurve', '133 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 137, NULL, '', NULL, 'TPP-8278', '2025-07-08 10:54:18.147', 'TPP-8278', '2025-07-08 10:54:18.147'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '168mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1387, 'C', 4, 2, 2, '168mobulletcurve', '168 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 172, NULL, '', NULL, 'TPP-8278', '2025-07-08 10:55:20.097', 'TPP-8278', '2025-07-08 10:55:20.097'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '167mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1386, 'C', 4, 2, 2, '167mobulletcurve', '167 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 171, NULL, '', NULL, 'TPP-8278', '2025-07-08 10:56:17.293', 'TPP-8278', '2025-07-08 10:56:17.293'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '134mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1354, 'C', 4, 2, 2, '134mobulletcurve', '134 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 138, NULL, '', NULL, 'TPP-8278', '2025-07-08 10:56:26.417', 'TPP-8278', '2025-07-08 10:56:26.417'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '166mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1385, 'C', 4, 2, 2, '166mobulletcurve', '166 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 170, NULL, '', NULL, 'TPP-8278', '2025-07-08 10:58:10.800', 'TPP-8278', '2025-07-08 10:58:10.800'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '135mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1355, 'C', 4, 2, 2, '135mobulletcurve', '135 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 139, NULL, '', NULL, 'TPP-8278', '2025-07-08 10:58:16.533', 'TPP-8278', '2025-07-08 10:58:16.533'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '165mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1384, 'C', 4, 2, 2, '165mobulletcurve', '165 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 169, NULL, '', NULL, 'TPP-8278', '2025-07-08 10:59:14.700', 'TPP-8278', '2025-07-08 10:59:14.700'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '136mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1356, 'C', 4, 2, 2, '136mobulletcurve', '136 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 140, NULL, '', NULL, 'TPP-8278', '2025-07-08 10:59:49.260', 'TPP-8278', '2025-07-08 10:59:49.260'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '164mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1383, 'C', 4, 2, 2, '164mobulletcurve', '164 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 168, NULL, '', NULL, 'TPP-8278', '2025-07-08 11:00:14.973', 'TPP-8278', '2025-07-08 11:00:14.973'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '163mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1382, 'C', 4, 2, 2, '163mobulletcurve', '163 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 167, NULL, '', NULL, 'TPP-8278', '2025-07-08 11:02:08.890', 'TPP-8278', '2025-07-08 11:02:08.890'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '137mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1357, 'C', 4, 2, 2, '137mobulletcurve', '137 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 141, NULL, '', NULL, 'TPP-8278', '2025-07-08 11:02:27.557', 'TPP-8278', '2025-07-08 11:02:27.557'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '162mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1381, 'C', 4, 2, 2, '162mobulletcurve', '162 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 166, NULL, '', NULL, 'TPP-8278', '2025-07-08 11:03:11.527', 'TPP-8278', '2025-07-08 11:03:11.527'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '161mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1380, 'C', 4, 2, 2, '161mobulletcurve', '161 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 165, NULL, '', NULL, 'TPP-8278', '2025-07-08 11:04:16.470', 'TPP-8278', '2025-07-08 11:04:16.470'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '160mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1379, 'C', 4, 2, 2, '160mobulletcurve', '160 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 164, NULL, '', NULL, 'TPP-8278', '2025-07-08 11:05:18.043', 'TPP-8278', '2025-07-08 11:05:18.043'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '159mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1378, 'C', 4, 2, 2, '159mobulletcurve', '159 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 163, NULL, '', NULL, 'TPP-8278', '2025-07-08 11:06:40.983', 'TPP-8278', '2025-07-08 11:06:40.983'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '158mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1377, 'C', 4, 2, 2, '158mobulletcurve', '158 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 162, NULL, '', NULL, 'TPP-8278', '2025-07-08 11:07:40.247', 'TPP-8278', '2025-07-08 11:07:40.247'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '157mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1376, 'C', 4, 2, 2, '157mobulletcurve', '157 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 161, NULL, '', NULL, 'TPP-8278', '2025-07-08 11:08:33.030', 'TPP-8278', '2025-07-08 11:08:33.030'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '156mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1375, 'C', 4, 2, 2, '156mobulletcurve', '156 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 160, NULL, '', NULL, 'TPP-8278', '2025-07-08 11:09:59.223', 'TPP-8278', '2025-07-08 11:09:59.223'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '155mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1374, 'C', 4, 2, 2, '155mobulletcurve', '155 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 159, NULL, '', NULL, 'TPP-8278', '2025-07-08 11:11:17.677', 'TPP-8278', '2025-07-08 11:11:17.677'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '154mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1373, 'C', 4, 2, 2, '154mobulletcurve', '154 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 158, NULL, '', NULL, 'TPP-8278', '2025-07-08 11:12:10.773', 'TPP-8278', '2025-07-08 11:12:10.773'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '153mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1372, 'C', 4, 2, 2, '153mobulletcurve', '153 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 157, NULL, '', NULL, 'TPP-8278', '2025-07-08 11:13:27.127', 'TPP-8278', '2025-07-08 11:13:27.127'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '152mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1371, 'C', 4, 2, 2, '152mobulletcurve', '152 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 156, NULL, '', NULL, 'TPP-8278', '2025-07-08 11:14:33.200', 'TPP-8278', '2025-07-08 11:14:33.200'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '151mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1370, 'C', 4, 2, 2, '151mobulletcurve', '151 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 155, NULL, '', NULL, 'TPP-8278', '2025-07-08 11:16:42.177', 'TPP-8278', '2025-07-08 11:16:42.177'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '150mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1369, 'C', 4, 2, 2, '150mobulletcurve', '150 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 154, NULL, '', NULL, 'TPP-8278', '2025-07-08 11:17:41.270', 'TPP-8278', '2025-07-08 11:17:41.270'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '138mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1358, 'C', 4, 2, 2, '138mobulletcurve', '138 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 142, NULL, '', NULL, 'TPP-8278', '2025-07-08 11:24:47.170', 'TPP-8278', '2025-07-08 11:24:47.170'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '139mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1359, 'C', 4, 2, 2, '139mobulletcurve', '139 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 143, NULL, '', NULL, 'TPP-8278', '2025-07-08 11:25:57.227', 'TPP-8278', '2025-07-08 11:25:57.227'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '149mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1368, 'C', 4, 2, 2, '149mobulletcurve', '149 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 153, NULL, '', NULL, 'TPP-8278', '2025-07-08 11:27:08.843', 'TPP-8278', '2025-07-08 11:27:08.843'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '140mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1360, 'C', 4, 2, 2, '140mobulletcurve', '140 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 144, NULL, '', NULL, 'TPP-8278', '2025-07-08 11:28:10.343', 'TPP-8278', '2025-07-08 11:28:10.343'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '148mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1367, 'C', 4, 2, 2, '148mobulletcurve', '148 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 152, NULL, '', NULL, 'TPP-8278', '2025-07-08 11:29:14.970', 'TPP-8278', '2025-07-08 11:29:14.970'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '141mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1361, 'C', 4, 2, 2, '141mobulletcurve', '141 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 145, NULL, '', NULL, 'TPP-8278', '2025-07-08 11:30:59.770', 'TPP-8278', '2025-07-08 11:30:59.770'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '147mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1366, 'C', 4, 2, 2, '147mobulletcurve', '147 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 151, NULL, '', NULL, 'TPP-8278', '2025-07-08 11:32:26.767', 'TPP-8278', '2025-07-08 11:32:26.767'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '142mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1362, 'C', 4, 2, 2, '142mobulletcurve', '142 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 146, NULL, '', NULL, 'TPP-8278', '2025-07-08 11:33:38.987', 'TPP-8278', '2025-07-08 11:33:38.987'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '146mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1365, 'C', 4, 2, 2, '146mobulletcurve', '146 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 150, NULL, '', NULL, 'TPP-8278', '2025-07-08 11:34:51.833', 'TPP-8278', '2025-07-08 11:34:51.833'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '143mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1363, 'C', 4, 2, 2, '143mobulletcurve', '143 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 147, NULL, '', NULL, 'TPP-8278', '2025-07-08 11:38:35.123', 'TPP-8278', '2025-07-08 11:38:35.123'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '145mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        1364, 'C', 4, 2, 2, '145mobulletcurve', '145 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 149, NULL, '', NULL, 'TPP-8278', '2025-07-08 11:40:41.343', 'TPP-8278', '2025-07-08 11:40:41.343'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '144mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DBC')  ,
        26, 'C', 4, 2, 2, '144mobulletcurve', '144 month Annual Bullet Rate ', -1, NULL, 0, NULL, NULL, 148, NULL, '', NULL, 'TPP-8278', '2025-07-08 11:41:55.817', 'TPP-8278', '2025-07-08 11:41:55.817'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '181mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1399, 'C', 4, 2, 2, '181mobulletcurve', '181 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 1, NULL, '', NULL, 'TPP-8278', '2025-07-14 10:58:38.023', 'TPP-8278', '2025-07-14 11:22:31.160'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '182mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1400, 'C', 4, 2, 2, '182mobulletcurve', '182 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 2, NULL, '', NULL, 'TPP-8278', '2025-07-14 10:59:40.963', 'TPP-8278', '2025-07-14 11:22:42.887'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '183mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1401, 'C', 4, 2, 2, '183mobulletcurve', '183 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 3, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:00:38.987', 'TPP-8278', '2025-07-14 11:22:56.567'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '184mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1402, 'C', 4, 2, 2, '184mobulletcurve', '184 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 4, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:01:40.543', 'TPP-8278', '2025-07-14 11:23:07.810'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '185mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1403, 'C', 4, 2, 2, '185mobulletcurve', '185 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 5, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:03:22.320', 'TPP-8278', '2025-07-14 11:23:18.553'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '186mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1404, 'C', 4, 2, 2, '186mobulletcurve', '186 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 6, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:04:37.427', 'TPP-8278', '2025-07-14 11:23:34.627'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '187mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1405, 'C', 4, 2, 2, '187mobulletcurve', '187 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 7, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:16:27.520', 'TPP-8278', '2025-07-14 11:23:46.757'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '188mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1406, 'C', 4, 2, 2, '188mobulletcurve', '188 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 8, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:17:27.713', 'TPP-8278', '2025-07-14 11:23:56.733'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '189mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1407, 'C', 4, 2, 2, '189mobulletcurve', '189 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 9, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:18:29.890', 'TPP-8278', '2025-07-14 11:24:06.770'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '190mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1408, 'C', 4, 2, 2, '190mobulletcurve', '190 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 10, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:19:30.363', 'TPP-8278', '2025-07-14 11:24:15.933'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '191mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1409, 'C', 4, 2, 2, '191mobulletcurve', '191 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 11, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:20:29.520', 'TPP-8278', '2025-07-14 11:24:25.110'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '360mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        29, 'C', 4, 2, 2, '360mobulletcurve', '360 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 180, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:29:36.747', 'TPP-8278', '2025-07-14 11:29:36.747'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '359mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1576, 'C', 4, 2, 2, '359mobulletcurve', '359 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 179, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:31:02.363', 'TPP-8278', '2025-07-14 11:31:02.363'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '192mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1410, 'C', 4, 2, 2, '192mobulletcurve', '192 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 12, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:32:21.043', 'TPP-8278', '2025-07-14 11:32:21.043'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '193mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1411, 'C', 4, 2, 2, '193mobulletcurve', '193 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 13, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:34:00.237', 'TPP-8278', '2025-07-14 11:34:00.237'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '358mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1575, 'C', 4, 2, 2, '358mobulletcurve', '358 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 178, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:34:29.147', 'TPP-8278', '2025-07-14 11:34:29.147'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '194mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1412, 'C', 4, 2, 2, '194mobulletcurve', '194 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 14, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:35:12.470', 'TPP-8278', '2025-07-14 11:35:12.470'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '357mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1574, 'C', 4, 2, 2, '357mobulletcurve', '357 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 177, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:35:27.220', 'TPP-8278', '2025-07-14 11:35:27.220'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '195mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1413, 'C', 4, 2, 2, '195mobulletcurve', '195 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 15, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:36:29.827', 'TPP-8278', '2025-07-14 11:36:29.827'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '356mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1573, 'C', 4, 2, 2, '356mobulletcurve', '356 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 176, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:36:49.253', 'TPP-8278', '2025-07-14 11:36:49.253'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '196mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1414, 'C', 4, 2, 2, '196mobulletcurve', '196 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 16, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:37:24.330', 'TPP-8278', '2025-07-14 11:37:24.330'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '355mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1572, 'C', 4, 2, 2, '355mobulletcurve', '355 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 175, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:37:56.227', 'TPP-8278', '2025-07-14 11:37:56.227'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '354mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1571, 'C', 4, 2, 2, '354mobulletcurve', '354 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 174, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:38:49.290', 'TPP-8278', '2025-07-14 11:38:49.290'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '197mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1415, 'C', 4, 2, 2, '197mobulletcurve', '197 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 17, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:38:53.833', 'TPP-8278', '2025-07-14 11:38:53.833'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '353mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1570, 'C', 4, 2, 2, '353mobulletcurve', '353 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 173, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:39:54.387', 'TPP-8278', '2025-07-14 11:39:54.387'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '198mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1416, 'C', 4, 2, 2, '198mobulletcurve', '198 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 18, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:40:30.887', 'TPP-8278', '2025-07-14 11:40:30.887'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '352mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1569, 'C', 4, 2, 2, '352mobulletcurve', '352 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 172, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:40:56.183', 'TPP-8278', '2025-07-14 11:40:56.183'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '199mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1417, 'C', 4, 2, 2, '199mobulletcurve', '199 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 19, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:41:26.760', 'TPP-8278', '2025-07-14 11:41:26.760'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '351mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1568, 'C', 4, 2, 2, '351mobulletcurve', '351 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 171, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:41:58.627', 'TPP-8278', '2025-07-14 11:41:58.627'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '201mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1419, 'C', 4, 2, 2, '201mobulletcurve', '201 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 21, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:42:37.273', 'TPP-8278', '2025-07-14 11:42:37.273'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '350mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1567, 'C', 4, 2, 2, '350mobulletcurve', '350 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 170, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:43:29.810', 'TPP-8278', '2025-07-14 11:43:29.810'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '349mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1566, 'C', 4, 2, 2, '349mobulletcurve', '349 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 169, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:44:22.067', 'TPP-8278', '2025-07-14 11:44:22.067'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '202mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1420, 'C', 4, 2, 2, '202mobulletcurve', '202 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 22, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:45:10.607', 'TPP-8278', '2025-07-14 11:45:10.607'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '348mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1565, 'C', 4, 2, 2, '348mobulletcurve', '348 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 168, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:45:34.177', 'TPP-8278', '2025-07-14 11:45:34.177'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '347mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1564, 'C', 4, 2, 2, '347mobulletcurve', '347 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 167, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:46:50.683', 'TPP-8278', '2025-07-14 11:46:50.683'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '346mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1563, 'C', 4, 2, 2, '346mobulletcurve', '346 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 166, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:48:26.080', 'TPP-8278', '2025-07-14 11:48:26.080'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '203mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1421, 'C', 4, 2, 2, '203mobulletcurve', '203 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 23, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:49:07.097', 'TPP-8278', '2025-07-14 11:49:07.097'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '345mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1562, 'C', 4, 2, 2, '345mobulletcurve', '345 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 165, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:49:32.730', 'TPP-8278', '2025-07-14 11:49:32.730'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '344mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1561, 'C', 4, 2, 2, '344mobulletcurve', '344 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 164, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:50:27.193', 'TPP-8278', '2025-07-14 11:50:27.193'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '204mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1422, 'C', 4, 2, 2, '204mobulletcurve', '204 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 24, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:51:03.170', 'TPP-8278', '2025-07-14 11:51:03.170'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '343mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1560, 'C', 4, 2, 2, '343mobulletcurve', '343 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 163, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:52:19.047', 'TPP-8278', '2025-07-14 11:52:19.047'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '342mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1559, 'C', 4, 2, 2, '342mobulletcurve', '342 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 162, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:53:47.663', 'TPP-8278', '2025-07-14 11:53:47.663'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '205mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1423, 'C', 4, 2, 2, '205mobulletcurve', '205 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 25, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:53:57.160', 'TPP-8278', '2025-07-14 11:53:57.160'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '341mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1558, 'C', 4, 2, 2, '341mobulletcurve', '341 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 161, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:55:00.080', 'TPP-8278', '2025-07-14 11:55:00.080'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '206mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1424, 'C', 4, 2, 2, '206mobulletcurve', '206 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 26, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:55:51.883', 'TPP-8278', '2025-07-14 11:55:51.883'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '340mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1557, 'C', 4, 2, 2, '340mobulletcurve', '340 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 160, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:56:02.170', 'TPP-8278', '2025-07-14 11:56:02.170'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '339mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1556, 'C', 4, 2, 2, '339mobulletcurve', '339 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 159, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:57:07.683', 'TPP-8278', '2025-07-14 11:57:07.683'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '207mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1425, 'C', 4, 2, 2, '207mobulletcurve', '207 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 27, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:57:48.443', 'TPP-8278', '2025-07-14 11:57:48.443'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '338mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1555, 'C', 4, 2, 2, '338mobulletcurve', '338 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 158, NULL, '', NULL, 'TPP-8278', '2025-07-14 11:58:05.307', 'TPP-8278', '2025-07-14 11:58:05.307'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '337mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1554, 'C', 4, 2, 2, '337mobulletcurve', '337 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 157, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:00:48.267', 'TPP-8278', '2025-07-14 12:00:48.267'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '336mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1553, 'C', 4, 2, 2, '336mobulletcurve', '336 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 156, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:01:51.820', 'TPP-8278', '2025-07-14 12:01:51.820'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '208mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1426, 'C', 4, 2, 2, '208mobulletcurve', '208 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 28, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:02:40.480', 'TPP-8278', '2025-07-14 12:02:40.480'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '335mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1552, 'C', 4, 2, 2, '335mobulletcurve', '335 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 155, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:02:50.110', 'TPP-8278', '2025-07-14 12:02:50.110'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '334mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1551, 'C', 4, 2, 2, '334mobulletcurve', '334 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 154, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:04:08.810', 'TPP-8278', '2025-07-14 12:04:08.810'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '333mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1550, 'C', 4, 2, 2, '333mobulletcurve', '333 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 153, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:04:55.020', 'TPP-8278', '2025-07-14 12:04:55.020'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '332mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1549, 'C', 4, 2, 2, '332mobulletcurve', '332 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 152, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:06:09.767', 'TPP-8278', '2025-07-14 12:06:09.767'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '331mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1548, 'C', 4, 2, 2, '331mobulletcurve', '331 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 151, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:07:04.600', 'TPP-8278', '2025-07-14 12:07:04.600'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '330mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1547, 'C', 4, 2, 2, '330mobulletcurve', '330 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 150, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:07:55.127', 'TPP-8278', '2025-07-14 12:07:55.127'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '329mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1546, 'C', 4, 2, 2, '329mobulletcurve', '329 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 149, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:08:51.450', 'TPP-8278', '2025-07-14 12:08:51.450'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '209mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1427, 'C', 4, 2, 2, '209mobulletcurve', '209 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 29, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:08:59.567', 'TPP-8278', '2025-07-14 12:08:59.567'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '328mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1545, 'C', 4, 2, 2, '328mobulletcurve', '328 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 148, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:10:02.880', 'TPP-8278', '2025-07-14 12:10:02.880'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '327mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1544, 'C', 4, 2, 2, '327mobulletcurve', '327 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 147, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:11:01.030', 'TPP-8278', '2025-07-14 12:11:01.030'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '210mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1428, 'C', 4, 2, 2, '210mobulletcurve', '210 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 30, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:11:40.763', 'TPP-8278', '2025-07-14 12:11:40.763'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '326mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1543, 'C', 4, 2, 2, '326mobulletcurve', '326 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 146, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:12:00.203', 'TPP-8278', '2025-07-14 12:12:00.203'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '211mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1429, 'C', 4, 2, 2, '211mobulletcurve', '211 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 31, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:13:46.993', 'TPP-8278', '2025-07-14 12:13:46.993'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '325mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1542, 'C', 4, 2, 2, '325mobulletcurve', '325 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 145, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:14:47.657', 'TPP-8278', '2025-07-14 12:14:47.657'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '212mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1430, 'C', 4, 2, 2, '212mobulletcurve', '212 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 32, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:15:45.827', 'TPP-8278', '2025-07-14 12:15:45.827'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '324mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1541, 'C', 4, 2, 2, '324mobulletcurve', '324 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 144, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:17:41.333', 'TPP-8278', '2025-07-14 12:17:41.333'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '213mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1431, 'C', 4, 2, 2, '213mobulletcurve', '213 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 33, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:18:25.287', 'TPP-8278', '2025-07-14 12:18:25.287'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '323mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1540, 'C', 4, 2, 2, '323mobulletcurve', '323 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 143, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:18:52.293', 'TPP-8278', '2025-07-14 12:18:52.293'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '322mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1539, 'C', 4, 2, 2, '322mobulletcurve', '322 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 142, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:19:42.547', 'TPP-8278', '2025-07-14 12:19:42.547'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '214mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1432, 'C', 4, 2, 2, '214mobulletcurve', '214 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 34, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:20:02.763', 'TPP-8278', '2025-07-14 12:20:02.763'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '321mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1538, 'C', 4, 2, 2, '321mobulletcurve', '321 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 141, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:21:10.193', 'TPP-8278', '2025-07-14 12:21:10.193'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '320mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1537, 'C', 4, 2, 2, '320mobulletcurve', '320 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 140, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:22:07.493', 'TPP-8278', '2025-07-14 12:22:07.493'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '319mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1536, 'C', 4, 2, 2, '319mobulletcurve', '319 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 139, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:23:53.287', 'TPP-8278', '2025-07-14 12:23:53.287'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '318mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1535, 'C', 4, 2, 2, '318mobulletcurve', '318 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 138, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:24:47.213', 'TPP-8278', '2025-07-14 12:24:47.213'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '215mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1433, 'C', 4, 2, 2, '215mobulletcurve', '215 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 35, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:25:10.183', 'TPP-8278', '2025-07-14 12:25:10.183'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '317mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1534, 'C', 4, 2, 2, '317mobulletcurve', '317 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 137, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:25:55.463', 'TPP-8278', '2025-07-14 12:25:55.463'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '316mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1533, 'C', 4, 2, 2, '316mobulletcurve', '316 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 136, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:26:41.010', 'TPP-8278', '2025-07-14 12:26:41.010'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '315mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1532, 'C', 4, 2, 2, '315mobulletcurve', '315 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 135, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:28:28.733', 'TPP-8278', '2025-07-14 12:28:28.733'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '216mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1434, 'C', 4, 2, 2, '216mobulletcurve', '216 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 36, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:28:53.857', 'TPP-8278', '2025-07-14 12:28:53.857'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '314mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1531, 'C', 4, 2, 2, '314mobulletcurve', '314 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 134, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:29:13.580', 'TPP-8278', '2025-07-14 12:29:13.580'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '217mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1435, 'C', 4, 2, 2, '217mobulletcurve', '217 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 37, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:29:49.997', 'TPP-8278', '2025-07-14 12:29:49.997'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '218mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1436, 'C', 4, 2, 2, '218mobulletcurve', '218 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 38, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:31:19.997', 'TPP-8278', '2025-07-14 12:31:19.997'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '313mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1530, 'C', 4, 2, 2, '313mobulletcurve', '313 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 133, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:31:24.290', 'TPP-8278', '2025-07-14 12:31:24.290'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '312mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1529, 'C', 4, 2, 2, '312mobulletcurve', '312 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 132, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:32:37.537', 'TPP-8278', '2025-07-14 12:32:37.537'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '219mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1437, 'C', 4, 2, 2, '219mobulletcurve', '219 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 39, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:33:04.090', 'TPP-8278', '2025-07-14 12:33:04.090'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '311mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1528, 'C', 4, 2, 2, '311mobulletcurve', '311 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 131, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:34:13.277', 'TPP-8278', '2025-07-14 12:34:13.277'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '220mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1438, 'C', 4, 2, 2, '220mobulletcurve', '220 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 40, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:34:20.410', 'TPP-8278', '2025-07-14 12:34:20.410'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '310mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1527, 'C', 4, 2, 2, '310mobulletcurve', '310 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 130, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:35:17.430', 'TPP-8278', '2025-07-14 12:35:17.430'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '309mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1526, 'C', 4, 2, 2, '309mobulletcurve', '309 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 129, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:37:43.380', 'TPP-8278', '2025-07-14 12:37:43.380'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '308mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1525, 'C', 4, 2, 2, '308mobulletcurve', '308 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 128, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:38:36.153', 'TPP-8278', '2025-07-14 12:38:36.153'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '307mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1524, 'C', 4, 2, 2, '307mobulletcurve', '307 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 127, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:39:29.983', 'TPP-8278', '2025-07-14 12:39:29.983'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '306mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1523, 'C', 4, 2, 2, '306mobulletcurve', '306 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 126, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:40:34.857', 'TPP-8278', '2025-07-14 12:40:34.857'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '305mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1522, 'C', 4, 2, 2, '305mobulletcurve', '305 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 125, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:41:28.687', 'TPP-8278', '2025-07-14 12:41:28.687'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '304mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1521, 'C', 4, 2, 2, '304mobulletcurve', '304 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 124, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:42:18.470', 'TPP-8278', '2025-07-14 12:42:18.470'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '303mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1520, 'C', 4, 2, 2, '303mobulletcurve', '303 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 123, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:43:14.557', 'TPP-8278', '2025-07-14 12:43:14.557'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '302mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1519, 'C', 4, 2, 2, '302mobulletcurve', '302 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 122, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:44:25.560', 'TPP-8278', '2025-07-14 12:44:25.560'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '301mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1518, 'C', 4, 2, 2, '301mobulletcurve', '301 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 121, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:45:20.357', 'TPP-8278', '2025-07-14 12:45:20.357'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '300mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1517, 'C', 4, 2, 2, '300mobulletcurve', '300 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 120, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:46:23.610', 'TPP-8278', '2025-07-14 12:46:23.610'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '221mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1439, 'C', 4, 2, 2, '221mobulletcurve', '221 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 41, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:46:46.637', 'TPP-8278', '2025-07-14 12:46:46.637'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '299mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1516, 'C', 4, 2, 2, '299mobulletcurve', '299 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 119, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:47:43.177', 'TPP-8278', '2025-07-14 12:47:43.177'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '222mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1440, 'C', 4, 2, 2, '222mobulletcurve', '222 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 42, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:47:46.773', 'TPP-8278', '2025-07-14 12:47:46.773'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '223mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1441, 'C', 4, 2, 2, '223mobulletcurve', '223 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 43, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:49:00.460', 'TPP-8278', '2025-07-14 12:49:00.460'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '298mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1515, 'C', 4, 2, 2, '298mobulletcurve', '298 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 118, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:49:17.757', 'TPP-8278', '2025-07-14 12:49:17.757'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '297mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1514, 'C', 4, 2, 2, '297mobulletcurve', '297 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 117, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:50:12.970', 'TPP-8278', '2025-07-14 12:50:12.970'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '296mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1513, 'C', 4, 2, 2, '296mobulletcurve', '296 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 116, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:51:26.487', 'TPP-8278', '2025-07-14 12:51:26.487'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '224mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1442, 'C', 4, 2, 2, '224mobulletcurve', '224 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 44, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:51:38.033', 'TPP-8278', '2025-07-14 12:51:38.033'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '295mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1512, 'C', 4, 2, 2, '295mobulletcurve', '295 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 115, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:52:18.747', 'TPP-8278', '2025-07-14 12:52:18.747'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '225mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1443, 'C', 4, 2, 2, '225mobulletcurve', '225 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 45, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:52:30.190', 'TPP-8278', '2025-07-14 12:52:30.190'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '226mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1444, 'C', 4, 2, 2, '226mobulletcurve', '226 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 46, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:53:19.297', 'TPP-8278', '2025-07-14 12:53:19.297'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '294mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1511, 'C', 4, 2, 2, '294mobulletcurve', '294 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 114, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:53:24.793', 'TPP-8278', '2025-07-14 12:53:24.793'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '293mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1510, 'C', 4, 2, 2, '293mobulletcurve', '293 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 113, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:54:10.530', 'TPP-8278', '2025-07-14 12:54:10.530'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '227mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1445, 'C', 4, 2, 2, '227mobulletcurve', '227 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 47, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:54:18.353', 'TPP-8278', '2025-07-14 12:54:18.353'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '292mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1509, 'C', 4, 2, 2, '292mobulletcurve', '292 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 112, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:54:58.823', 'TPP-8278', '2025-07-14 12:54:58.823'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '228mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1446, 'C', 4, 2, 2, '228mobulletcurve', '228 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 48, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:55:06.860', 'TPP-8278', '2025-07-14 12:55:06.860'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '291mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1508, 'C', 4, 2, 2, '291mobulletcurve', '291 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 111, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:55:52.353', 'TPP-8278', '2025-07-14 12:55:52.353'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '229mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1447, 'C', 4, 2, 2, '229mobulletcurve', '229 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 49, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:56:05.613', 'TPP-8278', '2025-07-14 12:56:05.613'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '290mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1507, 'C', 4, 2, 2, '290mobulletcurve', '290 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 110, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:56:41.650', 'TPP-8278', '2025-07-14 12:56:41.650'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '230mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1448, 'C', 4, 2, 2, '230mobulletcurve', '230 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 50, NULL, '', NULL, 'TPP-8278', '2025-07-14 12:57:01.760', 'TPP-8278', '2025-07-14 12:57:01.760'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '289mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1506, 'C', 4, 2, 2, '289mobulletcurve', '289 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 109, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:28:56.440', 'TPP-8278', '2025-07-15 15:28:56.440'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '288mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1505, 'C', 4, 2, 2, '288mobulletcurve', '288 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 108, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:29:56.467', 'TPP-8278', '2025-07-15 15:29:56.467'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '287mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1504, 'C', 4, 2, 2, '287mobulletcurve', '287 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 107, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:32:06.567', 'TPP-8278', '2025-07-15 15:32:06.567'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '286mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1503, 'C', 4, 2, 2, '286mobulletcurve', '286 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 106, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:32:51.343', 'TPP-8278', '2025-07-15 15:32:51.343'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '285mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1502, 'C', 4, 2, 2, '285mobulletcurve', '285 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 105, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:33:39.480', 'TPP-8278', '2025-07-15 15:33:39.480'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '284mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1501, 'C', 4, 2, 2, '284mobulletcurve', '284 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 104, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:35:11.180', 'TPP-8278', '2025-07-15 15:35:11.180'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '283mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1500, 'C', 4, 2, 2, '283mobulletcurve', '283 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 103, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:36:13.990', 'TPP-8278', '2025-07-15 15:36:13.990'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '282mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1499, 'C', 4, 2, 2, '282mobulletcurve', '282 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 102, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:37:25.800', 'TPP-8278', '2025-07-15 15:37:25.800'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '281mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1498, 'C', 4, 2, 2, '281mobulletcurve', '281 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 101, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:38:52.860', 'TPP-8278', '2025-07-15 15:38:52.860'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '231mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1449, 'C', 4, 2, 2, '231mobulletcurve', '231 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 51, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:39:29.533', 'TPP-8278', '2025-07-15 15:39:29.533'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '280mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1497, 'C', 4, 2, 2, '280mobulletcurve', '280 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 100, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:40:01.423', 'TPP-8278', '2025-07-15 15:40:01.423'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '279mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1496, 'C', 4, 2, 2, '279mobulletcurve', '279 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 99, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:40:47.507', 'TPP-8278', '2025-07-15 15:40:47.507'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '278mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1495, 'C', 4, 2, 2, '278mobulletcurve', '278 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 98, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:42:19.433', 'TPP-8278', '2025-07-15 15:42:19.433'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '232mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1450, 'C', 4, 2, 2, '232mobulletcurve', '232 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 52, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:42:54.850', 'TPP-8278', '2025-07-15 15:42:54.850'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '233mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1451, 'C', 4, 2, 2, '233mobulletcurve', '233 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 53, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:43:51.997', 'TPP-8278', '2025-07-15 15:43:51.997'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '277mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1494, 'C', 4, 2, 2, '277mobulletcurve', '277 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 97, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:44:31.147', 'TPP-8278', '2025-07-15 15:44:31.147'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '234mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1452, 'C', 4, 2, 2, '234mobulletcurve', '234 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 54, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:44:42.020', 'TPP-8278', '2025-07-15 15:44:42.020'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '276mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1493, 'C', 4, 2, 2, '276mobulletcurve', '276 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 96, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:45:29.660', 'TPP-8278', '2025-07-15 15:45:29.660'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '275mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1492, 'C', 4, 2, 2, '275mobulletcurve', '275 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 95, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:46:26.530', 'TPP-8278', '2025-07-15 15:46:26.530'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '235mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1453, 'C', 4, 2, 2, '235mobulletcurve', '235 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 55, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:46:34.763', 'TPP-8278', '2025-07-15 15:46:34.763'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '274mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1491, 'C', 4, 2, 2, '274mobulletcurve', '274 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 94, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:47:14.937', 'TPP-8278', '2025-07-15 15:47:14.937'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '236mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1454, 'C', 4, 2, 2, '236mobulletcurve', '236 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 56, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:47:36.193', 'TPP-8278', '2025-07-15 15:47:36.193'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '273mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1490, 'C', 4, 2, 2, '273mobulletcurve', '273 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 93, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:47:57.173', 'TPP-8278', '2025-07-15 15:47:57.173'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '272mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1489, 'C', 4, 2, 2, '272mobulletcurve', '272 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 92, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:48:44.530', 'TPP-8278', '2025-07-15 15:48:44.530'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '237mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1455, 'C', 4, 2, 2, '237mobulletcurve', '237 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 57, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:49:04.413', 'TPP-8278', '2025-07-15 15:49:04.413'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '271mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1488, 'C', 4, 2, 2, '271mobulletcurve', '271 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 91, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:49:25.500', 'TPP-8278', '2025-07-15 15:49:25.500'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '238mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1456, 'C', 4, 2, 2, '238mobulletcurve', '238 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 58, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:49:56.473', 'TPP-8278', '2025-07-15 15:49:56.473'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '270mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1487, 'C', 4, 2, 2, '270mobulletcurve', '270 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 90, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:50:12.910', 'TPP-8278', '2025-07-15 15:50:12.910'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '269mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1486, 'C', 4, 2, 2, '269mobulletcurve', '269 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 89, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:50:57.367', 'TPP-8278', '2025-07-15 15:50:57.367'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '239mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1457, 'C', 4, 2, 2, '239mobulletcurve', '239 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 59, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:50:59.580', 'TPP-8278', '2025-07-15 15:50:59.580'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '268mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1485, 'C', 4, 2, 2, '268mobulletcurve', '268 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 88, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:51:43.877', 'TPP-8278', '2025-07-15 15:51:43.877'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '240mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        28, 'C', 4, 2, 2, '240mobulletcurve', '240 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 60, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:52:03.363', 'TPP-8278', '2025-07-15 15:52:03.363'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '267mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1484, 'C', 4, 2, 2, '267mobulletcurve', '267 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 87, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:52:29.027', 'TPP-8278', '2025-07-15 15:52:29.027'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '241mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1458, 'C', 4, 2, 2, '241mobulletcurve', '241 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 61, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:53:09.267', 'TPP-8278', '2025-07-15 15:53:09.267'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '266mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1483, 'C', 4, 2, 2, '266mobulletcurve', '266 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 86, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:53:09.883', 'TPP-8278', '2025-07-15 15:53:09.883'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '265mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1482, 'C', 4, 2, 2, '265mobulletcurve', '265 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 85, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:53:51.317', 'TPP-8278', '2025-07-15 15:53:51.317'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '264mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1481, 'C', 4, 2, 2, '264mobulletcurve', '264 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 84, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:54:33.890', 'TPP-8278', '2025-07-15 15:54:33.890'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '242mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1459, 'C', 4, 2, 2, '242mobulletcurve', '242 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 62, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:54:43.670', 'TPP-8278', '2025-07-15 15:54:43.670'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '263mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1480, 'C', 4, 2, 2, '263mobulletcurve', '263 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 83, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:55:13.523', 'TPP-8278', '2025-07-15 15:55:13.523'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '243mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1460, 'C', 4, 2, 2, '243mobulletcurve', '243 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 63, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:56:06.870', 'TPP-8278', '2025-07-15 15:56:06.870'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '262mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1479, 'C', 4, 2, 2, '262mobulletcurve', '262 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 82, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:56:10.750', 'TPP-8278', '2025-07-15 15:56:10.750'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '244mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1461, 'C', 4, 2, 2, '244mobulletcurve', '244 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 64, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:57:00.397', 'TPP-8278', '2025-07-15 15:57:00.397'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '261mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1478, 'C', 4, 2, 2, '261mobulletcurve', '261 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 81, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:57:00.743', 'TPP-8278', '2025-07-15 15:57:00.743'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '260mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1477, 'C', 4, 2, 2, '260mobulletcurve', '260 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 80, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:57:49.897', 'TPP-8278', '2025-07-15 15:57:49.897'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '248mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1465, 'C', 4, 2, 2, '248mobulletcurve', '248 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 68, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:58:09.673', 'TPP-8278', '2025-07-15 15:58:09.673'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '259mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1476, 'C', 4, 2, 2, '259mobulletcurve', '259 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 79, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:58:35.830', 'TPP-8278', '2025-07-15 15:58:35.830'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '249mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1466, 'C', 4, 2, 2, '249mobulletcurve', '249 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 69, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:59:05.327', 'TPP-8278', '2025-07-15 15:59:05.327'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '258mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1475, 'C', 4, 2, 2, '258mobulletcurve', '258 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 78, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:59:16.980', 'TPP-8278', '2025-07-15 15:59:16.980'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '250mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1467, 'C', 4, 2, 2, '250mobulletcurve', '250 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 70, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:59:58.033', 'TPP-8278', '2025-07-15 15:59:58.033'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '257mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1474, 'C', 4, 2, 2, '257mobulletcurve', '257 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 77, NULL, '', NULL, 'TPP-8278', '2025-07-15 15:59:59.100', 'TPP-8278', '2025-07-15 15:59:59.100'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '256mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1473, 'C', 4, 2, 2, '256mobulletcurve', '256 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 76, NULL, '', NULL, 'TPP-8278', '2025-07-15 16:00:49.127', 'TPP-8278', '2025-07-15 16:00:49.127'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '255mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1472, 'C', 4, 2, 2, '255mobulletcurve', '255 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 75, NULL, '', NULL, 'TPP-8278', '2025-07-15 16:03:21.480', 'TPP-8278', '2025-07-15 16:03:21.480'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '254mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1471, 'C', 4, 2, 2, '254mobulletcurve', '254 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 74, NULL, '', NULL, 'TPP-8278', '2025-07-15 16:04:02.343', 'TPP-8278', '2025-07-15 16:04:02.343'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '253mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1470, 'C', 4, 2, 2, '253mobulletcurve', '253 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 73, NULL, '', NULL, 'TPP-8278', '2025-07-15 16:04:49.350', 'TPP-8278', '2025-07-15 16:04:49.350'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '252mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1469, 'C', 4, 2, 2, '252mobulletcurve', '252 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 72, NULL, '', NULL, 'TPP-8278', '2025-07-15 16:07:08.017', 'TPP-8278', '2025-07-15 16:07:08.017'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '251mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1468, 'C', 4, 2, 2, '251mobulletcurve', '251 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 71, NULL, '', NULL, 'TPP-8278', '2025-07-15 16:07:58.450', 'TPP-8278', '2025-07-15 16:07:58.450'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '247mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1464, 'C', 4, 2, 2, '247mobulletcurve', '247 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 67, NULL, '', NULL, 'TPP-8278', '2025-07-15 16:08:59.563', 'TPP-8278', '2025-07-15 16:08:59.563'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '245mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1462, 'C', 4, 2, 2, '245mobulletcurve', '245 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 65, NULL, '', NULL, 'TPP-8278', '2025-07-15 16:11:19.673', 'TPP-8278', '2025-07-15 16:11:19.673'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '246mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1463, 'C', 4, 2, 2, '246mobulletcurve', '246 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 66, NULL, '', NULL, 'TPP-8278', '2025-07-15 16:12:17.650', 'TPP-8278', '2025-07-15 16:12:17.650'
    );
END
IF NOT EXISTS (SELECT 1 FROM ExportRateDefinitions WHERE ShortName = '200mobulletcurve')
BEGIN
    INSERT INTO ExportRateDefinitions (
        ExportTypeID, BaseRateID, BaseRateType, RateFrequencyID,
        FrequencyDayTypeID, FrequencyDayToUseID, ShortName, Description,
        DayExport, WeekDayExport, ManualCalendar, RoundingTypeID, AvgRateNum,
        ColumnOrder, SortOrder, Notes, TerminationDate, CreatedBy, CreatedDate,
        UpdatedBy, UpdatedDate
    ) VALUES ((SELECT LExportTypes.IID FROM LExportTypes WHERE Code = 'DB2')  ,
        1418, 'C', 4, 2, 2, '200mobulletcurve', '200 month Annual Bullet Rate', -1, NULL, 0, NULL, NULL, 20, NULL, '', NULL, 'TPP-8278', '2025-07-15 16:13:53.497', 'TPP-8278', '2025-07-15 16:13:53.497'
    );
END



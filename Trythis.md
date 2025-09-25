# CalculatedRateValues Update Entry Points

- Stored procedure `dbo.InsertOrUpdateCalculatedRateValues` is defined in `BSDRate_Database.sql:28815`. It performs insert-or-update logic for rows in `CalculatedRateValues`, honoring the `OverwriteCalculatedRateValues` configuration and override processing.
- The business layer wrapper `CalculatedRateData.InsertOrUpdateCalculatedRateValues` lives in `BSDRateBusiness/Data/CalculatedRateData.vb:355`. It prepares the parameters (`@calculatedRateID`, `@calculatedDate`, `@value`, optional `@override`, and `@userName`) and executes the stored procedure.
- `CalculatedRateBuilder.CalculateRate` persists calculated rates by calling the wrapper when a rate definition is marked as persisted and saving is enabled (`BSDRateBusiness/Utilities/CalculatedRateBuilder.vb:343` → `BSDRateBusiness/Utilities/CalculatedRateBuilder.vb:362`). This is the path that ultimately updates `CalculatedRateValues`.

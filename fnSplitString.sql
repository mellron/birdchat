/* -----------------------------------------
   Inline splitter with Ordinal (SQL 2016+ JSON; compat level 130)
   ----------------------------------------- */
CREATE OR ALTER FUNCTION dbo.fnSplitString
(
    @DelimitedString NVARCHAR(MAX),
    @Delimiter       NCHAR(1)
)
RETURNS TABLE
AS
RETURN
WITH SourceText AS
(
    SELECT AdjustedString =
        CASE
            WHEN @DelimitedString IS NULL
              OR @Delimiter IS NULL
              OR @Delimiter = N''
              OR LEN(@DelimitedString) = 0
                THEN NULL
            WHEN RIGHT(@DelimitedString, 1) = @Delimiter
                THEN LEFT(@DelimitedString, LEN(@DelimitedString) - 1)  -- drop trailing delimiter
            ELSE @DelimitedString
        END
)
SELECT
    Ordinal = CONVERT(INT, [key]) + 1,              -- 1-based position
    Value   = CONVERT(NVARCHAR(MAX), [value])       -- preserve spaces like legacy
FROM SourceText
CROSS APPLY OPENJSON(
    CASE
        WHEN AdjustedString IS NULL THEN NULL
        ELSE N'[''' + REPLACE(AdjustedString, @Delimiter, N''',''') + N''']'
    END
);
GO

/* -----------------------------------------
   Repro again, but join on Ordinal.
   We STILL shuffle each side independently,
   yet the pairing remains correct.
   ----------------------------------------- */
DECLARE @SelectedTickets2     NVARCHAR(MAX) = N'4897,4900';
DECLARE @SelectedTicketAmts2  NVARCHAR(MAX) = N'62000.00,398000.00';

WITH TicketParts AS
(
    SELECT Ordinal, Ticket = TRY_CONVERT(INT, Value)
    FROM dbo.fnSplitString(@SelectedTickets2, N',')
),
AmountParts AS
(
    SELECT Ordinal, Amount = TRY_CONVERT(DECIMAL(18,2), Value)
    FROM dbo.fnSplitString(@SelectedTicketAmts2, N',')
),
TicketPartsShuffled AS
(
    SELECT * FROM TicketParts ORDER BY CHECKSUM(NEWID())     -- simulate reordering
),
AmountPartsShuffled AS
(
    SELECT * FROM AmountParts ORDER BY CHECKSUM(NEWID())     -- simulate independent reordering
)
SELECT
    Result = CONCAT('Ticket ', TicketPartsShuffled.Ticket, ' => $', AmountPartsShuffled.Amount)
FROM TicketPartsShuffled
JOIN AmountPartsShuffled
  ON AmountPartsShuffled.Ordinal = TicketPartsShuffled.Ordinal
ORDER BY TicketPartsShuffled.Ordinal;                        -- preserves original sequence

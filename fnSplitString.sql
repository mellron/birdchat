/* -----------------------------------------
   Inline splitter with Ordinal (SQL 2016+ JSON; compat level 130)


   Why this version is faster (SQL Server 2016):
   
   - Inline TVF (not multi-statement): the optimizer inlines it into the caller’s plan,
     enabling better join choices and parallelism. The old multi-statement TVF is opaque
     with a fixed ~100-row estimate, and table variables are estimated at 1 row in 2016—
     both lead to poor plans.
   
   - Set-based OPENJSON: splits the string in one pass (no WHILE / row-by-row inserts),
     reducing CPU and logging.
   
   - More accurate cardinality: OPENJSON exposes actual row counts, so memory grants are
     sized correctly and spills are less likely.
   
   - Fewer intermediates and sorts: no table variables with IDENTITY, no extra reordering;
     we carry an Ordinal and order once at the end when needed.
   
   - Predicate pushdown: filters and projections on the split values can be pushed into
     the inlined plan (not possible with the old TVF).
   
   Net: same results, deterministic pairing via Ordinal, lower CPU, and more stable plans.

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

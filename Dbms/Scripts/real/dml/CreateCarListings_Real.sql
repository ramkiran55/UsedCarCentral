USE UsedCarCentral
GO


CREATE PROCEDURE real.CreateListings
    @MasterID BIGINT,
    @CarID INT,
    @LocationID INT,
    @Price FLOAT,
    @PostedDate DATETIME,
    @ListingURL NVARCHAR(500),
    @out INT OUTPUT

AS
BEGIN
    BEGIN TRY
        SET NOCOUNT ON;
        SET @out = 0;
        DECLARE @id INT;
        DECLARE @newId INT;
        PRINT 'real.CreateListings: Started real.CreateListings'
        SELECT @id = MAX(ListingID) FROM real.CarListings;
        -- Query
        INSERT INTO real.CarListings (MasterID, CarID, LocationID, Price, PostedDate, ListingURL)
        VALUES (@MasterID, @CarID, @LocationID, @Price, @PostedDate, @ListingURL);
        PRINT 'real.CreateListings: Inserted..'
        SELECT @newId = MAX(ListingID) FROM real.CarListings;
        IF @id = @newId
        BEGIN
		PRINT 'real.CreateListings: Not Inserted..'
            ROLLBACK;
            SET NOCOUNT OFF;
            SET @out = 1;
            RETURN @out;
        END
        --COMMIT;
        SET NOCOUNT OFF;
        RETURN @out;
    END TRY
    BEGIN CATCH
	PRINT 'real.CreateListings: Encountered Exception..'+ ERROR_MESSAGE();
    PRINT ERROR_LINE();
        SET @out = 1;
        SET NOCOUNT OFF;
        ROLLBACK;
        RETURN @out;
    END CATCH
END
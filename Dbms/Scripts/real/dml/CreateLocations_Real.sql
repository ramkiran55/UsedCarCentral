USE UsedCarCentral
GO

CREATE PROCEDURE real.CreateLocations
    @MasterID BIGINT,
    @CarID BIGINT,
    @City NVARCHAR(50),
    @StateCode NVARCHAR(50),
    @Latitude FLOAT,
    @Longitude FLOAT,
    @CraigsCityURL NVARCHAR(500),
    @Price FLOAT,
    @PostedDate DATETIME,
    @ListingURL NVARCHAR(500),
    @UserID INT,
    @out INT OUTPUT

AS
BEGIN
    BEGIN TRY
        SET NOCOUNT ON;
        SET @out = 0;
        DECLARE @id INT;
        DECLARE @newId INT;
        PRINT 'real.CreateLocations: Started real.CreateLocations'
        SELECT @id = MAX(LocationID) FROM real.Locations;
        -- Query
        INSERT INTO real.Locations (MasterID, City, StateCode, Latitude, Longitude, CraigsCityURL) 
        VALUES (@MasterID, @City, @StateCode, @Latitude, @Longitude, @CraigsCityURL);
        PRINT 'real.CreateLocations: Insereted'
        SELECT @newId = MAX(LocationID) FROM real.Locations;
        IF @id = @newId
        BEGIN
            ROLLBACK;
            PRINT 'real.CreateLocations: Error in Insertion'
            SET NOCOUNT OFF;
            SET @out = 1;
            RETURN @out;
        END
        PRINT 'real.CreateLocations: Started real.CreateListings'
        EXEC @out = real.CreateListings
            @MasterID = @MasterID
            , @CarID = @CarID
            , @LocationID = @newId
            , @Price = @Price
            , @PostedDate = @PostedDate
            , @ListingURL = @ListingURL
            , @UserID = @UserID
            , @out = 0

        --COMMIT;
        SET NOCOUNT OFF;
        RETURN @out;
    END TRY
    BEGIN CATCH
        SET @out = 1;
		PRINT 'real.CreateLocations: Encountered Exception'+ ERROR_MESSAGE();
        PRINT ERROR_LINE();
        SET NOCOUNT OFF;
        ROLLBACK;
        RETURN @out;
    END CATCH
END
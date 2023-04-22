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
    @out INT OUTPUT

AS
BEGIN
    BEGIN TRY
        SET NOCOUNT ON;
        SET @out = 0;
        DECLARE @id INT;
        DECLARE @newId INT;

        SELECT @id = MAX(LocationID) FROM real.Locations;
        -- Query
        INSERT INTO real.Locations (MasterID, City, StateCode, Latitude, Longitude, CraigsCityURL) 
        VALUES (@MasterID, @City, @StateCode, @Latitude, @Longitude, @CraigsCityURL);
        SELECT @newId = MAX(LocationID) FROM real.Locations;
        IF @id = @newId
        BEGIN
            ROLLBACK;
            SET NOCOUNT OFF;
            SET @out = 1;
            RETURN @out;
        END
        EXEC @out = real.CreateListings
            @MasterID = @MasterID
            , @CarID = @CarID
            , @LocationID = @newId
            , @Price = @Price
            , @PostedDate = @PostedDate
            , @ListingURL = @ListingURL

        COMMIT;
        SET NOCOUNT OFF;
        RETURN @out;
    END TRY
    BEGIN CATCH
        SET @out = 1;
        SET NOCOUNT OFF;
        ROLLBACK;
        RETURN @out;
    END CATCH
END
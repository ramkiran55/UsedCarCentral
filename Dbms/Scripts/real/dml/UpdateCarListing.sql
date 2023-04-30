USE UsedCarCentral
GO

CREATE PROCEDURE real.UpdateCarListing
(
    @CarModel NVARCHAR(50),
    @CarCondition NVARCHAR(50),
    @Manufacturer NVARCHAR(50),
    @Price FLOAT,
    @CarSize NVARCHAR(50),
    @City NVARCHAR(50),
    @StateCode NVARCHAR(50),
    @ListingID INT
)
AS
BEGIN
    BEGIN TRY
        SET NOCOUNT ON;

        PRINT 'real.UpdateCarListing: Started..'

        UPDATE real.CarListings SET 
        Price = @Price,
        PostedDate = GETDATE()
        WHERE ListingID = @ListingID;

        DECLARE @MasterID DATETIME;
        DECLARE @CarID DATETIME;
        SELECT @MasterID = MasterID,
        @CarID = CarID 
        FROM real.CarListings
        WHERE ListingID = @ListingID;

        UPDATE real.Locations SET
        City = @City,
        StateCode = @StateCode
        WHERE MasterID = @MasterID;

        UPDATE real.CarDetails SET
        CarCondition = @CarCondition
        WHERE CarID = @CarID;

        UPDATE real.CarsMasterData SET
        Manufacturer = @Manufacturer,
        CarModel = @CarModel,
        CarSize = @CarSize
        WHERE CarID = @CarID;

        UPDATE real.UsedCarsMasterData SET
        Manufacturer = @Manufacturer,
        CarModel = @CarModel,
        CarSize = @CarSize,
        CarCondition = @CarCondition,
        City = @City,
        StateCode = @StateCode,
        Price = @Price
        WHERE MasterID = @MasterID;

        PRINT 'real.UpdateCarListing: updated..'

        SET NOCOUNT OFF;
    END TRY
    BEGIN CATCH
	PRINT 'real.UpdateCarListing: Encountered Exception..'+ ERROR_MESSAGE();
    PRINT ERROR_LINE();
        SET NOCOUNT OFF;
        ROLLBACK;

    END CATCH
END
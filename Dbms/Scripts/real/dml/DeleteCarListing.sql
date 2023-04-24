USE UsedCarCentral
GO
--DROP PROCEDURE real.DeleteCarListing
CREATE PROCEDURE real.DeleteCarListing
    @UserID INT,
    @ListingID INT
AS
BEGIN
    BEGIN TRY
        SET NOCOUNT ON;

        PRINT 'real.DeleteCarListing: Started..'

        DECLARE @MasterID INT;
        DECLARE @CarID INT;

        SELECT @CarID = CarID,
                @MasterID = MasterID 
        FROM real.CarListings 
        WHERE ListingID = @ListingID;
        SELECT @MasterID, @CarID;

        DELETE FROM real.UserCarListings 
        WHERE UserID = @UserID
        AND CarListingID = @ListingID;

        DELETE FROM real.CarListings 
        WHERE ListingID = @ListingID;

        DELETE FROM real.Locations 
        WHERE MasterID = @MasterID;

        DELETE FROM real.CarDetails 
        WHERE CarID = @CarID;

        DELETE FROM real.CarsMasterData 
        WHERE CarID = @CarID;

        DELETE FROM real.UsedCarsMasterData
        WHERE MasterID = @MasterID;

        PRINT 'real.DeleteCarListing: Deleted..'

        SET NOCOUNT OFF;
    END TRY
    BEGIN CATCH
	PRINT 'real.DeleteCarListing: Encountered Exception..'+ ERROR_MESSAGE();
    PRINT ERROR_LINE();

        SET NOCOUNT OFF;
        ROLLBACK;

    END CATCH
END
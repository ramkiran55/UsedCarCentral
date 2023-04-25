USE UsedCarCentral
GO
--DROP PROCEDURE real.DeleteCarListing
CREATE PROCEDURE real.UpdateCarPrice
    @ListingID INT,
    @Price INT
AS
BEGIN
    BEGIN TRY
        SET NOCOUNT ON;

        PRINT 'real.UpdateCarPrice: Started..'

        UPDATE real.CarListings SET Price = @Price 
        WHERE ListingID = @ListingID;

        PRINT 'real.UpdateCarPrice: updated..'

        SET NOCOUNT OFF;
    END TRY
    BEGIN CATCH
	PRINT 'real.UpdateCarPrice: Encountered Exception..'+ ERROR_MESSAGE();
    PRINT ERROR_LINE();

        SET NOCOUNT OFF;
        ROLLBACK;

    END CATCH
END

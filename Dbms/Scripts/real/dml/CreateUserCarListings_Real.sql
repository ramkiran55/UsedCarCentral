USE UsedCarCentral
GO

CREATE PROCEDURE real.CreateUserCarListings
    @UserID INT,
    @CarListingID INT,
    @out INT OUTPUT
AS
BEGIN
    BEGIN TRY
        SET NOCOUNT ON;
        SET @out = 0;
        DECLARE @id INT;
        DECLARE @newId INT;
        PRINT 'real.CreateUserCarListings: Started..'
        SELECT @id = MAX(UserCarListingID) FROM real.UserCarListings;

        INSERT INTO real.UserCarListings (UserID, CarListingID)
        VALUES (@UserID, @CarListingID);

        PRINT 'real.CreateUserCarListings: Inserted..'
        SELECT @newId = MAX(UserCarListingID) FROM real.UserCarListings;
        IF @id = @newId
        BEGIN
		PRINT 'real.CreateUserCarListings: Not Inserted..'
            ROLLBACK;
            SET NOCOUNT OFF;
            SET @out = 1;
            RETURN @out;
        END
         SET NOCOUNT OFF;
        RETURN @out;
    END TRY
    BEGIN CATCH
	PRINT 'real.CreateUserCarListings: Encountered Exception..'+ ERROR_MESSAGE();
    PRINT ERROR_LINE();
        SET @out = 1;
        SET NOCOUNT OFF;
        ROLLBACK;
        RETURN @out;
    END CATCH
END
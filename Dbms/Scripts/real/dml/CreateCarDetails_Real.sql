USE UsedCarCentral
GO

CREATE PROCEDURE real.CreateCarDetails
    @CarID INT,
    @CarCondition NVARCHAR(50),
    @OdometerReading FLOAT,
    @CarStatus NVARCHAR(50),
    @ImageURL NVARCHAR(500),
    @CarDescription NVARCHAR(MAX),
    @out INT OUTPUT

AS
BEGIN
    BEGIN TRY
        SET NOCOUNT ON;
        DECLARE @id INT;
        DECLARE @newId INT;
        PRINT 'real.CreateCarDetails: Started real.CreateListings';
        SELECT @id = MAX(CarDetailsID) FROM real.CarDetails;

        INSERT INTO real.CarDetails (CarID, CarCondition, OdometerReading, CarStatus, ImageURL, CarDescription)
        VALUES (@CarID, @CarCondition, @OdometerReading, @CarStatus, @ImageURL, @CarDescription);
        
        PRINT 'real.CreateCarDetails: Inserted';
        SELECT @newId = MAX(CarDetailsID) FROM real.CarDetails;
        IF @newId = @id
        BEGIN
            SELECT @out = 1;
            PRINT 'real.CreateCarDetails: Not Inserted'
            SET NOCOUNT OFF;
            ROLLBACK;
            RETURN @out;
        END
        --COMMIT
        SET NOCOUNT OFF;
        RETURN @out;
    END TRY
    BEGIN CATCH
	PRINT 'real.CreateCarDetails: Encountered Exception '+ ERROR_LINE();
    PRINT ERROR_LINE();
        SELECT @out = 1;
        SET NOCOUNT OFF;
        ROLLBACK;
        RETURN @out;
    END CATCH
END
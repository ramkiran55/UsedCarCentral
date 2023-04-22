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
        SELECT @id = MAX(CarDetailsID) FROM real.CarDetails;
        INSERT INTO real.CarDetails (CarID, CarCondition, OdometerReading, CarStatus, ImageURL, CarDescription)
        VALUES (@CarID, @CarCondition, @OdometerReading, @CarStatus, @ImageURL, @CarDescription);
        SELECT @newId = MAX(CarDetailsID) FROM real.CarDetails;
        IF @newId = @id
        BEGIN
            SELECT @out = 1;
            SET NOCOUNT OFF;
            ROLLBACK;
            RETURN @out;
        END
        
    END TRY
    BEGIN CATCH
        SELECT @out = 1;
        SET NOCOUNT OFF;
        ROLLBACK;
        RETURN @out;
    END CATCH


END
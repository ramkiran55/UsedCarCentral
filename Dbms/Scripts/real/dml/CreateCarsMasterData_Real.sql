USE UsedCarCentral
GO

CREATE PROCEDURE real.CreateCarsMasterData
    @MasterID BIGINT,
    @Manufacturer NVARCHAR(50),
    @ModelYear SMALLINT,
    @CylinderCount NVARCHAR(50),
    @Price FLOAT,
    @FuelType NVARCHAR(50),
    @TransmissionType NVARCHAR(50),
    @CarSize NVARCHAR(50),
    @CarBodyType NVARCHAR(50),
    @CarColor NVARCHAR(50),
    @VehicleIdentificationNum NVARCHAR(50),
    @DriveType NVARCHAR(50),
    @CarCondition NVARCHAR(50),
    @OdometerReading FLOAT,
    @CarStatus NVARCHAR(50),
    @ImageURL NVARCHAR(500),
    @CarDescription NVARCHAR(MAX),
    @City NVARCHAR(50),
    @StateCode NVARCHAR(50),
    @Latitude FLOAT,
    @Longitude FLOAT,
    @CraigsCityURL NVARCHAR(500),
    @PostedDate DATETIME,
    @ListingURL NVARCHAR(500),
    @UserID INT,
    @CarModel NVARCHAR(50),
    @out INT OUTPUT
AS
BEGIN
    BEGIN TRY
        SET NOCOUNT ON;
        DECLARE @id INT;
        DECLARE @newId INT;
        PRINT 'real.CreateCarsMasterData: started with real.CreateCarsMasterData'
        SELECT @id = MAX(CarID) FROM real.CarsMasterData;
        INSERT INTO real.CarsMasterData (
            MasterID,
            Manufacturer,
            ModelYear,
            CylinderCount,
            CarModel,
            FuelType,
            TransmissionType,
            CarSize,
            CarBodyType,
            CarColor,
            VehicleIdentificationNum,
            DriveType
            ) VALUES (
            @MasterID,
            @Manufacturer,
            @ModelYear,
            @CylinderCount,
            @CarModel,
            @FuelType,
            @TransmissionType,
            @CarSize,
            @CarBodyType,
            @CarColor,
            @VehicleIdentificationNum,
            @DriveType
        );
        
        SELECT @newId = MAX(CarID) FROM real.CarsMasterData;
        IF @id = @newId
        BEGIN
            set @out = 1;
            SET NOCOUNT OFF;
            ROLLBACK;
            RETURN @out;
        END
        ELSE
        BEGIN
        PRINT 'real.CreateCarsMasterData: Started real.CreateCarDetails'
            EXEC @out = real.CreateCarDetails
                @CarID = @newId
                , @CarCondition = @CarCondition
                , @OdometerReading = @OdometerReading
                , @CarStatus = @CarStatus
                , @ImageURL = @ImageURL
                , @CarDescription = @CarDescription
                , @out = 0
            IF @out = 1
            BEGIN
                SET NOCOUNT OFF;
                PRINT 'real.CreateCarsMasterData: Error in real.CreateCarDetails'
                ROLLBACK;
                RETURN @out;
            END
            PRINT 'real.CreateCarsMasterData: Started real.CreateLocations'
            EXEC @out = real.CreateLocations
                @MasterID = @MasterID
                , @CarID = @newId
                , @City = @City
                , @StateCode = @StateCode
                , @Latitude = @Latitude
                , @Longitude = @Longitude
                , @CraigsCityURL = @CraigsCityURL
                , @Price = @Price
                , @PostedDate = @PostedDate
                , @ListingURL = @ListingURL
                , @UserID = @UserID
                , @out = 0
            IF @out = 1
            BEGIN
                SET NOCOUNT OFF;
                PRINT 'real.CreateCarsMasterData: Error in real.CreateLocations'
                ROLLBACK;
                RETURN @out;
            END            
        END
        --set @out = 0;
        --COMMIT;
        SET NOCOUNT OFF;
        RETURN @out;
    END TRY
    BEGIN CATCH
        set @out = 1;
        SET NOCOUNT OFF;
        PRINT 'real.CreateCarsMasterData: Enocuntered Some Exception'+ ERROR_MESSAGE();
        PRINT ERROR_LINE();
        ROLLBACK;
        RETURN @out;
    END CATCH
END
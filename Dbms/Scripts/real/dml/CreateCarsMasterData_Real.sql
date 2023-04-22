USE UsedCarCentral
GO

CREATE PROCEDURE real.CreateCarsMasterData
    @MasterID BIGINT,
    @Manufacturer NVARCHAR(50),
    @ModelYear SMALLINT,
    @CylinderCount NVARCHAR(50),
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
    @out INT OUTPUT
AS
BEGIN
    BEGIN TRY
        SET NOCOUNT ON;
        DECLARE @id INT;
        DECLARE @newId INT;

        SELECT @id = MAX(CarID) FROM real.CarsMasterData;
        INSERT INTO real.CarsMasterData (
            MasterID,
            Manufacturer,
            ModelYear,
            CylinderCount,
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
            @FuelType,
            @TransmissionType,
            @CarSize,
            @CarBodyType,
            @CarColor,
            @VehicleIdentificationNum,
            @DriveType
        );
        SELECT MAX(CarID) AS newId FROM real.CarsMasterData;
        IF @id = @newId
        BEGIN
            set @out = 1;
            SET NOCOUNT OFF;
            ROLLBACK;
            RETURN @out;
        END
        ELSE
        BEGIN
            EXEC @out = real.CreateCarDetails
                @CarID = @newId
                , @CarCondition = @CarCondition
                , @OdometerReading = @OdometerReading
                , @CarStatus = @CarStatus
                , @ImageURL = @ImageURL
                , @CarDescription = @CarDescription
            IF @out = 1
            BEGIN
                SET NOCOUNT OFF;
                ROLLBACK;
                RETURN @out;
            END

            EXEC @out = real.CreateLocations
                @MasterID = @MasterID
                , @CarID = @newId
                , @City = @City
                , @StateCode = @StateCode
                , @Latitude = @Latitude
                , @Longitude = @Longitude
                , @CraigsCityURL = @CraigsCityURL
            IF @out = 1
            BEGIN
                SET NOCOUNT OFF;
                ROLLBACK;
                RETURN @out;
            END            
        END
        --set @out = 0;
        COMMIT;
        SET NOCOUNT OFF;
        RETURN @out;
    END TRY
    BEGIN CATCH
        set @out = 1;
        SET NOCOUNT OFF;
        ROLLBACK;
        RETURN @out;
    END CATCH
END
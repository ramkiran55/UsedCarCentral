USE UsedCarCentral
GO

CREATE PROCEDURE real.CreateUsedCarsMasterData 
    (
        @ListingURL NVARCHAR(500),
        @City NVARCHAR(50),
        @CraigsCityURL NVARCHAR(500),
        @Price FLOAT,
        @ModelYear SMALLINT,
        @Manufacturer NVARCHAR(50),
        @CarModel NVARCHAR(50),
        @CarCondition NVARCHAR(50),
        @CylinderCount NVARCHAR(50),
        @FuelType NVARCHAR(50),
        @OdometerReading FLOAT,
        @CarStatus NVARCHAR(50),
        @TransmissionType NVARCHAR(50),
        @VehicleIdentificationNum NVARCHAR(50),
        @DriveType NVARCHAR(50),
        @CarSize NVARCHAR(50),
        @CarBodyType NVARCHAR(50),
        @CarColor NVARCHAR(50),
        @ImageURL NVARCHAR(500),
        @CarDescription NVARCHAR(MAX),
        @StateCode NVARCHAR(50),
        @Latitude FLOAT,
        @Longitude FLOAT,
        @PostedDate DATETIME,
        @out0 INT OUTPUT
    )
AS
BEGIN
    BEGIN TRY
        SET NOCOUNT ON;

        SELECT MAX(MasterID) AS id FROM real.UsedCarsMasterData;

        INSERT INTO real.UsedCarsMasterData (
            ListingURL, 
            City, 
            CraigsCityURL, 
            Price, 
            ModelYear, 
            Manufacturer, 
            CarModel, 
            CarCondition, 
            CylinderCount, 
            FuelType, 
            OdometerReading, 
            CarStatus, 
            TransmissionType, 
            VehicleIdentificationNum, 
            DriveType, 
            CarSize, 
            CarBodyType, 
            CarColor, 
            ImageURL, 
            CarDescription, 
            StateCode, 
            Latitude, 
            Longitude, 
            PostedDate
        ) VALUES (
            @ListingURL, 
            @City, 
            @CraigsCityURL, 
            @Price, 
            @ModelYear, 
            @Manufacturer, 
            @CarModel, 
            @CarCondition, 
            @CylinderCount, 
            @FuelType, 
            @OdometerReading, 
            @CarStatus, 
            @TransmissionType, 
            @VehicleIdentificationNum, 
            @DriveType, 
            @CarSize, 
            @CarBodyType, 
            @CarColor, 
            @ImageURL, 
            @CarDescription, 
            @StateCode, 
            @Latitude, 
            @Longitude, 
            @PostedDate
        );

        SELECT MAX(MasterID) AS newId FROM real.UsedCarsMasterData;

        IF newId = id
        BEGIN
            set @out = 1; --- insertion is not successfull 
            ROLLBACK;
            RETURN @out;
        END
        EXEC @out = CreateCarsMasterData 
            @MasterID = newId
            , @Manufacturer = @Manufacturer
            , @ModelYear = @ModelYear
            , @CylinderCount = @CylinderCount
            , @FuelType = @FuelType
            , @TransmissionType = @TransmissionType
            , @CarSize = @CarSize
            , @CarBodyType =  @CarBodyType
            , @CarColor = @CarColor
            , @VehicleIdentificationNum = @VehicleIdentificationNum
            , @DriveType = @DriveType
            
        IF @out = 1
        BEGIN
            ROLLBACK;
            RETURN @out;
        END        
        SET @out = 0;
        SET NOCOUNT OFF;

        RETURN @out;
        COMMIT;
    END TRY

    BEGIN CATCH
        SET @out = 1;
        ROLLBACK;
        RETURN @out;
    END CATCH
END

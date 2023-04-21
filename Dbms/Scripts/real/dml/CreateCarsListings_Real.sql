USE UsedCarCentral
GO

CREATE PROCEDURE real.CreateCarsMasterData 
    (
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
        @out = 0 INT OUTPUT
    )
AS
BEGIN
    BEGIN TRY
        SET NOCOUNT ON;

        --- Query

        SET NOCOUNT OFF;
    END TRY

    BEGIN CATCH

    END CATCH
END
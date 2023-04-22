USE UsedCarCentral
GO

CREATE PROCEDURE real.CreateListings
    @MasterID BIGINT,
    @CarID INT,
    @LocationID INT,
    @Price FLOAT,
    @PostedDate DATETIME,
    @ListingURL NVARCHAR(500),
    @out INT OUTPUT

AS
BEGIN
    BEGIN TRY
        SET NOCOUNT ON;
        SET @out = 0;
        DECLARE @id INT;
        DECLARE @newId INT;
        SELECT @id = MAX(ListingID) FROM real.CarListings;
        -- Query
        INSERT INTO real.CarListings (MasterID, CarID, LocationID, Price, PostedDate, ListingURL)
        VALUES (@MasterID, @CarID, @LocationID, @Price, @PostedDate, @ListingURL);
        SELECT @newId = MAX(ListingID) FROM real.CarListings;
        IF @id = @newId
        BEGIN
            ROLLBACK;
            SET NOCOUNT OFF;
            SET @out = 1;
            RETURN @out;
        END
        COMMIT;
        SET NOCOUNT OFF;
        RETURN @out;
    END TRY
    BEGIN CATCH
        SET @out = 1;
        SET NOCOUNT OFF;
        ROLLBACK;
        RETURN @out;
    END CATCH
END
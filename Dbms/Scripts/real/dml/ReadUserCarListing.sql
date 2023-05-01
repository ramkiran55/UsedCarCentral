USE UsedCarCentral
GO
--DROP PROCEDURE real.ReadUserCarListing;
CREATE PROCEDURE real.ReadUserCarListing
    @UserID INT,
    @ListingID INT
AS
BEGIN
    SELECT
        mc.CarModel,
        mc.Manufacturer,
        cl.Price,
        mc.CarSize,
        cd.CarCondition,
        l.City,
        l.StateCode,
        cl.PostedDate
    FROM
        real.UserCarListings ucl
        JOIN real.CarListings cl ON ucl.CarListingID = cl.ListingID
        JOIN real.CarsMasterData mc ON cl.CarID = mc.CarID
        JOIN real.CarDetails cd ON cl.CarID = cd.CarID
        JOIN real.Locations l ON cl.LocationID = l.LocationID
    WHERE
        ucl.UserID = @UserID
        AND ucl.CarListingID = @ListingID
        AND cl.ListingID = @ListingID
        AND mc.CarModel IS NOT NULL
        AND mc.Manufacturer IS NOT NULL
        AND cl.Price IS NOT NULL
        AND mc.CarSize IS NOT NULL
        AND cd.CarCondition IS NOT NULL
        AND l.City IS NOT NULL
        AND l.StateCode IS NOT NULL
        AND cl.PostedDate IS NOT NULL
    ORDER BY
        cl.PostedDate DESC;
END

--EXEC real.ReadUserCarListing 1, 8091

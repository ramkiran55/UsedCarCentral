USE UsedCarCentral
GO
---DROP PROCEDURE real.ReadCarListings;
CREATE PROCEDURE real.ReadCarListings
AS
BEGIN
SET NOCOUNT ON;
    SELECT TOP 1000000 cm.CarModel, um.Manufacturer, cl.Price, cm.CarSize, cd.CarCondition, l.City, l.StateCode, cl.PostedDate
    FROM real.CarsMasterData cm
    JOIN real.UsedCarsMasterData um ON cm.MasterID = um.MasterID
    JOIN real.CarListings cl ON cl.CarID = cm.CarID
    JOIN real.CarDetails cd ON cd.CarID = cm.CarID
    JOIN real.Locations l ON l.LocationID = cl.LocationID
    WHERE cm.CarModel IS NOT NULL 
        AND um.Manufacturer IS NOT NULL 
        AND cl.Price IS NOT NULL 
        AND cm.CarSize IS NOT NULL 
        AND cd.CarCondition IS NOT NULL 
        AND l.City IS NOT NULL 
        AND l.StateCode IS NOT NULL 
        AND cl.PostedDate IS NOT NULL
    ORDER BY cl.PostedDate DESC;
SET NOCOUNT OFF;
END
DROP PROCEDURE real.CreateUsedCarsMasterData;
DROP PROCEDURE real.CreateCarsMasterData;
DROP PROCEDURE real.CreateCarDetails;
DROP PROCEDURE real.CreateLocations;
DROP PROCEDURE real.CreateListings;
DROP PROCEDURE real.CreateUserCarListings;

SELECT TOP 1 * FROM real.UsedCarsMasterData ORDER BY PostedDate DESC;
DELETE FROM real.UsedCarsMasterData WHERE MasterID = 1010338;
SELECT * FROM real.CarsMasterData WHERE MasterID = 1010338;
DELETE FROM real.CarsMasterData WHERE CarID = 10435;
SELECT * FROM real.CarDetails WHERE CarID = 10435;
DELETE FROM real.CarDetails WHERE CarID = 10435;
SELECT * FROM real.Locations WHERE MasterID = 1010338;
DELETE FROM real.Locations WHERE LocationID = 10336;
SELECT * FROM real.CarListings WHERE MasterID = 1010338;
DELETE FROM real.CarListings WHERE ListingID = 10336;


SELECT TOP 2 cm.CarModel, um.Manufacturer, cl.Price, cm.CarSize, cd.CarCondition, l.City, l.StateCode, cl.PostedDate
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


DECLARE @out int;
EXEC @out = real.CreateUsedCarsMasterData 
     @ListingURL = 'https://www.example.com/car1',
     @City = 'New York',
     @CraigsCityURL = 'https://newyork.craigslist.org',
     @Price = 25000,
     @ModelYear = 2018,
     @Manufacturer = 'Ram Kiran',
     @CarModel = 'RDK',
     @CarCondition = 'Used',
     @CylinderCount = '4',
     @FuelType = 'Gasoline',
     @OdometerReading = 50000,
     @CarStatus = 'Available',
     @TransmissionType = 'Automatic',
     @VehicleIdentificationNum = '1234567890',
     @DriveType = 'FWD',
     @CarSize = 'Mid-Size',
     @CarBodyType = 'Sedan',
     @CarColor = 'Black',
     @ImageURL = 'https://www.example.com/car1/image.jpg',
     @CarDescription = 'This is a very clean and well-maintained car.',
     @StateCode = 'NY',
     @Latitude = 40.7128,
     @Longitude = -74.0060,
     @PostedDate = '2023-04-23 10:00:00',
     @out = 0

SELECT @out;

SELECT TOP 1 * FROM real.UserCarListings ORDER BY UserCarListingID DESC;
SELECT * FROM real.CarListings WHERE ListingID = 7483;

select * from real.UserCarListings where CarListingID = 7487;

EXEC real.UpdateCarListing 'BMW Benz', 'Good', 'RDK', 33333, 'Full Size SUV', 'Seatle', 'WA', 7483;
-- Use schema real
-- Firstly I'm creating a table to just Import the data from our dataset with all the required columns. This table will be our master table from which we'll be deriving the main tables using Normalization.
DROP TABLE real.UsedCarsStagingData; -- Revanth Posina (rposina)
DROP TABLE real.UsedCarsMasterData;

CREATE TABLE real.UsedCarsStagingData -- Ram Kiran Devireddy (radevir)
(
	MasterID BIGINT,
	ListingURL NVARCHAR(500),
	City NVARCHAR(50),
	CraigsCityURL NVARCHAR(500),
	Price FLOAT,
	ModelYear SMALLINT,
	Manufacturer NVARCHAR(50),
	CarModel NVARCHAR(50),
	CarCondition NVARCHAR(50),
	CylinderCount NVARCHAR(50),
	FuelType NVARCHAR(50),
	OdometerReading FLOAT,
	CarStatus NVARCHAR(50),
	TransmissionType NVARCHAR(50),
	VehicleIdentificationNum NVARCHAR(50),
	DriveType NVARCHAR(50),
	CarSize NVARCHAR(50),
	CarBodyType NVARCHAR(50),
	CarColor NVARCHAR(50),
	ImageURL NVARCHAR(500),
	CarDescription NVARCHAR(MAX),
	StateCode NVARCHAR(50),
	Latitude FLOAT,
	Longitude FLOAT,
	PostedDate DATETIME
);

CREATE TABLE real.UsedCarsMasterData -- Syam Prajwal Kammula (skammul)
(
	MasterID BIGINT IDENTITY(1000000, 1) PRIMARY KEY,
	ListingURL NVARCHAR(500),
	City NVARCHAR(50),
	CraigsCityURL NVARCHAR(500),
	Price FLOAT,
	ModelYear SMALLINT,
	Manufacturer NVARCHAR(50),
	CarModel NVARCHAR(50),
	CarCondition NVARCHAR(50),
	CylinderCount NVARCHAR(50),
	FuelType NVARCHAR(50),
	OdometerReading FLOAT,
	CarStatus NVARCHAR(50),
	TransmissionType NVARCHAR(50),
	VehicleIdentificationNum NVARCHAR(50),
	DriveType NVARCHAR(50),
	CarSize NVARCHAR(50),
	CarBodyType NVARCHAR(50),
	CarColor NVARCHAR(50),
	ImageURL NVARCHAR(500),
	CarDescription NVARCHAR(MAX),
	StateCode NVARCHAR(50),
	Latitude FLOAT,
	Longitude FLOAT,
	PostedDate DATETIME
);

-- Now I am inserting all the data from the dataset into the above table
-- truncate the table first
TRUNCATE TABLE real.UsedCarsMasterData; -- Revanth Posina (rposina)
GO

-- import the file
BULK INSERT real.UsedCarsStagingData -- Ram Kiran Devireddy (radevir)
FROM 'D:\IUB\ADT\1_Project_SRR\Dataset\RawData\UsedCars.csv'
WITH
(
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	ORDER (
		MasterID,
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
	)
)
GO
;
-- (10330 rows affected)

-- Taking the Raw CSV Data from UsedCarsStagingData to Main MasterData Table with the 5 digit id we're generating
-- Ram Kiran Devireddy (radevir)
INSERT INTO real.UsedCarsMasterData (ListingURL, City, CraigsCityURL, Price, ModelYear, Manufacturer, CarModel
		, CarCondition, CylinderCount, FuelType, OdometerReading, CarStatus, TransmissionType, VehicleIdentificationNum
		, DriveType, CarSize, CarBodyType, CarColor, ImageURL, CarDescription, StateCode, Latitude, Longitude,PostedDate)
SELECT ListingURL, City, CraigsCityURL, Price, ModelYear, Manufacturer, CarModel, CarCondition, CylinderCount, FuelType, OdometerReading
		, CarStatus, TransmissionType, VehicleIdentificationNum, DriveType, CarSize, CarBodyType, CarColor, ImageURL, CarDescription, StateCode
		, Latitude, Longitude, PostedDate
FROM real.UsedCarsStagingData;


select * from real.UsedCarsMasterData;
select DISTINCT(MasterID) from real.UsedCarsMasterData;

-- Next Step is to Apply Normalization and Dividing into individual meaningfull, non redundant tables.

-- Syam Prajwal Kammula (skammul)
DROP TABLE real.CarListings;
DROP TABLE real.Locations;
DROP TABLE real.CarDetails;
DROP TABLE real.CarsMasterData;


CREATE TABLE real.CarsMasterData -- Revanth Posina (rposina)
(
    CarID INT IDENTITY(100,1) PRIMARY KEY,
	MasterID BIGINT,
    Manufacturer NVARCHAR(50),
    ModelYear SMALLINT,
    CylinderCount NVARCHAR(50),
    FuelType NVARCHAR(50),
    TransmissionType NVARCHAR(50),
    CarSize NVARCHAR(50),
    CarBodyType NVARCHAR(50),
    CarColor NVARCHAR(50),
    VehicleIdentificationNum NVARCHAR(50),
    DriveType NVARCHAR(50),
	FOREIGN KEY (MasterID) REFERENCES real.UsedCarsMasterData(MasterID)
);

CREATE TABLE real.CarDetails -- Revanth Posina (rposina)
(
	CarDetailsID INT IDENTITY(1, 1) PRIMARY KEY,
    CarID INT,
    CarCondition NVARCHAR(50),
    OdometerReading FLOAT,
    CarStatus NVARCHAR(50),
    ImageURL NVARCHAR(500),
    CarDescription NVARCHAR(MAX),
    FOREIGN KEY (CarID) REFERENCES real.CarsMasterData(CarID),
);

CREATE TABLE real.Locations -- Revanth Posina (rposina)
(
    LocationID INT IDENTITY(1,1) PRIMARY KEY,
	MasterID BIGINT,
    City NVARCHAR(50),
    StateCode NVARCHAR(50),
    Latitude FLOAT,
    Longitude FLOAT,
    CraigsCityURL NVARCHAR(500),
	FOREIGN KEY (MasterID) REFERENCES real.UsedCarsMasterData(MasterID)
);

CREATE TABLE real.CarListings -- Ram Kiran Devireddy (radevir)
(
	MasterID BIGINT,
    ListingID INT IDENTITY(1, 1) PRIMARY KEY,
    CarID INT,
    LocationID INT,
    Price FLOAT,
    PostedDate DATETIME,
    ListingURL NVARCHAR(500),
    FOREIGN KEY (CarID) REFERENCES real.CarsMasterData(CarID),
    FOREIGN KEY (LocationID) REFERENCES real.Locations(LocationID),
	FOREIGN KEY (MasterID) REFERENCES real.UsedCarsMasterData(MasterID)
);

INSERT INTO real.CarsMasterData (MasterID, Manufacturer, ModelYear, CylinderCount, FuelType, TransmissionType, CarSize -- Revanth Posina (rposina)
			, CarBodyType, CarColor, VehicleIdentificationNum, DriveType)
SELECT MasterID, Manufacturer, ModelYear, CylinderCount, FuelType, TransmissionType, CarSize, CarBodyType, CarColor
		, VehicleIdentificationNum, DriveType
FROM real.UsedCarsMasterData;


INSERT INTO real.CarDetails (CarID, CarCondition, OdometerReading, CarStatus, ImageURL, CarDescription) -- Revanth Posina (rposina)
SELECT c.CarID, CarCondition, OdometerReading, CarStatus, ImageURL, CarDescription
FROM real.UsedCarsMasterData ucmd
INNER JOIN real.CarsMasterData c ON ucmd.MasterID = c.MasterID;


INSERT INTO real.Locations (MasterID, City, StateCode, Latitude, Longitude) -- Syam Prajwal Kammula (skammul)
SELECT MasterID, City, StateCode, Latitude, Longitude
FROM real.UsedCarsMasterData;


INSERT INTO real.CarListings (MasterID, CarID, LocationID, Price, PostedDate, ListingURL) -- Ram Kiran Devireddy (radevir)
SELECT ucmd.MasterID, c.CarID, l.LocationID, Price, PostedDate, ListingURL
FROM real.UsedCarsMasterData ucmd
INNER JOIN real.CarsMasterData c ON ucmd.MasterID = c.MasterID
INNER JOIN real.Locations l ON ucmd.MasterID = l.MasterID;

select * from real.CarListings;


SELECT * FROM real.CarsMasterData;
SELECT * FROM real.CarDetails;
SELECT * FROM real.Locations;
SELECT * FROM real.CarListings;

SELECT ucmd.ListingURL, c.Manufacturer, c.ModelYear, l.City, cl.Price
FROM real.UsedCarsMasterData ucmd
INNER JOIN real.CarsMasterData c ON ucmd.MasterID = c.MasterID
INNER JOIN real.Locations l ON ucmd.MasterID = l.MasterID
INNER JOIN real.CarListings cl ON ucmd.MasterID = cl.MasterID;
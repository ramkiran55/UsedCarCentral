CREATE DATABASE UsedCarCentral; -- Ram Kiran Devireddy (radevir)

USE UsedCarCentral;

-- We'll be maintaining two schemas in this project. One will be to test our SQL code and the second one will be our main schema

-- Create schema named test
CREATE SCHEMA test -- -- Syam Prajwal Kammula (skammul)
GO
-- Create schema real
CREATE SCHEMA real
GO

-- Use schema test
-- Firstly I'm creating a table to just Import the data from our dataset with all the required columns. This table will be our master table from which we'll be deriving the main tables using Normalization.
DROP TABLE test.UsedCarsStagingData; -- Revanth Posina (rposina)
DROP TABLE test.UsedCarsMasterData;

CREATE TABLE test.UsedCarsStagingData -- Ram Kiran Devireddy (radevir)
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

CREATE TABLE test.UsedCarsMasterData -- Syam Prajwal Kammula (skammul)
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
TRUNCATE TABLE test.UsedCarsMasterData; -- Revanth Posina (rposina)
GO

-- import the file
BULK INSERT test.UsedCarsStagingData -- Ram Kiran Devireddy (radevir)
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
INSERT INTO test.UsedCarsMasterData (ListingURL, City, CraigsCityURL, Price, ModelYear, Manufacturer, CarModel
		, CarCondition, CylinderCount, FuelType, OdometerReading, CarStatus, TransmissionType, VehicleIdentificationNum
		, DriveType, CarSize, CarBodyType, CarColor, ImageURL, CarDescription, StateCode, Latitude, Longitude,PostedDate)
SELECT ListingURL, City, CraigsCityURL, Price, ModelYear, Manufacturer, CarModel, CarCondition, CylinderCount, FuelType, OdometerReading
		, CarStatus, TransmissionType, VehicleIdentificationNum, DriveType, CarSize, CarBodyType, CarColor, ImageURL, CarDescription, StateCode
		, Latitude, Longitude, PostedDate
FROM test.UsedCarsStagingData;


select * from test.UsedCarsMasterData;
select DISTINCT(MasterID) from test.UsedCarsMasterData;

-- Next Step is to Apply Normalization and Dividing into individual meaningfull, non redundant tables.

-- Syam Prajwal Kammula (skammul)
DROP TABLE test.CarListings;
DROP TABLE test.Locations;
DROP TABLE test.CarDetails;
DROP TABLE test.CarsMasterData;


CREATE TABLE test.CarsMasterData -- Revanth Posina (rposina)
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
	FOREIGN KEY (MasterID) REFERENCES test.UsedCarsMasterData(MasterID)
);

CREATE TABLE test.CarDetails -- Revanth Posina (rposina)
(
	CarDetailsID INT IDENTITY(1, 1) PRIMARY KEY,
    CarID INT,
    CarCondition NVARCHAR(50),
    OdometerReading FLOAT,
    CarStatus NVARCHAR(50),
    ImageURL NVARCHAR(500),
    CarDescription NVARCHAR(MAX),
    FOREIGN KEY (CarID) REFERENCES test.CarsMasterData(CarID),
);

CREATE TABLE test.Locations -- Revanth Posina (rposina)
(
    LocationID INT IDENTITY(1,1) PRIMARY KEY,
	MasterID BIGINT,
    City NVARCHAR(50),
    StateCode NVARCHAR(50),
    Latitude FLOAT,
    Longitude FLOAT,
    CraigsCityURL NVARCHAR(500),
	FOREIGN KEY (MasterID) REFERENCES test.UsedCarsMasterData(MasterID)
);

CREATE TABLE test.CarListings -- Ram Kiran Devireddy (radevir)
(
	MasterID BIGINT,
    ListingID INT IDENTITY(1, 1) PRIMARY KEY,
    CarID INT,
    LocationID INT,
    Price FLOAT,
    PostedDate DATETIME,
    ListingURL NVARCHAR(500),
    FOREIGN KEY (CarID) REFERENCES test.CarsMasterData(CarID),
    FOREIGN KEY (LocationID) REFERENCES test.Locations(LocationID),
	FOREIGN KEY (MasterID) REFERENCES test.UsedCarsMasterData(MasterID)
);

INSERT INTO test.CarsMasterData (MasterID, Manufacturer, ModelYear, CylinderCount, FuelType, TransmissionType, CarSize -- Revanth Posina (rposina)
			, CarBodyType, CarColor, VehicleIdentificationNum, DriveType)
SELECT MasterID, Manufacturer, ModelYear, CylinderCount, FuelType, TransmissionType, CarSize, CarBodyType, CarColor
		, VehicleIdentificationNum, DriveType
FROM test.UsedCarsMasterData;


INSERT INTO test.CarDetails (CarID, CarCondition, OdometerReading, CarStatus, ImageURL, CarDescription) -- Revanth Posina (rposina)
SELECT c.CarID, CarCondition, OdometerReading, CarStatus, ImageURL, CarDescription
FROM test.UsedCarsMasterData ucmd
INNER JOIN test.CarsMasterData c ON ucmd.MasterID = c.MasterID;


INSERT INTO test.Locations (MasterID, City, StateCode, Latitude, Longitude) -- Syam Prajwal Kammula (skammul)
SELECT MasterID, City, StateCode, Latitude, Longitude
FROM test.UsedCarsMasterData;


INSERT INTO test.CarListings (MasterID, CarID, LocationID, Price, PostedDate, ListingURL) -- Ram Kiran Devireddy (radevir)
SELECT ucmd.MasterID, c.CarID, l.LocationID, Price, PostedDate, ListingURL
FROM test.UsedCarsMasterData ucmd
INNER JOIN test.CarsMasterData c ON ucmd.MasterID = c.MasterID
INNER JOIN test.Locations l ON ucmd.MasterID = l.MasterID;

select * from test.CarListings;
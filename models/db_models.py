import connection
import datetime

def insertCarListing(car_listing_data):
    con = connection.connection_uri()
    cursor = con.cursor()
    now = datetime.datetime.now()

    # Format the date and time as a string in the MS SQL format
    sql_datetime = now.strftime("%Y-%m-%d %H:%M:%S.%f")
    """
    Flow of inserting into Car Listings
    
     -- real.CreateUsedCarsMasterData -- 
     -- real.CreateCarsMasterData -- 
     -- real.CreateCarDetails --
     -- real.CreateLocations --
     -- real.CreateListings --
    """
    # set up input parameters
    ListingURL = car_listing_data["carCondition"]
    City = car_listing_data["city"]
    CraigsCityURL = car_listing_data["craigsCityUrl"]
    Price = car_listing_data["price"]
    ModelYear = car_listing_data["modelYear"]
    Manufacturer = car_listing_data["manufacturer"]
    CarModel = car_listing_data["model"]
    CarCondition = car_listing_data["carCondition"]
    CylinderCount = car_listing_data["cylinderCount"]
    FuelType = car_listing_data["fuelType"]
    OdometerReading = car_listing_data["odometerReading"]
    CarStatus = car_listing_data["carStatus"]
    TransmissionType = car_listing_data["transmissionType"]
    VehicleIdentificationNum = car_listing_data["vehicleIdentificationNum"]
    DriveType = car_listing_data["driveType"]
    CarSize = car_listing_data["carSize"]
    CarBodyType = car_listing_data["carBodyType"]
    CarColor = car_listing_data["carColor"]
    ImageURL = car_listing_data["imageUrl"]
    CarDescription = car_listing_data["carDesc"]
    StateCode = car_listing_data["state"]
    Latitude = car_listing_data["latitude"]
    Longitude = car_listing_data["logitude"]
    userid = car_listing_data["userid"]
    #PostedDate = sql_datetime
    # set up output parameter
    out = 0

    # execute stored procedure
    cursor.execute("{CALL real.CreateUsedCarsMasterData(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}",
                (ListingURL, City, CraigsCityURL, Price, ModelYear, Manufacturer, CarModel, CarCondition, CylinderCount, FuelType, OdometerReading,
                    CarStatus, TransmissionType, VehicleIdentificationNum, DriveType, CarSize, CarBodyType, CarColor, ImageURL, CarDescription,
                    StateCode, Latitude, Longitude, userid, out))

    # commit the transaction
    con.commit()

    # get output parameter value
    #print("Output parameter value:", out)

    # close cursor and connection
    cursor.close()
    con.close()
    return out

def updateCarListings(updated_listings, listing_id):
    con = connection.connection_uri()
    cursor = con.cursor()
    #cursor.execute("EXEC real.UpdateCarPrice "+str(id)+", "+str(val))
    params = [
        updated_listings['model']
        , updated_listings['condition']
        , updated_listings['manufacturer']
        , updated_listings['price']
        , updated_listings['size']
        , updated_listings['city']
        , updated_listings['state']
        , listing_id
    ]
    print(params)
    cursor.execute("{CALL real.UpdateCarListing(?, ?, ?, ?, ?, ?, ?, ?)}", params=params)
    con.commit()
    cursor.close()
    con.close()
    return
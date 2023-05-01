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

    # # execute stored procedure
    # cursor.execute("CALL real.CreateUsedCarsMasterData(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)",
    #             (ListingURL, City, CraigsCityURL, Price, ModelYear, Manufacturer, CarModel, CarCondition, CylinderCount, FuelType, OdometerReading,
    #                 CarStatus, TransmissionType, VehicleIdentificationNum, DriveType, CarSize, CarBodyType, CarColor, ImageURL, CarDescription,
    #                 StateCode, Latitude, Longitude, userid, out))
    

    params = (ListingURL, City, CraigsCityURL, Price, ModelYear, Manufacturer, CarModel, CarCondition, CylinderCount, FuelType, OdometerReading,
               CarStatus, TransmissionType, VehicleIdentificationNum, DriveType, CarSize, CarBodyType, CarColor, ImageURL, CarDescription, StateCode, Latitude, Longitude, userid, out)
    cursor.execute('EXEC real.CreateUsedCarsMasterData @ListingURL=%s, @City=%s, @CraigsCityURL=%s, @Price=%s, @ModelYear=%s, @Manufacturer=%s, @CarModel=%s, @CarCondition=%s, @CylinderCount=%s, @FuelType=%s, @OdometerReading=%s, @CarStatus=%s, @TransmissionType=%s, @VehicleIdentificationNum=%s, @DriveType=%s, @CarSize=%s, @CarBodyType=%s, @CarColor=%s, @ImageURL=%s, @CarDescription=%s, @StateCode=%s, @Latitude=%s, @Longitude=%s, @UserID=%s, @out=%s', params)



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
    print("{CALL real.UpdateCarListing(?, ?, ?, ?, ?, ?, ?, ?)}", params)
    model=str(updated_listings['model'])
    condition=str(updated_listings['condition'])
    manufacture=str(updated_listings['manufacturer'])
    price=str(updated_listings['price'])
    size=str(updated_listings['size'])
    city=str(updated_listings['city'])
    state=str(updated_listings['state'])
    # print(params)
    # cursor.execute("CALL real.UpdateCarListing(%s, %s, %s, %s, %s, %s, %s, %s)", (model,condition,manufacture,price,size,city,state,listing_id))
    print("EXEC real.UpdateCarListing("+model+", "+condition+", "+manufacture+", "+price+", "+size+", "+city+", "+state+", "+str(listing_id)+")") 
    # cursor.execute("EXEC real.UpdateCarListing @CarModel="+model+", @CarCondition="+condition+", @Manufacturer="+manufacture+", @Price="+price+", @CarSize="+size+", @City="+city+", @StateCode="+state+", @ListingID="+str(listing_id))
    cursor.execute("EXEC real.UpdateCarListing @CarModel=%s, @CarCondition=%s, @Manufacturer=%s, @Price=%s, @CarSize=%s, @City=%s, @StateCode=%s, @ListingID=%s",
               (model, condition, manufacture, price, size, city, state, listing_id))


    cursor.close()
    con.commit()
    con.close()
    return
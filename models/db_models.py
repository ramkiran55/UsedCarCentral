import connection

def createCarListing(id, manufacturer, modelYear, cylinderCount, fuelType, transmissionType, carSize, carBodyType, carColor, vin, driveType):
    con = connection.connection_uri()
    cursor = con.cursor()
    
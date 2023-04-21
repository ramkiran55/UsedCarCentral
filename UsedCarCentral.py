import pyodbc
from flask import Flask, render_template
from connection import connection_uri
from flask import Flask, render_template, request, redirect

UsedCarCentral = Flask(__name__)

@UsedCarCentral.route("/")
def main():
    car_listings = []
    con = connection_uri()
    cursor = con.cursor()
    cursor.execute("SELECT TOP (5) * FROM real.CarListings")
    for row in cursor.fetchall():
        #print(row) 
        car_listings.append(
                                {
                                    "id": row[0]
                                    , "ListingID": row[1]
                                    , "CarID": row[2]
                                    , "LocationID": row[3]
                                    , "Price": row[4]
                                    , "PostedDate": row[5]
                                    , "ListingURL": row[6] 
                                }
                            )
    return render_template("CarsList.html", car_listings = car_listings)

@UsedCarCentral.route("/addcarlisting", methods = ['GET', 'POST'])
def addCarListing():
    if request.method == 'GET':
        return render_template("AddCarMasterData.html")
    if request.method == "POST":
        id = int(request.form["id"])
        manufacturer = str(request.form["manufacturer"])
        modelYear = str(request.form["modelYear"])
        cylinderCount = str(int(request.form["cylinderCount"])) + ' cylinders'
        fuelType = str(request.form["fuelType"])
        transmissionType = str(request.form["transmissionType"])
        carSize = str(request.form["carSize"])
        carBodyType = str(request.form["carBodyType"])
        carColor = str(request.form["carColor"])
        vehicleIdentificationNum = str(request.form["vehicleIdentificationNum"])
        driveType = str(request.form["driveType"])
        print('fetching Done')
        print('id',id)
        print('cylinderCount',cylinderCount)
        print('fuelType',fuelType)
        print('transmissionType',transmissionType)
        print('carSize',carSize)
        print('carBodyType',carBodyType)
        print('carColor',carColor)
        print('vehicleIdentificationNum',vehicleIdentificationNum)
        print('driveType',driveType)



if __name__ == "__main__":
    UsedCarCentral.run()
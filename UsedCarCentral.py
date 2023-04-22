import pyodbc
from flask import Flask, render_template
from connection import connection_uri
from flask import Flask, render_template, request, redirect
from models import db_models
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

car_listing_data = {}
@UsedCarCentral.route("/addcarlisting", methods = ['GET', 'POST'])
def addCarListing():
    if request.method == 'GET':
        return render_template("AddCarMasterData.html")
    if request.method == "POST":
        #id = int(request.form["id"])
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
        # print('fetching Done')
        # print('id',id)
        # print('cylinderCount',cylinderCount)
        # print('fuelType',fuelType)
        # print('transmissionType',transmissionType)
        # print('carSize',carSize)
        # print('carBodyType',carBodyType)
        # print('carColor',carColor)
        # print('vehicleIdentificationNum',vehicleIdentificationNum)
        # print('driveType',driveType)
        car_listing_data["manufacturer"] = manufacturer
        car_listing_data["modelYear"] = modelYear
        car_listing_data["cylinderCount"] = cylinderCount
        car_listing_data["fuelType"] = fuelType
        car_listing_data["transmissionType"] = transmissionType
        car_listing_data["carSize"] = carSize
        car_listing_data["carBodyType"] = carBodyType
        car_listing_data["carColor"] = carColor
        car_listing_data["vehicleIdentificationNum"] = vehicleIdentificationNum
        car_listing_data["driveType"] = driveType
        # print(car_listing_data)
        return redirect('/addcardetails')
        
@UsedCarCentral.route("/addcardetails", methods = ['GET', 'POST'])
def addCarDetails():
    if request.method == 'GET':
        return render_template("AddCarDetails.html")
    if request.method == "POST":
        car_listing_data["carCondition"] = str(request.form["carCondition"])
        car_listing_data["odometerReading"] = str(request.form["odometerReading"])
        car_listing_data["carStatus"] = str(request.form["carStatus"])
        car_listing_data["imageUrl"] = str(request.form["imageUrl"])
        car_listing_data["carDesc"] = str(request.form["carDesc"])
        # print(car_listing_data)
        return redirect('/addlocation')
    
@UsedCarCentral.route("/addlocation", methods = ['GET', 'POST'])
def addLocationDetails():
    if request.method == 'GET':
        return render_template("AddLocationDetails.html")
    if request.method == "POST":
        car_listing_data["city"] = str(request.form["city"])
        car_listing_data["state"] = str(request.form["state"])
        car_listing_data["latitude"] = float(request.form["latitude"])
        car_listing_data["logitude"] = float(request.form["logitude"])
        car_listing_data["craigsCityUrl"] = str(request.form["craigsCityUrl"])
        # print(car_listing_data)
        db_models.insertCarListing(car_listing_data)
        return redirect('/')
    
if __name__ == "__main__":
    UsedCarCentral.run()
import pyodbc
import os
from flask import Flask, render_template
from connection import connection_uri
from flask import Flask, render_template, request, redirect, url_for
from models import db_models
from models.User import User
from flask_login import (
    LoginManager,
    current_user,
    login_required,
    login_user,
    logout_user,
)

UsedCarCentral = Flask(__name__)

# User session management setup
# https://flask-login.readthedocs.io/en/latest
login_manager = LoginManager()
login_manager.init_app(UsedCarCentral)
UsedCarCentral.secret_key = os.environ.get("SECRET_KEY") or os.urandom(24)


@login_manager.user_loader
def load_user(user_id):
    # Load user from database
    return User.get_by_id(user_id)

@UsedCarCentral.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form.get('email')
        password = request.form.get('password')
        print(email,password)
        user =User.get_by_email(email)
        print(email,password)
        
        if user and User.check_password(user,password):
            login_user(user)
            return redirect(url_for('home'))
        else:
            return render_template('login.html', error='Invalid username or password !')
    else:
        return render_template('login.html')

@UsedCarCentral.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('login'))

@UsedCarCentral.route('/home')
@login_required
def home():
    return render_template('home.html', user=current_user)

@UsedCarCentral.route('/landing')
@UsedCarCentral.route('/')
def landing():
    return render_template('landing.html')

@UsedCarCentral.route('/register', methods=['GET', 'POST'])
def register():

    print(request.method)
    if request.method == 'POST':
        print("inPost")
        name = request.form.get('name')
        email = request.form.get('email')
        password = request.form.get('password')
        confirm_password = request.form.get('confirm_password')
        print(name,email,password)
        if password != confirm_password:
            return render_template('register.html', error='Passwords do not match')
        if User.get_by_email(email):
            return render_template('register.html', error='Username already taken')
        # user = User(name=name, password=password, email=email)
        # print(user)
        print('gng to register')
        user=User.register(name,email,password)
        login_user(user)
        return redirect(url_for('home'))
    else:
        print("inGet")
        return render_template('register.html')

@UsedCarCentral.route("/getcarlistings")
def getCarListings():
    car_listings = []
    con = connection_uri()
    cursor = con.cursor()
    stored_proc_name = 'real.ReadCarListings'
    params = []
    result_set = cursor.execute(f"EXEC {stored_proc_name}", params).fetchall()
    for row in result_set[:10]:
        print('inside') 
        car_listings.append(
                                {
                                    "model": row[0]
                                    , "manufacturer": row[1]
                                    , "price": row[2]
                                    , "size": row[3]
                                    , "condition": row[4]
                                    , "city": row[5]
                                    , "state": row[6]
                                    , "date": row[7] 
                                }
                            )
    return render_template("listing.html", car_listings = car_listings)

#     return render_template("index.html")

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
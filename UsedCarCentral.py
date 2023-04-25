import pyodbc
import os
from flask import Flask, render_template, session
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
        session["email"] = email
        password = request.form.get('password')
        print(email,password)
        user =User.get_by_email(email)
        print(email,password)
        
        if user and User.check_password(user,password):
            session["email"] = email
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
    return render_template('prelisting.html', user=current_user)


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
        session["email"] = email
        login_user(user)
        return redirect(url_for('home'))
    else:
        print("inGet")
        return render_template('register.html')

@UsedCarCentral.route("/getcarlistings")
def getcarlistings():
    car_listings = []
    con = connection_uri()
    cursor = con.cursor()
    stored_proc_name = 'real.ReadCarListings'
    params = []
    result_set = cursor.execute(f"EXEC {stored_proc_name}", params).fetchall()
    # i = 0
    # for row in result_set:
    #     print(row)
    for row in result_set:
        #print('inside') 
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
        # i += 1
        # print('next ', i)
    return render_template("listing.html", car_listings = car_listings)

#     return render_template("index.html")

@UsedCarCentral.route("/getmycarlistings", methods = ['GET', 'POST'])
def getmycarlistings():
    if request.method == 'GET':
        my_car_listings = []
        try:
            #print(session)
            user=current_user
            #print(user.id)
            con = connection_uri()
            cursor = con.cursor()
            print('user is ', user.name, user.id)
            cursor.execute("EXEC real.ReadUserCarListings "+str(user.id))
            print('Here')
            result_set = cursor.fetchall()
            for row in result_set:
                #print('inside') 
                my_car_listings.append(
                                        {
                                            "model": row[0]
                                            , "manufacturer": row[1]
                                            , "price": row[2]
                                            , "size": row[3]
                                            , "condition": row[4]
                                            , "city": row[5]
                                            , "state": row[6]
                                            , "date": row[7] 
                                            , "listingid" : row[8]
                                        }
                                    )
            #print(my_car_listings)
            return render_template("mylisting.html", car_listings = my_car_listings)
        except:
            error = 'Please login to your account to check your car listings!'
            print(error)
            render_template("login.html", error = error)
            return redirect('/login')
    else:
        return redirect('/getmycarlistings')


@UsedCarCentral.route("/success")
def Success():
    return 'Success!'
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
        car_listing_data["model"] = str(request.form["model"])
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
        car_listing_data["price"] = float(request.form["price"])
        #print(car_listing_data)
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
        car_listing_data["craigsCityUrl"] = car_listing_data["city"] + '-craigslist.org'
        user = current_user
        car_listing_data["userid"] = user.id
        print(car_listing_data)
        out = db_models.insertCarListing(car_listing_data)
        #print(out)
        if out == 0:
            return redirect('/getmycarlistings')
        return redirect('/')
    
@UsedCarCentral.route("/update/<int:listingid>", methods = ['GET'])
def updateCarListing(listingid, price):

    print(listingid)
    conn = connection_uri()
    cursor = conn.cursor()
    out = 0
    # EXEC real.UpdateCarPrice 10345, 33333
    #cursor.execute("EXEC real.DeleteCarListing "+str(user.id)+","+str(listingid))
    # Call the stored procedure
    price = int(price)
    listing_id = listingid
    statement = "EXEC real.UpdateCarPrice "+ str(listing_id)+", "+str(price)
    cursor.execute(statement)
    return redirect('/getmycarlistings')
    
@UsedCarCentral.route('/delete/<int:listingid>', methods=['GET'])
def deleteCarListing(listingid):
    user = current_user
    print(listingid)
    conn = connection_uri()
    cursor = conn.cursor()
    out = 0
    #cursor.execute("EXEC real.DeleteCarListing "+str(user.id)+","+str(listingid))
    # Call the stored procedure
    user_id = int(user.id)
    listing_id = listingid
    #cursor.execute("{CALL real.DeleteCarListing(?, ?)}", user_id, listing_id)
    print('Excecuting')
    statement = "EXEC real.DeleteCarListing "+ str(user_id)+", "+str(listing_id)
    #statement = "Delete from  "
    print('Excecuted..')
    cursor.execute(statement)
    cursor.commit()
    cursor.close()
    conn.close()
    print(out)
    #result_set = cursor.fetchall()
    #print(result_set)
    return redirect('/getmycarlistings')
    
    
if __name__ == "__main__":
    UsedCarCentral.run()
    
    
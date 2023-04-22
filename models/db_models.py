import connection

def insertCarListing(car_listing):
    con = connection.connection_uri()
    cursor = con.cursor()
    
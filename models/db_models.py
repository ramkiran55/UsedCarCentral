import connection

def insertCarListing(car_listing):
    con = connection.connection_uri()
    cursor = con.cursor()
    
    """
    Flow of inserting into Car Listings
    
     -- real.CreateUsedCarsMasterData -- 
     -- real.CreateCarsMasterData -- 
     -- real.CreateCarDetails --
     -- real.CreateLocations --
     -- real.CreateListings --
    """
    stored_procedure = "real.CreateUsedCarsMasterData"
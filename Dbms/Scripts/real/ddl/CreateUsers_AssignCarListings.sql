USE UsedCarCentral
GO

INSERT INTO real.users (user_name, user_email, user_password) 
VALUES ('Ram Kiran', 'radevir@iu.edu', 'root');

INSERT INTO real.users (user_name, user_email, user_password) 
VALUES ('Syam Prajwal', 'skammul@iu.edu', 'root');

INSERT INTO real.users (user_name, user_email, user_password) 
VALUES ('Revanth', 'rposina@iu.edu', 'root');


-- User 1 car listings
-- User 1 car listings
DECLARE @user1 INT;
SELECT @user1 = user_id FROM real.users WHERE user_name = 'Ram Kiran';

INSERT INTO real.UserCarListings (UserID, CarListingID)
SELECT @user1, ListingID
FROM (
    SELECT TOP 15 ListingID, PostedDate
    FROM real.CarListings
    WHERE NOT PostedDate IS NULL
    ORDER BY PostedDate DESC
) AS top_listings;
--SELECT * FROM real.UserCarListings;
-- User 2 car listings
DECLARE @user2 INT;
SELECT @user2 = user_id FROM real.users WHERE user_name = 'Syam Prajwal';
--DELETE FROM real.UserCarListings WHERE UserID = @user2;
--SELECT * FROM real.UserCarListings WHERE UserID = @user2;

INSERT INTO real.UserCarListings (UserID, CarListingID)
SELECT @user2, ListingID
FROM (
    SELECT TOP 10 ListingID FROM (
        SELECT ListingID, PostedDate
        FROM real.CarListings
        WHERE NOT PostedDate IS NULL
        ORDER BY PostedDate DESC OFFSET 15 ROWS
    ) AS listings
) AS top_listings;


-- User 3 car listings
DECLARE @user3 INT;
SELECT @user3 = user_id FROM real.users WHERE user_name = 'Revanth';

INSERT INTO real.UserCarListings (UserID, CarListingID)
SELECT @user3, ListingID
FROM (
    SELECT TOP 10 ListingID FROM (
        SELECT ListingID, PostedDate
        FROM real.CarListings
        WHERE NOT PostedDate IS NULL
        ORDER BY PostedDate DESC OFFSET 45 ROWS
    ) AS listings
) AS top_listings;


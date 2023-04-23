USE UsedCarCentral
GO

CREATE PROCEDURE real.GetUserByUserEmail
    @user_email nvarchar(max)
AS
BEGIN
    SELECT user_id FROM real.users WHERE user_email = @user_email;
END
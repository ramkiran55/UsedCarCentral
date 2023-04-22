from flask_login import UserMixin
from werkzeug.security import generate_password_hash, check_password_hash
from connection import connection_uri


class User(UserMixin):
    def __init__(self, id, name,email, password):
        self.id = id
        self.email = email
        self.name = name
        self.password_hash = password

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)
    
    def get_by_email(user_email):
        con = connection_uri()
        cursor = con.cursor()
        cursor.execute('SELECT * FROM real.users where user_email= ? ',(user_email))
        user_details=cursor.fetchone()
        cursor.close()
        print('In get by email')
        if not user_details:
            return None
        user=User(
            id=user_details[0],
            name=user_details[1],
            email=user_details[2],
            password=user_details[3]
        )
        return user
    
    def get_by_id(user_id):
        con = connection_uri()
        cursor = con.cursor()
        cursor.execute('SELECT * FROM real.users where user_id= ? ',(user_id))
        user_details=cursor.fetchone()
        cursor.close()
        print('In get by email')
        if not user_details:
            return None
        user=User(
            id=user_details[0],
            name=user_details[1],
            email=user_details[2],
            password=user_details[3]
        )
        return user
    
    def register(name,email,password):
        con = connection_uri()
        cursor = con.cursor()
        print(name,email,password,generate_password_hash(password))
        # cursor.execute("EXEC Create_New_User @uname=?, @email=?, @pass=?", (name,email,generate_password_hash(password)))
        cursor.execute("Insert into real.users (user_name,user_email,user_password) values (?, ?, ?)", (name,email,generate_password_hash(password)))
        cursor.execute("Select * from real.users where user_email= ?", (email))
        print('In register')
        user_details=cursor.fetchone()
        cursor.close()
        con.commit()
        if not user_details:
            print('user not registered successfully!')
            return None
        if user_details:
            print('success')
            print(user_details)
            print(user_details[2],user_details[0])
        user=User(
            id=user_details[0],
            name=user_details[1],
            email=user_details[2],
            password=user_details[3]
        )
        return user

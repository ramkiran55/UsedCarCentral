import pyodbc
from flask import Flask, render_template
from connection import connection_uri

UsedCarCentral = Flask(__name__)

@UsedCarCentral.route("/")
def main():
    con = connection_uri()
    cursor = con.cursor()
    cursor.execute("SELECT TOP (5) * FROM real.CarListings")
    for row in cursor.fetchall():
        print(row)
    return render_template("CarsList.html")

if __name__ == "__main__":
    UsedCarCentral.run()
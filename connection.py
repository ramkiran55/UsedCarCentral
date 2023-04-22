import os
import pyodbc
from app import app
from flask import Flask, render_template, request, url_for, redirect
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.engine import URL

from sqlalchemy.sql import func
connection_url = ""
# connection_url = URL.create(
#     "mssql+pyodbc",
#     username="sa",
#     password="Naruto#07",
#     host="DESKTOP-0THVV6S",
#     port=1433,
#     database="UsedCarCentral",
#     query={
#         "driver": "ODBC Driver 18 for SQL Server",
#         "TrustServerCertificate": "yes",
#         "authentication": "ActiveDirectoryIntegrated",
#     },
#)

def connection_uri():
    # sqlcmd -S adt-project-server.database.windows.net -d UsedCarCentral -U adtstudent -P R00tR00t
    s = 'adt-project-server.database.windows.net' #Your server name 
    d = 'UsedCarCentral' 
    u = 'adtstudent'
    p = 'R00tR00t'
    cstr = 'DRIVER={SQL Server};SERVER='+s+';DATABASE='+d+';UID='+u+';PWD='+ p
    conn = pyodbc.connect(cstr)
    return conn

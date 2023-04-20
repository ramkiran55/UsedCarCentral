import os
import pyodbc
from app import app
from flask import Flask, render_template, request, url_for, redirect
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.engine import URL

from sqlalchemy.sql import func

connection_url = URL.create(
    "mssql+pyodbc",
    username="sa",
    password="Naruto#07",
    host="DESKTOP-0THVV6S",
    port=1433,
    database="UsedCarCentral",
    query={
        "driver": "ODBC Driver 18 for SQL Server",
        "TrustServerCertificate": "yes",
        "authentication": "ActiveDirectoryIntegrated",
    },
)



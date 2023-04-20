import os
from app import app
from connection import connection_url
from flask import Flask, render_template, request, url_for, redirect
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import Column, Integer, String
from sqlalchemy.sql import func

app.config['SQLALCHEMY_DATABASE_URI'] = connection_url
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

class CarsMasterData(db.Model):
    CarID = Column(Integer, primary_key=True)
    MasterID = Column(Integer)
    Manufacturer = Column(String)
    ModelYear = Column(Integer)
    CylinderCount = Column(String)
    FuelType = Column(String)
    TransmissionType = Column(String)
    CarSize = Column(String)
    CarBodyType = Column(String)
    CarColor = Column(String)
    VehicleIdentificationNum = Column(String)
    DriveType = Column(String)
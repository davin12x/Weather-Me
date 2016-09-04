//
//  CONSTANTS.swift
//  Weather-R-7
//
//  Created by Lalit on 2016-08-29.
//  Copyright © 2016 Bagga. All rights reserved.
//

import Foundation

typealias DownloadComplete = () -> ()
 var BASE_URL = "http://api.openweathermap.org/data/2.5/"
 var APP_KEY = "&appid=c5a12fa0b82dbcac2d580ac79e38d59a"
 var URL_UNITS = "&units=metric"

var lat :Double!
var lon:Double!
var city:String!
var CORRDINATES = "forecast?lat=\(lat)&lon=\(lon)";
var CITYURL = "find?q=\(city)"

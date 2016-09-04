//
//  DailyWeatherReport.swift
//  Weather-R-7
//
//  Created by Lalit on 2016-08-29.
//  Copyright © 2016 Bagga. All rights reserved.
//

import Foundation
import Alamofire

class DailyWeatherReport {
    private var _cityName:String!
    private var _country:String!
    private var _currentTemp:Double!
    private var _maxTemp:Double!
    private var _minTemp:Double!
    private var _weather:String!
    private var _date :String!
    private var _iconCode:String!
    
    init(city:String,country:String,currentTemp:Double,maxTemp:Double,minTemp:Double,weather:String,date:String,iconCode:String){
        _cityName = city
        _country = country
        _currentTemp = currentTemp
        _maxTemp = maxTemp
        _minTemp = minTemp
        _weather = weather
        _date = date
        _iconCode = iconCode
    }
    
    var cityName:String{
        return _cityName
    }
    var country:String{
        return _country
    }
    
    var currentTemp:Double {
        return round(_currentTemp)
    }
    var maxTemp:Double {
        
        return round(_maxTemp)
    }
    var minTemp:Double{
        return round(_minTemp)
    }
    var weather:String{
        return _weather
    }
    var date:String {
        return _date
    }
    var iconCode:String {
        return getIcon(_iconCode)
    }
    
    func getIcon(iconCode:String)->String {
        let lastCharacter = iconCode.characters.last!
        let ICON :String!
        switch iconCode {
        case "01\(lastCharacter)":
            //sunny
            ICON =  "Sunny"
            break;
        case "02\(lastCharacter)":
             ICON =  "PartiallyCloudy"
            break;
        case "03\(lastCharacter)":
            ICON =  "Cloudy"
            break;
        case "04\(lastCharacter)":
             ICON =  "Cloudy"
            break;
        case "09\(lastCharacter)":
             ICON =  "Rainy"
            break;
        case "10\(lastCharacter)":
             ICON =  "Rainy"
            break;
        case "11\(lastCharacter)":
             ICON = "Lightning"
            break;
        case "13\(lastCharacter)":
             ICON =  "Snow"
            break;
        case "50\(lastCharacter)":
             ICON =  "PartiallyCloudy"
            break;
        case"01\(lastCharacter)":
            ICON =  "moon"
            break;
        case "02\(lastCharacter)":
             ICON =  "PartiallyCloudyCopy"
            break;
        default:
            ICON =  "PartiallyCloudyCopy"
        }
        return ICON
    }
    
}


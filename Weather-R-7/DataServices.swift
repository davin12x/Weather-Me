//
//  DataServices.swift
//  Weather-R-7
//
//  Created by Lalit on 2016-08-30.
//  Copyright © 2016 Bagga. All rights reserved.
//

import Foundation
import Alamofire
class DataServices {
    private var _cityName:String!
    private var _country:String!
    private var _currentTemp:Double!
    private var _maxTemp:Double!
    private var _minTemp:Double!
    private var _weather:String!
    private var _date :String!
    private var _iconCode:String!
    private var index = 1
    private var todayWeather = true
    var dailyReport = [DailyWeatherReport]()
    let event = EventManager();
    var URL:String!
    
    
    init(){
        // method will start downloading weather data
        weatherToggle()
    }
    
    //First time this will give url to find location by city.
    //else find by long,lat
    func weatherToggle() -> Void {
        
        if todayWeather {
            URL = BASE_URL+CITYURL+URL_UNITS+APP_KEY
        } else {
            URL = BASE_URL+CORRDINATES+URL_UNITS+APP_KEY
        }
        
        downloadWeatherDetail()
    }
    
    
    //function will call get and start fetching weather data
    func downloadWeatherDetail(){
        
        Alamofire.request(.GET, URL).responseJSON { response in
            if let dict = response.result.value as? Dictionary<String,AnyObject> {
                
                if(self.todayWeather) {
                    if let list = dict["list"] as? [Dictionary<String,AnyObject>] where list.count > 0 {
                        if let main = list[0]["main"] as?Dictionary<String,AnyObject> {
                            if let min_temp = main["temp_min"] as? Double {
                                self._minTemp = min_temp
                            }
                            if let max_temp = main["temp_max"] as? Double {
                                self._maxTemp = max_temp
                            }
                            if let currentTemp = main["temp"] as? Double {
                                self._currentTemp = currentTemp
                            }
                        }
                        if let weather = list[0]["weather"] as? [Dictionary<String,AnyObject>] {
                            if let icon = weather[0]["icon"] as? String {
                                self._iconCode = icon
                            }
                            
                            if let weatherType = weather[0]["main"] as?String {
                                self._weather = weatherType
                            }
                        }
                    }
                    
                    
                    self._date = "0"
                    self._cityName = city
                    self._country = country
                    let report = DailyWeatherReport(city: self._cityName,country: self._country,currentTemp: self._currentTemp,maxTemp: self._maxTemp,minTemp: self._minTemp,weather:
                        self._weather,date: self._date,iconCode: self._iconCode)
                    
                    self.dailyReport.append(report)
                    self.todayWeather = false
                    //call method again to downlod data for other days
                    self.weatherToggle()
                    
                } else {
                    
                    for _ in 0...4 {
                        //list
                        if let list = dict["list"] as? [Dictionary<String,AnyObject>] where list.count > 0 {
                            if let date = list[self.index]["dt_txt"] as? String {
                                self._date = "\(self.timeFormatter(date))"
                            }
                            
                            
                            if let weather = list[self.index]["weather"] as? [Dictionary<String,AnyObject>] {
                                if let icon = weather[0]["icon"] as? String {
                                    self._iconCode = icon
                                }
                                
                                if let weatherType = weather[0]["main"] as?String {
                                    self._weather = weatherType
                                }
                            }
                            
                            if let main = list[self.index]["main"] as?Dictionary<String,AnyObject> {
                                if let min_temp = main["temp_min"] as? Double {
                                    self._minTemp = min_temp
                                }
                                if let max_temp = main["temp_max"] as? Double {
                                    self._maxTemp = max_temp
                                }
                                if let currentTemp = main["temp"] as? Double {
                                    self._currentTemp = currentTemp
                                }
                            }
                        }
                        
                        let report = DailyWeatherReport(city: self._cityName,country: self._country,currentTemp: self._currentTemp,maxTemp: self._maxTemp,minTemp: self._minTemp,weather:
                            self._weather,date: self._date,iconCode: self._iconCode)
                        
                        self.dailyReport.append(report)
                        self.index += 9
                    }
                    
                    //Pass daily report object from here as download and appending data is completed
                    self.event.trigger("downloadComplete", information: self.dailyReport)
                }
            }
        }
    }
    
    func timeFormatter(date:String)->String {
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let dateString = dayTimePeriodFormatter.dateFromString(date)
        _ = NSCalendar.currentCalendar()
        // let day = calendar.components([.Day , .Month , .Year], fromDate: dateString!)
        
        dayTimePeriodFormatter.setLocalizedDateFormatFromTemplate("EEEE")
        let dayName = dayTimePeriodFormatter.stringFromDate(dateString!)
        return dayName
        
    }
}

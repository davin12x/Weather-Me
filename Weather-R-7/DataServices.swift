        //
        //  DataServices.swift
        //  Weather-R-7
        //
        //  Created by Lalit on 2016-08-30.
        //  Copyright © 2016 Bagga. All rights reserved.
        //
        
        import Foundation
        import Alamofire
        import SwiftEventBus
        
        
        class DataServices {
            fileprivate var _cityName:String!
            fileprivate var _country:String!
            fileprivate var _currentTemp:Double!
            fileprivate var _maxTemp:Double!
            fileprivate var _minTemp:Double!
            fileprivate var _weather:String!
            fileprivate var _date :String!
            fileprivate var _iconCode:String!
            fileprivate var todayWeather = true
            var dailyReport = [DailyWeatherReport]()
            var currentWeatherReport:DailyWeatherReport!
            var URL:String!
            
            
            
            //function will call get and start fetching weather data
            func downloadWeatherDetail(){
                
                URL = BASE_URL+Current_Coordinate+URL_UNITS+APP_KEY
                Alamofire.request(URL).responseJSON { response in
                    if let dict = response.result.value as? Dictionary<String,AnyObject> {
                        
                        
                        if let main = dict["main"] as?Dictionary<String,AnyObject> {
                            if let currentTemp = main["temp"] as? Double {
                                self._currentTemp = currentTemp
                                print(self._currentTemp)
                            }
                        }
                        
                        if let weather = dict["weather"] as? [Dictionary<String,AnyObject>] {
                            if let icon = weather[0]["icon"] as? String {
                                self._iconCode = icon
                            }
                            
                            if let weatherType = weather[0]["main"] as?String {
                                self._weather = weatherType
                            }
                        }
                        
                        if let cityName = dict["name"] as? String {
                            self._cityName = cityName
                        }
                        
                        let report = DailyWeatherReport(city: self._cityName, currentTemp: self._currentTemp, weather: self._weather, iconCode: self._iconCode)
                        
                        SwiftEventBus.post("onCurrentWeatherFetched", sender:report)
                    }
                    
                }
            }
            
            func downloadForeCast(completed:@escaping DownloadComplete) {
                dailyReport.removeAll()
                URL = BASE_URL+ForeCast_CORRDINATES+URL_UNITS+APP_KEY
                Alamofire.request(URL).responseJSON { response in
                    if let dict = response.result.value as? Dictionary<String,AnyObject> {
                        //list
                        if let list = dict["list"] as? [Dictionary<String,AnyObject>], list.count > 0 {
                            
                            for index in 0...list.count-1 {
                                
                                if let weather = list[index]["weather"] as? [Dictionary<String,AnyObject>] {
                                    if let icon = weather[0]["icon"] as? String {
                                        self._iconCode = icon
                                    }
                                    
                                    if let weatherType = weather[0]["main"] as?String {
                                        self._weather = weatherType
                                        print(weatherType)
                                    }
                                }
                                
                                if let main = list[index]["temp"] as?Dictionary<String,AnyObject> {
                                    if let min_temp = main["min"] as? Double {
                                        self._minTemp = min_temp
                                    }
                                    if let max_temp = main["max"] as? Double {
                                        self._maxTemp = max_temp
                                    }
                                }
                                let report = DailyWeatherReport(maxTemp: self._maxTemp, minTemp: self._minTemp, weather: self._weather, date: getNewDate(i: index), iconCode: self._iconCode)
                                self.dailyReport.append(report)
                            }
                            
                        }
                        
                        completed()
                    }
                    
                }
                
            }
            
        }
        
        func getNewDate(i:Int) -> String {
            let date = Date()
            let interval = TimeInterval(60 * 60 * 24 * (i+1))
            let newDate = date.addingTimeInterval(interval)
            let dayTimePeriodFormatter = DateFormatter()
            dayTimePeriodFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
            dayTimePeriodFormatter.setLocalizedDateFormatFromTemplate("EEEE")
            let dayName = dayTimePeriodFormatter.string(from: newDate)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM"
            let month = dateFormatter.string(from: newDate)
            
            dateFormatter.dateFormat = "dd"
            let _currentDate = dateFormatter.string(from: newDate)
            
            return dayName+","+month+" \(_currentDate)"
        }
        
        
        
        func timeFormatter(_ date:String)->String {
            let dayTimePeriodFormatter = DateFormatter()
            dayTimePeriodFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
            let dateString = dayTimePeriodFormatter.date(from: date)
            _ = Calendar.current
            // let day = calendar.components([.Day , .Month , .Year], fromDate: dateString!)
            
            dayTimePeriodFormatter.setLocalizedDateFormatFromTemplate("EEEE")
            let dayName = dayTimePeriodFormatter.string(from: dateString!)
            return dayName
            
        }
        

//
//  ViewController.swift
//  Weather-R-7
//
//  Created by Lalit on 2016-08-29.
//  Copyright © 2016 Bagga. All rights reserved.
//

import UIKit
import MapKit
import JHSpinner
import SwiftEventBus

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate {
    var service:DataServices!
    var dailyReport = [DailyWeatherReport]()
    
    @IBOutlet weak var miniIconView: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var normalIconView: UIImageView!
    @IBOutlet weak var weatherType: UILabel!
    @IBOutlet weak var minTemp: UILabel!
    @IBOutlet weak var cityCountry: UILabel!
    var dailyReportCell = DailyWeatherReportCell()
    let locationManager = CLLocationManager()
    var spinner:JHSpinnerView! = nil
    var foreCastReport:[DailyWeatherReport] = []
    var oneTime = true;
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        
        spinner =  JHSpinnerView.showOnView(view, spinnerColor:UIColor.red, overlay:.custom(CGSize(width: 300, height: 200), 20), overlayColor:UIColor.black.withAlphaComponent(0.6), fullCycleTime:4.0, text:"Loading")
    
    }

    
    override func viewDidAppear(_ animated: Bool) {
        locationAuthStatus()
    }
    
    //Method will be trigged as soon downloads Compeletd(Weather Reprt)
    func updateForecastView(report: [DailyWeatherReport])  {
        foreCastReport = report
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foreCastReport.count-1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableCell",for: indexPath) as? DailyWeatherReportCell
        
    
            let report = foreCastReport[indexPath.row]
            _ = dailyReportCell.configureCell(report,cell: cell!)
            return cell!
        }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = (locations[0] as? CLLocation)!
        
        
        let _long = userLocation.coordinate.longitude
        let _lat = userLocation.coordinate.latitude
        
        lon = _long
        lat = _lat
        
        if oneTime {
            self.service = DataServices()
            self.service.downloadWeatherDetail()
            
            SwiftEventBus.onMainThread(self, name: "onCurrentWeatherFetched") { result in
                let result : DailyWeatherReport = result.object as! DailyWeatherReport
                
                //Update Screen
                self.service.downloadForeCast(completed:{
                    self.updateUI(report: result)
                    self.updateForecastView(report: self.service.dailyReport)
                 
                })
                
            }
            oneTime = false
        }
        
        locationManager.stopUpdatingLocation()
    
    }
    
    
    
    //Main UI Will Be udpated Here
    func updateUI(report:DailyWeatherReport) {
        self.date.text = currentDate()
        let _currTemp = round(report.currentTemp)
        currentTemp.text = "\(_currTemp.cleanValue)"
        weatherType.text = report.weather
        cityCountry.text = "\(report.cityName)"
        normalIconView.image = UIImage(named: report.iconCode)
        spinner.dismiss()
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            // user press yes
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func currentDate() -> String {
        let date = Date()
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        dayTimePeriodFormatter.setLocalizedDateFormatFromTemplate("EEEE")
        let dayName = dayTimePeriodFormatter.string(from: date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        let month = dateFormatter.string(from: date)
        
        dateFormatter.dateFormat = "dd"
        let _currentDate = dateFormatter.string(from: date)
        
        return dayName+","+month+" \(_currentDate)"
    }
    
}

//Extension will remove zero digit
extension Double {
    var cleanValue: String {
        var rr = self.truncatingRemainder(dividingBy: 1) == 0 ?String(format: "%.0f", self): String(self)
        rr += "°"
        return rr
    }
}





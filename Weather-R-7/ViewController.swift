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
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        
      
        spinner =  JHSpinnerView.showOnView(view, spinnerColor:UIColor.redColor(), overlay:.Custom(CGSize(width: 300, height: 200), 20), overlayColor:UIColor.blackColor().colorWithAlphaComponent(0.6), fullCycleTime:4.0, text:"Loading")
   
    }
    
    override func viewDidAppear(animated: Bool) {
        locationAuthStatus()
    }
    
    //Method will be trigged as soon downloads Compeletd(Weather Reprt)
    func downloadCompleted(information:Any?)  {
        if let report = information as? [DailyWeatherReport] {
            self.dailyReport = report
            
            updateUI()
            
        }
        tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyReport.count - 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomTableCell",forIndexPath: indexPath) as? DailyWeatherReportCell
            
            let index = indexPath.row + 1
            if index < dailyReport.count {
                let report = dailyReport[index]
                _ = dailyReportCell.configureCell(report,cell: cell!)
                return cell!
            } else {
                return UITableViewCell()
        }
    }
    

    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = (locations[0] as? CLLocation)!
        
    
        let _long = userLocation.coordinate.longitude
        let _lat = userLocation.coordinate.latitude
        
        lon = _long
        lat = _lat
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: _lat, longitude: _long)
        geoCoder.reverseGeocodeLocation(location) {  (placemarks, error) -> Void in
            let placeArray = placemarks as [CLPlacemark]!
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placeArray?[0]
            
            // Address dictionary
         ///   print(placeMark.addressDictionary)
            
            // City
            if let _city = placeMark.addressDictionary?["City"] as? String{
                city = _city
            }
            
            if let _country = placeMark.addressDictionary?["Country"] as? String {
                country = _country.capitalizedString
                
                //Start downlaod the data as screen loads
                self.service = DataServices()
                self.service.event.listenTo("downloadComplete", action: self.downloadCompleted);
            }
        }
        
        locationManager.stopUpdatingLocation()
        
    }
    
    func updateUI() {
        self.date.text = currentDate()
        let report = dailyReport[0]
        let _currTemp = round(report.currentTemp)
        currentTemp.text = "\(_currTemp.cleanValue)"
        weatherType.text = report.weather
        minTemp.text = "\(report.minTemp.cleanValue)"
        cityCountry.text = "\(report.cityName),\(report.country)"
        normalIconView.image = UIImage(named: report.iconCode)
        spinner.dismiss()
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedAlways {
            // user press yes
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func currentDate() -> String {
        let date = NSDate()
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        dayTimePeriodFormatter.setLocalizedDateFormatFromTemplate("EEEE")
        let dayName = dayTimePeriodFormatter.stringFromDate(date)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM"
        let month = dateFormatter.stringFromDate(date)
        
        dateFormatter.dateFormat = "dd"
        let _currentDate = dateFormatter.stringFromDate(date)
        
        return dayName+","+month+" \(_currentDate)"
    }
    
}

//Extension will remove zero digit
extension Double {
    var cleanValue: String {
        var rr = self % 1 == 0 ?String(format: "%.0f", self): String(self)
        rr += "°"
        return rr
    }
}





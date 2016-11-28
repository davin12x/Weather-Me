//
//  DailyWeatherReportCell.swift
//  Weather-R-7
//
//  Created by Lalit on 2016-08-31.
//  Copyright © 2016 Bagga. All rights reserved.
//

import UIKit

class DailyWeatherReportCell: UITableViewCell {
    var report:[DailyWeatherReport]!
    @IBOutlet weak var tableMiniIcon: UIImageView!
    @IBOutlet weak var tableDay: UILabel!
    @IBOutlet weak var tableWeatherType: UILabel!
    @IBOutlet weak var tableMax: UILabel!
    @IBOutlet weak var tableMin: UILabel!
    @IBOutlet weak var weatherIcon :UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ report:DailyWeatherReport,cell:DailyWeatherReportCell)  {
        cell.tableMax!.text = "\(report.maxTemp.cleanValue)"
        cell.tableMin.text = "\(report.minTemp.cleanValue)"
        cell.tableWeatherType.text = "\(report.weather)"
        cell.tableDay.text = report.date
        cell.weatherIcon.image = UIImage(named: report.iconCode)
    }

}

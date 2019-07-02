//
//  TableViewCell.swift
//  OpenWeatherMapApp
//
//  Created by Ruslan Fatkhulov on 01/07/2019.
//  Copyright © 2019 Ruslan Fatkhulov. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempPlusWindLabel: UILabel!
    
    func configureCell(cell: TableViewCell, json: JSONCurrentWeatherModel) {
        let t = "\(lround((json.main.temp)))˚C"
        let windSpeed = "\(lround((json.wind.speed)))m/s"
        let windDeg = json.wind.deg
        var windDirection: String {
            switch windDeg ?? 361 {
            case 22.6...67.5:
                return "NE"
            case 67.6...112.5:
                return "E"
            case 112.6...157.5:
                return "SE"
            case 157.6...202.5:
                return "S"
            case 202.6...247.5:
                return "SW"
            case 247.6...292.5:
                return "W"
            case 292.6...337.5:
                return "NW"
            case 337.6...360:
                return "N"
            case 0...22.5:
                return "N"
            default:
                return ""
            }
        }
        DispatchQueue.main.async {
            cell.cityLabel.text = json.name
            cell.tempPlusWindLabel.text = t + " " + windSpeed + " " + windDirection
        }
    }
}

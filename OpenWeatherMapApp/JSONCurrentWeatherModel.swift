//
//  JSONCurrentWeatherModel.swift
//  OpenWeatherMapApp
//
//  Created by Ruslan Fatkhulov on 01/07/2019.
//  Copyright © 2019 Ruslan Fatkhulov. All rights reserved.
//

import Foundation

struct JSONCurrentWeatherModel: Decodable {
    let main: Main
    let wind: Wind
    let name: String
    let dt: Int
}

struct Main: Decodable {
    let temp: Double
}

struct Wind: Decodable {
    let speed: Double
    let deg: Double?
}

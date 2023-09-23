//
//  WeatherData.swift
//  Clima
//
//  Created by CARLOS HERNANDEZ TAPIA on 21/09/23.
//  Copyright © 2023 CARLOS HERNANDEZ TAPIA. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
    let description: String
}

//
//  WeatherData.swift
//  Clima
//
//  Created by Frederick Javalera on 4/21/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
  let name: String
  let main: Main
  let weather: [Weather]
}

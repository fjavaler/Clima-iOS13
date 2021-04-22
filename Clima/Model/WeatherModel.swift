//
//  WeatherModel.swift
//  Clima
//
//  Created by Fred Javalera on 4/21/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel: Decodable {
  let conditionId: Int
  let cityName: String
  let temperature: Double
  
  var temperatureString: String {
    return String(format: "%.1f", temperature)
  }
  
  var conditionName: String {
    switch conditionId {
    case 200...202:
      return "cloud.bolt.rain"
    case 210...221:
      return "cloud.bolt"
    case 231...232:
      return "cloud.bolt.rain"
    case 300...321:
      return "cloud.drizzle"
    case 500...501:
      return "cloud.rain"
    case 502...511:
      return "cloud.heavyrain"
    case 520...521:
      return "cloud.rain"
    case 522...531:
      return "cloud.heavyrain"
    case 600...601:
      return "cloud.snow"
    case 602:
      return "snow"
    case 611...613:
      return "cloud.sleet"
    case 615...621:
      return "cloud.snow"
    case 622:
      return "snow"
    case 701:
      return "cloud.fog"
    case 711:
      return "smoke"
    case 721...762:
      return "cloud.fog"
    case 771...781:
      return "tornado"
    case 800...803:
      return "cloud.sun"
    case 804:
      return "cloud"
    default:
      return "sun.max"
    }
  }
}

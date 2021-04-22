//
//  WeatherManager.swift
//  Clima
//
//  Created by Fred Javalera on 4/20/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
  func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
  func didFailWithError(error: Error)
}

struct WeatherManager {
  
  // MARK: - Properties
  
  let weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=imperial"
  
  var delegate: WeatherManagerDelegate?
  
  // Computed property for API Key.
  private var apiKey: String {
    get {
      // Get filePath of hidden .plist file.
      guard let filePath = Bundle.main.path(forResource: "Clima-Info", ofType: "plist") else {
        fatalError("Couldn't find file 'Clima-Info.plist'.")
      }
      
      // Store contents of file in a variable as an dictionary.
      let plist = NSDictionary(contentsOfFile: filePath)
      
      // Retrieve value associated with key in dictionary and store.
      guard let value = plist?.object(forKey: "API_KEY") as? String else {
        fatalError("Couldn't find key 'API_KEY' in 'Clima-Info.plist'.")
      }
      
      // return the value.
      return value
    }
  }
  
  // MARK: - Methods
  
  func fetchWeather(cityName: String) {
    let urlString = "\(weatherURL)&q=\(cityName)&appid=\(apiKey)"
    performRequest(with: urlString)
  }
  
  func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
    let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)"
    performRequest(with: urlString)
  }
  
  func performRequest(with urlString: String) {
    // 1. Create a URL
    if let url = URL(string: urlString) {
      // 2. Create a URLSession
      let session = URLSession(configuration: .default)
      
      // 3. Give a session a task
//       Method 1: Long form passing a method and not using a trailing closure. Uses "handle" method below.
//       let task = session.dataTask(with: url, completionHandler: handle(data:response:error:))
      
      // Method 2 (Best practice): Using trailing closure instead.
      let task = session.dataTask(with: url) { (data, response, error) in
        
        // Everything from inside of the handler method moved inside of this trailing closure below.
        
        // Check for errors
        if error != nil {
          delegate?.didFailWithError(error: error!)
          return
        }
        
        // Check for nil response data and parse JSON to Swift object
        if let safeData = data {
          if let weather = parseJSON(safeData) {
            delegate?.didUpdateWeather(self, weather: weather)
          }
        }
      }
      
      // 4. Start the task
      task.resume()
    }
  }
  
  // Handler helper method called in performRequest()
//  func handle(data: Data?, response: URLResponse?, error: Error?) {
//
//    // Check for errors
//    if error != nil {
//      print(error!)
//      return
//    }
//
//    // Check for nil data
//    if let safeData = data {
//      let dataString = String(data: safeData, encoding: .utf8)
//      print(dataString!)
//    }
//  }
  
  // MARK: - Helper methods
  
  // Convert JSON to a WeatherModel
  func parseJSON(_ weatherData: Data) -> WeatherModel? {
    let decoder = JSONDecoder()
    do {
      let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
      
      if decodedData.weather.last != nil {
        let id = decodedData.weather[0].id
        let temp = decodedData.main.temp
        let name = decodedData.name
        
        let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
        return weather
        } else {
        // No 0th weather item found in weather section (array) of response.
        return nil
      }
    } catch {
      delegate?.didFailWithError(error: error)
      return nil
    }
  }
}

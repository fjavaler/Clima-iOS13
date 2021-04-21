//
//  WeatherManager.swift
//  Clima
//
//  Created by Fred Javalera on 4/20/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
  
  // MARK: - Properties
  
  let weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=imperial"
  
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
    performRequest(urlString: urlString)
  }
  
  func performRequest(urlString: String) {
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
          print(error!)
          return
        }
        
        // Check for nil response data and parse JSON to Swift object
        if let safeData = data {
          parseJSON(weatherData: safeData)
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
  
  func parseJSON(weatherData: Data) {
    let decoder = JSONDecoder()
    do {
      let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
      
      if decodedData.weather.last != nil {
        print(decodedData.weather.last!.description)
      }
    } catch {
      print(error)
    }
  }
}

//
//  WeatherManager.swift
//  Clima
//
//  Created by Fred Javalera on 4/20/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
  
  let weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=imperial"
  
  private var apiKey: String {
    get {
      // 1
      guard let filePath = Bundle.main.path(forResource: "Clima-Info", ofType: "plist") else {
        fatalError("Couldn't find file 'Clima-Info.plist'.")
      }
      
      // 2
      let plist = NSDictionary(contentsOfFile: filePath)
      
      guard let value = plist?.object(forKey: "API_KEY") as? String else {
        fatalError("Couldn't find key 'API_KEY' in 'Clima-Info.plist'.")
      }
      
      return value
    }
  }
  
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
      let task = session.dataTask(with: url, completionHandler: handle(data:response:error:))
      
      // 4. Start the task
      task.resume()
    }
  }
  
  // Handler helper method called in performRequest()
  func handle(data: Data?, response: URLResponse?, error: Error?) {
    if error != nil {
      print(error!)
      return
    }
    
    if let safeData = data {
      let dataString = String(data: safeData, encoding: .utf8)
      print(dataString!)
    }
  }
}

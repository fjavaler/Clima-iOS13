//
//  WeatherManager.swift
//  Clima
//
//  Created by Fred Javalera on 4/20/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
  let weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=imperial&appid=a4eb88d1c836c3cd6524b2857cff52e1"
  
  func fetchWeather(cityName: String) {
    let urlString = "\(weatherURL)&q=\(cityName)"
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
      print(dataString)
    }
  }
}

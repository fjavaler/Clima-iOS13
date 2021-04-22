//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UITextFieldDelegate, WeatherManagerDelegate {
  
  // MARK: - IBOutlets
  
  @IBOutlet weak var conditionImageView: UIImageView!
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var searchTextField: UITextField!
  
  var weatherManager = WeatherManager()
  
  // MARK: - Lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    weatherManager.delegate = self
    searchTextField.delegate = self
  }
  
  // MARK: - IBActions
  
  // Fired when search button is pressed.
  @IBAction func searchPressed(_ sender: UIButton) {
    searchTextField.endEditing(true)
    print(searchTextField.text!)
  }
  
  // MARK: - TextField state methods
  
  // Fired when Go button pressed on keyboard. Alternative to pressing the search button.
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    searchTextField.endEditing(true)
    print(searchTextField.text!)
    return true
  }
  
  // Executed implicitely on textFieldShouldReturn() and textFieldDidEndEditing() methods after user done editing in text field. Contains validation logic.
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    if textField.text != "" {
      return true
    } else {
      textField.placeholder = "Type something"
      return false
    }
  }
  
  // Clears the text field after a search is performed. Gets the weather for city searched for (from API call).
  func textFieldDidEndEditing(_ textField: UITextField) {
    // User searchTextField.text to get the weather for that city.
    if let city = searchTextField.text {
      weatherManager.fetchWeather(cityName: city)
    }
    searchTextField.text = ""
  }
  
  func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
    temperatureLabel.text = weather.temperatureString
  }
  
  func didFailWithError(error: Error) {
    print(error)
  }
}

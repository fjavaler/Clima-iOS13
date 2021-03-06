//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
  @IBOutlet weak var conditionImageView: UIImageView!
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet weak var searchTextField: UITextField!
  
  var weatherManager = WeatherManager()
  let locationManager = CLLocationManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    locationManager.delegate = self
    weatherManager.delegate = self
    searchTextField.delegate = self
    
    locationManager.requestWhenInUseAuthorization()
    locationManager.requestLocation()
  }
  
  @IBAction func locationPressed(_ sender: UIButton) {
    locationManager.requestLocation()
  }
}

// MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
  // Fired when search button is pressed.
  @IBAction func searchPressed(_ sender: UIButton) {
    searchTextField.endEditing(true)
    print(searchTextField.text!)
  }
  
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
    // Uses searchTextField.text to get the weather for that city.
    if let city = searchTextField.text {
      weatherManager.fetchWeather(cityName: city)
    }
    searchTextField.text = ""
  }
}

// MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
  func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
    DispatchQueue.main.async {
      self.temperatureLabel.text = weather.temperatureString
      self.conditionImageView.image = UIImage(systemName: weather.conditionName)
      self.cityLabel.text = weather.cityName
    }
  }
  
  func didFailWithError(error: Error) {
    print(error)
  }
}

// MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last {
      locationManager.stopUpdatingLocation()
      let lat = location.coordinate.latitude
      let lon = location.coordinate.longitude
      weatherManager.fetchWeather(latitude: lat, longitude: lon)
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
  }
}

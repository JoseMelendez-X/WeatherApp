//
//  ViewController.swift
//  WeatherApp
//
//  Created by Jose Melendez on 9/27/17.
//  Copyright © 2017 JoseMelendez. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class ViewController: UIViewController {
    
    //Weather URL
    let weatherURL = "http://api.wunderground.com/api/50f2f81e6b034d18/conditions/q/MI/Redford.json"
    
   
  
    var weatherDataModel = WeatherDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        fetchWeatherConditions(url: weatherURL)
  
        
    }
    
    //MARK: - IB-Outlets
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var currentWeatherLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel:UILabel!
    @IBOutlet weak var currentHumidityLabel: UILabel!
    @IBOutlet weak var currentWindSpeedLabel: UILabel!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    @IBOutlet weak var currentWeatherImage:UIImageView!
    
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var city: UITextField!
    


//MARK: - Textfield Search Actions
/***************************************************************************************/
    @IBAction func searchButtonTapped(_ sender: Any) {
        
        SVProgressHUD.show()
        
        view.endEditing(true)
        
        if let cityText = city.text, let stateText = state.text {
        
        fetchWeatherConditions(url: "http://api.wunderground.com/api/50f2f81e6b034d18/conditions/q/\(stateText)/\(cityText.replacingOccurrences(of: " ", with: "%20")).json")
        
        }
    }
    



//MARK: - Networking
/***************************************************************************************/

    //Fetch Data
    func fetchWeatherConditions(url: String) {
        
        Alamofire.request(url).responseJSON { (response) in
            
            if response.result.isSuccess {
                
                //The weatherJSON constant will contain all of our weather condition information
                let weatherJSON: JSON = JSON(response.result.value!)
                
                print("\(weatherJSON)")
                
                self.updateWeatherDataModel(json: weatherJSON)
                
            } else {
                
                //Handle errors here
                print(response.result.error!)
                
            }
        }
        
        
    }
    

//MARK: - JSON Parsing
/***************************************************************************************/
    
    //Update WeatherDataModel
    func updateWeatherDataModel (json: JSON) {
        
        weatherDataModel.cityName = json["current_observation"]["display_location"]["full"].stringValue
        
        weatherDataModel.weather = json["current_observation"]["weather"].stringValue
        
        weatherDataModel.humidity = json["current_observation"]["relative_humidity"].stringValue
        
        weatherDataModel.lastUpdated = json["current_observation"]["observation_time"].stringValue
        
        weatherDataModel.state = json["current_observation"]["observation_location"]["state"].stringValue
        
        weatherDataModel.temperature = json["current_observation"]["temp_f"].stringValue
        
        weatherDataModel.windspeed = json["current_observation"]["wind_mph"].stringValue
    
        
        
        //Set the weatherIcon property to the image given to us by the JSON Object (weatherJSON)
        if let url = URL(string: json["current_observation"]["icon_url"].stringValue) {
            
            print(url)
            //Convert image to data
            if let data = try? Data(contentsOf: url) {
                
                //If image is converted into data then assign it to the weatherIcon property
                weatherDataModel.weatherIcon = UIImage(data: data)
                
                SVProgressHUD.dismiss()
                
            } else {
                
                print(LocalizedError.self)
        }
        
    }
    
        updateUI()
}
    //MARK: - UpdateUI
    /************************************************************************************/
    
    func updateUI() {
        
        cityLabel.text = "\(weatherDataModel.cityName)"
        
        currentWeatherLabel.text = "Weather: \(weatherDataModel.weather)"
        
        currentTemperatureLabel.text = "Temperature: \(weatherDataModel.temperature)℉"
        
        currentHumidityLabel.text = "Humidity: \(weatherDataModel.humidity)"
        
        currentWindSpeedLabel.text = "Windspeed: \(weatherDataModel.windspeed) mph"
        
        currentWeatherImage.image = weatherDataModel.weatherIcon
        
        lastUpdatedLabel.text = weatherDataModel.lastUpdated
        
        if cityLabel.text == "" {
            
            cityLabel.text = "city not found"
            
            SVProgressHUD.dismiss()
        }
    }


}


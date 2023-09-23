//
//  WeatherManager.swift
//  Clima
//
//  Created by CARLOS HERNANDEZ TAPIA on 11/08/23.
//  Copyright CARLOS HERNANDEZ TAPIA. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager:WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
    
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=46617d3f1816501f319ccf267ba26b0d&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitute: CLLocationDegrees) {
        let URLString = "\(weatherURL)&lat=\(latitude)&lon=\(longitute)"
        performRequest(with: URLString)
    }
    
    func performRequest(with urlString: String) {
        //        1.Create a URL
        
        if let url = URL(string: urlString) {
            
            
            
            //        2.Create a URlSession
            let session = URLSession(configuration: .default)
            
            //        3.Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            //        4.Start the task
            task.resume()
            
        }
        
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name =  decodedData.name
            
            let weather = WeatherModel (conditionId: id, cityName: name, temperature: temp)
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    

    
}


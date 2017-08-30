//
//  OpenWeatherMapClient.swift
//  OpenWeather
//
//  Created by Christopher Rene on 8/29/17.
//  Copyright © 2017 Fauna. All rights reserved.
//

import Foundation
import CoreLocation

class OpenWeatherMapClient {
    
    // Method to make proper API calls.
    fileprivate let apiKey = "c6e381d8c7ff98f0fee43775817cf6ad"
    fileprivate let baseURL = "http://api.openweathermap.org/data/2.5/weather?"
    
    func getCurrentWeather(for location: CLLocationCoordinate2D, completion: @escaping(NetworkResponse) -> ()) {
        
        let urlString = baseURL + "lat=\(location.latitude)&lon=\(location.longitude)&appid=\(apiKey)&units=metric"
        
        // Make sure url is valid before making request
        guard let url = URL(string: urlString) else { return }
        
        let request = URLRequest(url: url)
        let session: URLSession = .shared
        
        // Initiate task and parse JSON
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    completion(.successful(json))
                } catch {
                    completion(.error(error))
                }
                
            } else if let error = error {
                completion(.error(error))
            }
        }
    
        dataTask.resume()
    }
}

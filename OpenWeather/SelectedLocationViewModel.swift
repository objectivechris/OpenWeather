//
//  SelectedLocationViewModel.swift
//  OpenWeather
//
//  Created by Christopher Rene on 8/30/17.
//  Copyright © 2017 Fauna. All rights reserved.
//

import Foundation

struct SelectedLocationViewModel {
    
    var city: String
    var temperature: String
    var humidity: String
    var latitude: Double
    var longitude: Double
    var rain: String
    var wind: String
    
    init(model: SelectedLocation) {
        
        self.city = model.city
        
        let roundedTemperature = Int(model.temperature)
        self.temperature = "\(roundedTemperature)º"
        
        let humidityPercentValue = Int(model.humidity)
        self.humidity = "\(humidityPercentValue)%"
        
        self.latitude = model.latitude
        self.longitude = model.longitude
        
        let roundedRain = "\(Int(model.rain ?? 0))%"
        self.rain = roundedRain
        
        let roundedWind = "\(Int(model.wind * 2.23694))MPH"
        self.wind = roundedWind
    }
}

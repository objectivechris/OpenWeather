//
//  SelectedLocation.swift
//  OpenWeather
//
//  Created by Christopher Rene on 8/29/17.
//  Copyright © 2017 Fauna. All rights reserved.
//

import Foundation

struct SelectedLocation {
    
    var city = ""
    var temperature = 0.0
    var humidity = 0.0
    var latitude = 0.0
    var longitude = 0.0
    var rain: Double?
    var wind = 0.0
    
    init(city: String, temperature: Double, humidity: Double, rain: Double?, wind: Double, latitude: Double, longitude: Double) {
        self.city = city
        self.temperature = temperature
        self.humidity = humidity
        self.rain = rain
        self.wind = wind
        self.latitude = latitude
        self.longitude = longitude
    }
}

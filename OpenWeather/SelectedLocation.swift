//
//  SelectedLocation.swift
//  OpenWeather
//
//  Created by Christopher Rene on 8/29/17.
//  Copyright © 2017 Fauna. All rights reserved.
//

import Foundation

class SelectedLocation: NSObject, NSCoding {
    
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
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(city, forKey: "city")
        aCoder.encode(temperature, forKey: "temperature")
        aCoder.encode(humidity, forKey: "humidity")
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(longitude, forKey: "longitude")
        aCoder.encode(rain, forKey: "rain")
        aCoder.encode(wind, forKey: "wind")
    }
    
    required init?(coder aDecoder: NSCoder) {
        city = aDecoder.decodeObject(forKey: "city") as! String
        temperature = aDecoder.decodeDouble(forKey: "temperature")
        humidity = aDecoder.decodeDouble(forKey: "humidity")
        latitude = aDecoder.decodeDouble(forKey: "latitude")
        longitude = aDecoder.decodeDouble(forKey: "longitude")
        rain = aDecoder.decodeObject(forKey: "rain") as? Double
        wind = aDecoder.decodeDouble(forKey: "wind")
        
        super.init()
    }
}

class LocationPersistence {
    
    var bookmarks = [SelectedLocation]()
    
    static let shared = LocationPersistence()
    
    let weatherArchiveURL: URL = {
        var documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentDirectory.appendingPathComponent("bookmarks.archive")
    }()
    
    init() {
        if let archivedItems = NSKeyedUnarchiver.unarchiveObject(withFile: weatherArchiveURL.path) as? [SelectedLocation] {
            bookmarks += archivedItems
        }
    }
    
    func saveChanges() -> Bool {
        return NSKeyedArchiver.archiveRootObject(bookmarks, toFile: weatherArchiveURL.path)
    }
    
    func removeBookmark(at index: IndexPath) {
        bookmarks.remove(at: index.row)
        _ = saveChanges()
    }
}

//
//  PinLocationViewController.swift
//  OpenWeather
//
//  Created by Christopher Rene on 8/29/17.
//  Copyright © 2017 Fauna. All rights reserved.
//

import UIKit
import MapKit

protocol PinLocationViewControllerDelegate: class {
    func didSelectLocation(_ location: SelectedLocation)
}

class PinLocationViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var labelBackground: UIView!
    @IBOutlet weak var buttonBackground: UIView!
    
    weak var delegate: PinLocationViewControllerDelegate?
    
    var currentLocation = CLLocation(latitude: 0, longitude: 0)
    let persistence = LocationPersistence.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show user location in sepcified region
        let region = MKCoordinateRegion(center: currentLocation.coordinate, latitudinalMeters: CLLocationDistance(500), longitudinalMeters: CLLocationDistance(500))
        mapView.showsUserLocation = true
        mapView.setRegion(region, animated: true)
        
        let holdTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(selectLocation))
        holdTapGesture.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(holdTapGesture)
        
        labelBackground.addDropShadow()
        buttonBackground.addDropShadow()
    }
    
    @objc func selectLocation(gesture: UILongPressGestureRecognizer) {
        
        if gesture.state == .began {
            
            let touchLocation = gesture.location(in: mapView)
            let touchPoint = mapView.convert(touchLocation, toCoordinateFrom: self.view)
            
            // Begin network request
            OpenWeatherMapClient().getCurrentWeather(for: touchPoint, completion: { (status) in
                
                typealias JSONDictionary = [String: Any]
                
                switch status {
                    
                case let .successful(data):
                    
                    guard let dict = data as? JSONDictionary else { return }
                
                    let city = dict["name"] as! String
                    let latitude = (dict["coord"] as? JSONDictionary)?["lat"] as! Double
                    let longitude = (dict["coord"] as? JSONDictionary)?["lon"] as! Double
                    let temperature = (dict["main"] as? JSONDictionary)?["temp"] as! Double
                    let humidity = (dict["main"] as? JSONDictionary)?["humidity"] as! Double
                    let rain = (dict["rain"] as? JSONDictionary)?["3h"] as? Double
                    let wind = (dict["wind"] as? JSONDictionary)?["speed"] as! Double
                    
                    // Create location object from parsed JSON data
                    let selectedLocation = SelectedLocation(city: city, temperature: temperature, humidity: humidity, rain: rain, wind: wind, latitude: latitude, longitude: longitude)
                    
                    // Create and drop pin where user touched
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = touchPoint
                    
                    // Confirm pin annotation & alert delegate
                    let alert = UIAlertController(title: "Add Location", message: "Do you want to add this location as a bookmark?", preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
                    let okay = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                        self.persistence.bookmarks.append(selectedLocation)
                        self.delegate?.didSelectLocation(selectedLocation)
                        self.mapView.addAnnotation(annotation)
                        
                        let later = DispatchTime.now() + 1
                        DispatchQueue.main.asyncAfter(deadline: later) {
                            // delay dismissal after pin drops
                            self.dismiss(animated: true, completion: nil)
                        }
                    })
                    
                    alert.addAction(cancel)
                    alert.addAction(okay)
                    
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                case let .error(error):
                    let alert = UIAlertController(title: "Uh Oh", message: "Something bad happened - \(error)", preferredStyle: .alert)
                    let okay = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(okay)
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
    }

    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

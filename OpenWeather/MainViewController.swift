//
//  MainViewController.swift
//  OpenWeather
//
//  Created by Christopher Rene on 8/29/17.
//  Copyright © 2017 Fauna. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {

    // Outlets
    @IBOutlet weak var currentCityLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var currentDescriptionLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var selectedLocations = [SelectedLocation]()
    var currentLocation: CLLocation!
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "EEEE h:mm a"
        return df
    }()
    
    let locationManager = CLLocationManager()
    let authStatus = CLLocationManager.authorizationStatus()
    let persistence = LocationPersistence.shared
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        getUserLocation()
        selectedLocations = persistence.bookmarks
        
    }
    
    func startLocationManager() {
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func showErrorMessage() {
        let alert = UIAlertController(title: "Uh Oh", message: "Seems like we can't get your location. Please allow access in Settings or try again later.", preferredStyle: .alert)
        let okay = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okay)
        self.present(alert, animated: true, completion: nil)
    }
    
    func getUserLocation() {
        
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        if authStatus == .denied || authStatus == .restricted {
            showErrorMessage()
        }
        
        startLocationManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let date = Date()
        let currentDate = dateFormatter.string(from: date)
        currentTimeLabel.text = currentDate
    }
    
    @IBAction func addLocation(_ sender: UIButton) {
        
        if authStatus == .denied || authStatus == .restricted {
            showErrorMessage()
        } else {
          performSegue(withIdentifier: "pinLocation", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "pinLocation" {
            let pinLocationVC = segue.destination as! PinLocationViewController
            pinLocationVC.currentLocation = currentLocation
            pinLocationVC.delegate = self
        }
        
        if segue.identifier == "showCity" {
            let selectedCityVC = segue.destination as! SelectedCityViewController
            selectedCityVC.selectedLocation = selectedLocations[sender as! Int]
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell") as! WeatherCell
        let viewModel = SelectedLocationViewModel(model: selectedLocations[indexPath.row])
        cell.displayWeather(using: viewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showCity", sender: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            selectedLocations.remove(at: indexPath.row)
            persistence.removeBookmark(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = manager.location!
        currentLocation = location
        
        OpenWeatherMapClient().getCurrentWeather(for: location.coordinate) { (status) in
            switch status {
            case let .successful(data):
                guard let dict = data as? [String: Any] else { return }
                let city = dict["name"] as! String
                let temperature = (dict["main"] as? [String: Any])?["temp"] as! Double
                let descriptionDict = dict["weather"] as? [[String: Any]]
                let description = descriptionDict?[0]
                let descriptionText = description?["description"] as! String

                DispatchQueue.main.async {
                    self.currentCityLabel.text = city
                    self.currentTemperatureLabel.text = "\(Int(temperature))º"
                    self.currentDescriptionLabel.text = descriptionText.capitalized
                }
                
            case .error(_):
                self.showErrorMessage()
                manager.stopUpdatingLocation()
            }
        }
    }
}

extension MainViewController: PinLocationViewControllerDelegate {
    func didSelectLocation(_ location: SelectedLocation) {
        selectedLocations.append(location)
        tableView.reloadData()
        _ = persistence.saveChanges()
    }
}

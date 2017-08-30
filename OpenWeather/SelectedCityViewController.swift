//
//  SelectedCityViewController.swift
//  OpenWeather
//
//  Created by Christopher Rene on 8/29/17.
//  Copyright © 2017 Fauna. All rights reserved.
//

import UIKit

class SelectedCityViewController: UIViewController {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var rainLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    
    var selectedLocation: SelectedLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let viewModel = SelectedLocationViewModel(model: selectedLocation!)
        displayWeather(using: viewModel)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func displayWeather(using viewModel: SelectedLocationViewModel) {
        cityLabel.text = viewModel.city
        temperatureLabel.text = viewModel.temperature
        humidityLabel.text = viewModel.humidity
        rainLabel.text = viewModel.rain
        windLabel.text = viewModel.wind
    }
}

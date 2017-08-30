//
//  Extensions.swift
//  OpenWeather
//
//  Created by Christopher Rene on 8/30/17.
//  Copyright © 2017 Fauna. All rights reserved.
//

import UIKit

extension UIView {
    
    func addDropShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 4
    }
}

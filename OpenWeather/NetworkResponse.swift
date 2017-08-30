//
//  NetworkResponse.swift
//  OpenWeather
//
//  Created by Christopher Rene on 8/30/17.
//  Copyright © 2017 Fauna. All rights reserved.
//

import Foundation

enum NetworkResponse {
    case successful(Any)
    case error(Error)
}

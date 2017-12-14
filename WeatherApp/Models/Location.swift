//
//  Location.swift
//  WeatherApp
//
//  Created by Varun Rathi on 13/12/17.
//  Copyright © 2017 vrat28. All rights reserved.
//

import CoreLocation

class Location {
    static var sharedInstance = Location()
    private init() {}
    
    var latitude: Double = 28.5355
    var longitude: Double = 77.3910
    var city:String?
}

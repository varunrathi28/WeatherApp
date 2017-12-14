//
//  Constants.swift
//  WeatherApp
//
//  Created by Varun Rathi on 12/12/17.
//  Copyright © 2017 vrat28. All rights reserved.
//

import UIKit
import CoreLocation

let BASE_URL = "http://api.openweathermap.org/data/2.5/weather?"
let LATITUDE = "lat="
let LONGITUDE = "&lon="
let APP_ID = "&appid="
let API_KEY = "42a1771a0b787bf12e734ada0cfc80cb"

typealias DownloadComplete = () -> ()

let CURRENT_WEATHER_URL:String = "http://api.openweathermap.org/data/2.5/weather?lat=\(Location.sharedInstance.latitude)&lon=\(Location.sharedInstance.longitude)&appid=\(API_KEY)"

let FORECAST_URL:String = "http://api.openweathermap.org/data/2.5/forecast?lat=%@&lon=%@&mode=json&appid=\(API_KEY)"

let WEATHER_IMG_BASE_URL:String = "https://openweathermap.org/img/w/"


struct LocationConstant {
    static let defaultLocation:CLLocation = CLLocation(latitude: 28.5355, longitude: 77.3910)
    
    static let zoomLevel:Double = 17.0
    
}

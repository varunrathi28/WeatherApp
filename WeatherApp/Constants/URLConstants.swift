
//
//  URLConstats.swift
//  WeatherApp
//
//  Created by Varun Rathi on 12/12/17.
//  Copyright © 2017 vrat28. All rights reserved.
//

import UIKit
import CoreLocation

struct URLManager {

    func getUrlForCoordinate(coordinate: CLLocationCoordinate2D) ->String
    {
       
        
        let url =  String(format: FORECAST_URL,String(coordinate.latitude),String(coordinate.longitude))
        return url
    }
}

//
//  Place.swift
//  WeatherApp
//
//  Created by Varun Rathi on 13/12/17.
//  Copyright © 2017 vrat28. All rights reserved.
//

import UIKit
class  Weather{
    
    static var sharedInstance = Weather()
    
    private init() {}
    
    var isFarenheit:Bool = true
    
    static let weatherDic = ["Clouds" : "cloud",
                             "Rain": "rain",
                             "Clear" : "clear"]
    
    
    static func getImageFor(condtion:String) ->String
    {
        return weatherDic[condtion]!
    }
}



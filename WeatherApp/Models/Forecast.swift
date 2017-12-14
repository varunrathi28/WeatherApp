//
//  Forecast.swift
//  WeatherApp
//
//  Created by Varun Rathi on 12/12/17.
//  Copyright © 2017 vrat28. All rights reserved.
//

import UIKit
import Alamofire

class Forecast {
    
    var _date: String!
    var _weatherType: String!
    var _temp: String!
    var _icon:String!
    var _humidity:String!
    var _pressure:String!
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        return _date
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var temp: String {
        if _temp == nil {
            _temp = ""
        }
        
        return _temp
    }
    
    var icon:String {
        
        if _icon == nil {
            _icon = ""
        }
        return _icon
    }
    
    var pressure: String {
        
        if _pressure == nil {
            _pressure = ""
        }
        return _pressure
    }
    
    var humidity: String {
        
        if _humidity == nil {
            _humidity = ""
        }
        return _humidity
    }
    
    var tempCelsius : String {
        
        get {
            
            let farenheit = Double(temp)
            let celsius = 5/9 * (farenheit! - 32)
            return String(format:"%.1f", celsius)
        }
    }
    
    
    
    init(weatherDict: Dictionary<String, AnyObject>) {
        
        
        if let mainDic = weatherDict["main"] as? Dictionary<String, Any> {
            
            if let temp = mainDic["temp"] as? Double {
                
                let kelvinToFarenheitPreDivision = (temp * (9/5) - 459.67)
                let kelvinToFarenheit = Double(round(10 * kelvinToFarenheitPreDivision/10))
                
                self._temp = String(kelvinToFarenheit)
            }
            
            if let humidity = mainDic["humidity"] as? Double {
                
                self._humidity = String(humidity)
            }
            
            if let pressure = mainDic["pressure"] as? Double {
                self._pressure = String(pressure)
            }
            
        }
        
        if let weather = weatherDict["weather"] as? [Dictionary<String, AnyObject>] {
            
            if let main = weather[0]["main"] as? String {
                self._weatherType = main
            }
            
            if let icon = weather[0]["icon"] as? String {
                self._icon = icon
            }
        }
        
        if let date = weatherDict["dt"] as? Double {
            
            let unixConvertedDate = Date(timeIntervalSince1970: date)
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .full
            dateFormatter.dateFormat = "EEEE"
            dateFormatter.timeStyle = .none
            self._date = unixConvertedDate.dayOfTheWeek()
        }
        
    }
}

extension Date {
    func dayOfTheWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}

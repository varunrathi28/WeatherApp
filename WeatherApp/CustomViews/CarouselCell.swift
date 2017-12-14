//
//  CarouselCell.swift
//  WeatherApp
//
//  Created by Varun Rathi on 13/12/17.
//  Copyright © 2017 vrat28. All rights reserved.
//

import UIKit
import ScalingCarousel
import Kingfisher


class CarouselCell: ScalingCarouselCell {
    
    @IBOutlet weak var tempLabel:UILabel!
    @IBOutlet weak var condLabel:UILabel!
    @IBOutlet weak var condImage:UIImageView!
    @IBOutlet weak var backgroundImage:UIImageView!
    
    @IBOutlet weak var dateLabel:UILabel!
    @IBOutlet weak var pressureLbl:UILabel!
    @IBOutlet weak var humidityLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        mainView.layer.cornerRadius = AppTheme.CAROUSEL_CELL_CORNER_RADIUS
        mainView.clipsToBounds = true
        mainView.backgroundColor = AppTheme.CAROUSEL_BACKGROUND_COLOR
    }
    
    func updateData(with forecast:Forecast)
    {
        tempLabel.text = getTemperatureText(forecast: forecast)
        condLabel.text = forecast.weatherType
        let url = URL(string: getImageUrl(with: forecast))
        
        condImage.kf.setImage(with: url!)
        pressureLbl.text = forecast.pressure
        humidityLabel.text = forecast.humidity + "%"
        dateLabel.text = forecast.date
        let imageName = Weather.getImageFor(condtion: forecast.weatherType)
          backgroundImage.image = UIImage(named: imageName)
    }
    
    func getTemperatureText(forecast:Forecast) -> String
    {
        if Weather.sharedInstance.isFarenheit == true {
            
            return forecast.temp + "°F"
        }
        else {
           return forecast.tempCelsius + "°C"
        }
    }
    
    
    func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: .dark)
        // 2
        let blurView = UIVisualEffectView(effect: blurEffect)
        // 3
        
        blurView.translatesAutoresizingMaskIntoConstraints = false
       
        backgroundImage.addSubview(blurView)
    
       // addConstraint(NSLayoutConstraint(item: blurView, attribute: .height, relatedBy: .equal, toItem: mainView, attribute: .height, multiplier: 1.0, constant: 0).)
      
    }
    
    private func getImageUrl(with forecast:Forecast) -> String {
        
        return WEATHER_IMG_BASE_URL + forecast.icon + ".png"
    }
}

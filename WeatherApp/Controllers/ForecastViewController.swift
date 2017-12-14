//
//  ForecastViewController.swift
//  WeatherApp
//
//  Created by Varun Rathi on 13/12/17.
//  Copyright © 2017 vrat28. All rights reserved.
//

import UIKit
import ScalingCarousel
import CoreLocation
import Alamofire
import SJFluidSegmentedControl

class ForecastViewController: UIViewController {
    
    var weatherManager =  WeatherManager()
    var currentLocation:CLLocation!
    
    @IBOutlet weak var  carouselView:ScalingCarouselView!
    @IBOutlet weak var containerView:UIView!
    @IBOutlet weak var cityNameLbl:UILabel!
    @IBOutlet weak var cordinateLbl:UILabel!
    @IBOutlet weak var backgroundImage:UIImageView!
    var arrDatasource:[Forecast] = []
    
    
    @IBOutlet weak var segmentedControl:SJFluidSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        carouselView.backgroundColor = UIColor.clear
        
        let barButton = UIBarButtonItem(title:"Back", style: .done, target: self, action: #selector(backPressed))
      
        navigationItem.leftBarButtonItem = barButton
        
       // addBlurView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchWeather()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backPressed()
    {
        navigationController?.popViewController(animated: true)
    }
    
    func fetchWeather()
    {
        downloadForecastData {
            self.updateUI()
            self.carouselView.reloadData()
            
        }
    }
    
   func  updateUI(){
        cityNameLbl.text = Location.sharedInstance.city
        cordinateLbl.text = getCoordinateFormat(location:currentLocation)
        setColorsForWheather(forecast: arrDatasource[0])
    }
    
    func getCoordinateFormat(location:CLLocation) -> String {
        
        let latitute = String(format: "%.3f",location.coordinate.latitude)
        let longitude =  String(format: "%.3f", location.coordinate.longitude)
        return "( \(latitute) , \(longitude) )"
    }
    
    func addBlurView()
    {
        let blurEffect = UIBlurEffect(style:.light)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = carouselView.frame
        carouselView.addSubview(blurredEffectView)
        
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.frame = backgroundImage.bounds
      //  backgroundImage.addSubview(vibrancyEffectView)
    }
    
    
    func downloadForecastData(completed: @escaping DownloadComplete) {
        //Downloading forecast weather data for TableView
        
        let urlManager = URLManager()
        let url = urlManager.getUrlForCoordinate(coordinate: currentLocation.coordinate)
        Alamofire.request(url).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                    
                    for obj in list {
                        let forecast = Forecast(weatherDict: obj)
                        self.arrDatasource.append(forecast)
                        print(obj)
                    }
                 //   self.arrDatasource.remove(at: 0)
                  
                }
            }
            completed()
        }
    }
    
    func setColorsForWheather(forecast:Forecast)
    {
        switch forecast.weatherType {
        case "Clouds":
            backgroundImage.image = UIImage(named:"back_cloud")
            
        case "Rain":
            backgroundImage.image = UIImage(named:"back_rain")
            
        case "Extreme":
            backgroundImage.image = UIImage(named:"back_extreme")
            
        case "Snow":
            backgroundImage.image = UIImage(named:"back_snow")
            
        default:
            backgroundImage.image = UIImage(named:"back_clear")
        }
    }
}

extension ForecastViewController : UICollectionViewDataSource {
 
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrDatasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.CarouselCell, for: indexPath) as! CarouselCell
        
        let forecast = arrDatasource[indexPath.item]
        
        cell.updateData(with: forecast)
        
        return cell
    }
    
}

extension ForecastViewController:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        carouselView.didScroll()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        let currentPage = Int(ceil(x/w))
        
        let forecast = arrDatasource[currentPage]
        setColorsForWheather(forecast: forecast)
        
        // Do whatever with currentPage.
    }
}

extension ForecastViewController:SJFluidSegmentedControlDataSource {
    
    func numberOfSegmentsInSegmentedControl(_ segmentedControl: SJFluidSegmentedControl) -> Int {
        return 2
    }
    
    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl, titleForSegmentAtIndex index: Int) -> String? {
        
        return index == 0 ? "Farenheit" :"Celsius"
    }
    
    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl,
                          gradientColorsForSelectedSegmentAtIndex index: Int) -> [UIColor] {
        switch index {
        case 0:
            return [UIColor(red: 51 / 255.0, green: 149 / 255.0, blue: 182 / 255.0, alpha: 1.0),
                    UIColor(red: 97 / 255.0, green: 199 / 255.0, blue: 234 / 255.0, alpha: 1.0)]
        case 1:
            return [UIColor(red: 227 / 255.0, green: 206 / 255.0, blue: 160 / 255.0, alpha: 1.0),
                    UIColor(red: 225 / 255.0, green: 195 / 255.0, blue: 128 / 255.0, alpha: 1.0)]
       
        default:
            break
        }
        return [.clear]
    }
    
    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl,
                          gradientColorsForBounce bounce: SJFluidSegmentedControlBounce) -> [UIColor] {
        switch bounce {
        case .left:
            return [UIColor(red: 51 / 255.0, green: 149 / 255.0, blue: 182 / 255.0, alpha: 1.0)]
        case .right:
            return [UIColor(red: 9 / 255.0, green: 82 / 255.0, blue: 107 / 255.0, alpha: 1.0)]
        }
    }
}

extension ForecastViewController: SJFluidSegmentedControlDelegate {
    
    func segmentedControl(_ segmentedControl: SJFluidSegmentedControl,
                          didChangeFromSegmentAtIndex fromIndex: Int,
                          toSegmentAtIndex toIndex:Int)
    {
        if toIndex == 0 {
            
           Weather.sharedInstance.isFarenheit = true
        }
        else {
            Weather.sharedInstance.isFarenheit = false
        }
        
        carouselView.reloadData()
        
    }
}



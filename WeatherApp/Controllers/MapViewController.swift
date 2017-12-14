//
//  ViewController.swift
//  WeatherApp
//
//  Created by Varun Rathi on 12/12/17.
//  Copyright © 2017 vrat28. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView:MKMapView!
    var locationManager:CLLocationManager = CLLocationManager()
    var currentLocation:CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocationManager()
        requestAuthorization()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.delegate = self
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        mapView.delegate = nil
    }
    
    func requestAuthorization()
    {
        if CLLocationManager.authorizationStatus() == .notDetermined {
            
            locationManager.requestAlwaysAuthorization()
        }
            
        else if CLLocationManager.authorizationStatus() == .denied {
            addDefaultAnnotation()
        }
        else  if CLLocationManager.authorizationStatus() == .authorizedAlways {
            
            locationManager.startUpdatingLocation()
        }
        
    }
    

    func setUpLocationManager()
    {
        locationManager.delegate = self
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        
        mapView.delegate = self
        mapView.showsUserLocation = false
        mapView.userTrackingMode = .follow
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func addDefaultAnnotation()
    {
        let annotation = MKPointAnnotation()
        
        let defaultCoord = LocationConstant.defaultLocation.coordinate
        annotation.coordinate = defaultCoord
        mapView.addAnnotation(annotation)
        
    }
    
    func addCustomAnnotation(coordinate:CLLocationCoordinate2D)
    {
        let  pointAnnotation = CustomPointAnnotation()
        pointAnnotation.pinCustomImageName = "pin"
        pointAnnotation.coordinate = coordinate
        pointAnnotation.title = "Current Location"
        pointAnnotation.subtitle = "Get Forecast"
        
        let  pinAnnotationView:MKPinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: "pin")
        mapView.addAnnotation(pinAnnotationView.annotation!)
    }
    
    @objc func calloutPressed()
    {
        
    }
    
    func pushToForecastScreen()
    {
        let storyboard = UIStoryboard(name:"Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier:StoryboardID.Forecast) as! ForecastViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func fetchCity(with location:CLLocation)
    {
        // ReverseGeocode city name from coordinate
        
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            
            if error == nil {
                
                if let placemark = placemarks?.first {
                    // City Name
                    let cityName = placemark.subAdministrativeArea
                    
                    Location.sharedInstance.city = cityName
                    geoCoder.cancelGeocode()
                }
            }
        }
        
        
    }

}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "User")
            
            if annotationView == nil {
                
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
                annotationView?.canShowCallout = true
                annotationView?.isDraggable = true
            }
            else {
                
                annotationView?.annotation = annotation
            }
            
            annotationView?.image = UIImage(named:"pin")
            return annotationView
        }
        
        return MKAnnotationView()
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        
        if newState == .ending {
           
            if  let newCoord = view.annotation?.coordinate {
                
               currentLocation =  CLLocation(latitude:newCoord.latitude, longitude: newCoord.longitude)
                fetchCity(with: currentLocation!)
            }
            
        }
    }
    
    
    
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
    
        pushToForecastScreen()
        
    }
}

extension MapViewController:CLLocationManagerDelegate  {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        if let userLocation = locations.last{
            
            
            currentLocation = userLocation
            let coordinate = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            var region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpanMake(0.25,0.25))
            
            
            fetchCity(with: userLocation)
           
            // Set annotation on the Map View
        //    mapView.setRegion(region, animated: true)
            mapView.setCenterCoordinate(centerCoordinate: coordinate, zoomLevel: LocationConstant.zoomLevel, animated: true)
            
            locationManager.stopUpdatingLocation()
            addCustomAnnotation(coordinate: coordinate)
           
        }
    }
}

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

}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "User")
            
            if annotationView == nil {
                
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
                annotationView?.canShowCallout = true
            }
            else {
                
                annotationView?.annotation = annotation
            }
            
            annotationView?.image = UIImage(named:"pin")
            annotationView?.isDraggable = true
            return annotationView
        }
        
        return MKAnnotationView()
    }
    
}

extension MapViewController:CLLocationManagerDelegate  {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
    let userLocation = locations.last as! CLLocation
    let coordinate = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
     var region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpanMake(1.0, 1.0))
    
        mapView.setRegion(region, animated: true)
        let annonation = MKPointAnnotation()
        annonation.coordinate = coordinate
        mapView.addAnnotation(annonation)
        
    }
}

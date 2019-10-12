//
//  SuggestLocationViewController.swift
//  WhereToEat
//
//  Created by Ahmad Ragab on 10/10/19.
//  Copyright © 2019 Ahmad Ragab. All rights reserved.
//

import UIKit
import MapKit

class SuggestLocationViewController : UIViewController {

    // MARK: - Outlets -
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Local Variable -
    var suggestLocationPresenter: SuggestLocationPresenterProtocol?
    var suggestedLocation: SuggestLocationEntity?
    let locationManager = CLLocationManager()
    var userLatitude: Double = 0.0
    var userLongitude: Double = 0.0
    var isCenteredForTheFirstTime = false
    
    // MARK: Functions: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationServices()
    }
    
    // MARK: Functions: - Locals
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthorization()
        } else {
            Utilities.showAlertForView(self, title: "Error", message: "Access to your location is needed")
        }
    }
    
    func checkLocationAuthorization() {
        
        switch CLLocationManager.authorizationStatus() {
            
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.delegate = self
//                mapView.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
                mapView.showsUserLocation = true
            break
            
            case .denied:
                Utilities.showAlertForView(self, title: "Error", message: "Access to your location is needed")
            break
            
            case .restricted:
                Utilities.showAlertForView(self, title: "Error", message: "Access to your location is needed")
            break
            
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                locationManager.delegate = self
//                mapView.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
                mapView.showsUserLocation = true
            break
            
            default:
            break
        }
    }
    
    func centerMapOnLocation(latitude: String, longitude: String) {
        if let doubleLatitude = Double(latitude), let DoubleLongitude = Double(longitude) {
            let location = CLLocationCoordinate2D(latitude: doubleLatitude, longitude: DoubleLongitude)
            let coordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: 2000, longitudinalMeters: 2000)
            mapView.setRegion(coordinateRegion, animated: true)
        } else {
            // TODO: Show error
        }
    }
    
    func showLocationOnMap(latitude: String, longitude: String) {
        if let doubleLatitude = Double(latitude), let DoubleLongitude = Double(longitude) {
            mapView.removeAnnotations(mapView.annotations)
            let annotations = MKPointAnnotation()
            annotations.coordinate = CLLocationCoordinate2D(latitude: doubleLatitude, longitude: DoubleLongitude)
            mapView.addAnnotation(annotations)
            
            let location1 = MKPointAnnotation()
            location1.coordinate.latitude = userLatitude
            location1.coordinate.longitude = userLongitude
            fitAll(location1: location1, location2: annotations)
        } else {
            // TODO: Show error
        }
    }
    
    func fitAll(location1: MKAnnotation, location2: MKAnnotation) {
        var zoomRect: MKMapRect = MKMapRect.null

        let annotations = [location1, location2]
        
        for annotation in annotations {
            let aPoint = MKMapPoint(annotation.coordinate)
            let rect = MKMapRect(x: aPoint.x, y: aPoint.y, width: 0.1, height: 0.1)

            if zoomRect.isNull {
                zoomRect = rect
            } else {
                zoomRect = zoomRect.union(rect)
            }
        }
        
        mapView.setVisibleMapRect(zoomRect, edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100), animated: true)
    }
    
    // MARK: Functions: - Outlets -
    @IBAction func suggetLocationButtonPressed(_ sender: Any) {
        suggestLocationPresenter?.getRandomLoctationWith(longitude: "\(userLatitude)", andLatitude: "\(userLongitude)")
    }
}

// MARK: Extension - VIPER Protocols -
extension SuggestLocationViewController : SuggestLocationViewProtocol {
    func setRandomLocationModel(_ model: SuggestLocationEntity) {
        suggestedLocation = model
        showLocationOnMap(latitude: model.lat ?? "", longitude: model.lon ?? "")
    }
    
    func showError(_ error: String) {
    }
    
    func showProgress(_ show: Bool) {
    }
}

// MARK: Extension - Location Delegate -
extension SuggestLocationViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        if !isCenteredForTheFirstTime {
            centerMapOnLocation(latitude: "\(location.latitude)", longitude: "\(location.longitude)")
            isCenteredForTheFirstTime = true
        }
        
        userLatitude = location.latitude
        userLongitude = location.longitude
    }
}

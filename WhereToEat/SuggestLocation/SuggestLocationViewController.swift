//
//  SuggestLocationViewController.swift
//  WhereToEat
//
//  Created by Ahmad Ragab on 10/10/19.
//  Copyright © 2019 Ahmad Ragab. All rights reserved.
//

import UIKit
import MapKit
import Lottie
import SnapKit

class SuggestLocationViewController : UIViewController {

    // MARK: - Outlets -
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var blurryView: UIView!
    @IBOutlet weak var onBoardingView: UIView!
    @IBOutlet weak var appImageView: UIImageView!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var suggestButton: UIButton!
    
    @IBOutlet weak var detailsViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var onBoardingViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var onBoardingViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var blurryViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var blurryViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var appImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var appImageWidthConstraint: NSLayoutConstraint!
    
    
    // MARK: - Local Variable -
    var suggestLocationPresenter: SuggestLocationPresenterProtocol?
    var suggestedLocation: SuggestLocationEntity?
    let locationManager = CLLocationManager()
    var userLatitude: Double = 0.0
    var userLongitude: Double = 0.0
    var isCenteredForTheFirstTime = false
    var lotAnimationView: LOTAnimationView?
    
    // MARK: Functions: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
        checkLocationServices()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: Functions: - Locals
    func initUI() {
        suggestButton.layer.cornerRadius = 20
        detailsViewHeightConstraint.constant = 0
        
        onBoardingView.translatesAutoresizingMaskIntoConstraints = false
        blurryView.translatesAutoresizingMaskIntoConstraints = false
        
        lotAnimationView = LOTAnimationView(name: "ColoredDotsWaveLoading")
    }
    
    func showLottieAnimation(_ show: Bool) {
        if let animationView = lotAnimationView {
            if show {
                animationView.contentMode = .scaleAspectFit
                suggestButton.addSubview(animationView)
                
                animationView.snp.makeConstraints { (make) in
                    make.centerY.equalTo(suggestButton.snp.centerY)
                    make.top.bottom.leading.trailing.equalToSuperview()
                }
                
                animationView.loopAnimation = true
                animationView.animationSpeed = 0.5
                animationView.play()
                
                animationView.isHidden = false
                suggestButton.setTitle("", for: .normal)
            } else {
                animationView.isHidden = true
                suggestButton.setTitle("Suggest", for: .normal)
            }
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthorization()
        } else {
            Utilities.showAlertForView(self, title: ERROR, message: ACCESS_DENIED)
        }
    }
    
    func checkLocationAuthorization() {
        
        switch CLLocationManager.authorizationStatus() {
            
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
                mapView.showsUserLocation = true
            break
            
            case .denied:
                Utilities.showAlertForView(self, title: ERROR, message: ACCESS_DENIED)
            break
            
            case .restricted:
                Utilities.showAlertForView(self, title: ERROR, message: ACCESS_DENIED)
            break
            
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                locationManager.delegate = self
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
            Utilities.showAlertForView(self, withError: "Unknown location\nLatitude: \(latitude)\nLongitude: \(longitude)")
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
            Utilities.showAlertForView(self, withError: "Unknown location\nLatitude: \(latitude)\nLongitude: \(longitude)")
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
    
    func startAnimatingViews(_ direction: AnimationDirection) {
        
        if direction == .animateIn {
            detailsView.isHidden = false
            detailsViewHeightConstraint.constant = 200
            
            blurryViewBottomConstraint.isActive = false
            onBoardingViewBottomConstraint.isActive = false
            
            UIView.animate(withDuration: 1.0) { [weak self] in
                self?.blurryViewHeightConstraint.constant = 90
                self?.onBoardingViewHeightConstraint.constant = 90
                self?.view.layoutIfNeeded()
            }
        } else {
            detailsView.isHidden = true
            detailsViewHeightConstraint.constant = 0
            
            blurryViewBottomConstraint.isActive = true
            onBoardingViewBottomConstraint.isActive = true
            
            UIView.animate(withDuration: 1.0) { [weak self] in
                self?.blurryViewHeightConstraint.constant = UIScreen.main.bounds.height
                self?.onBoardingViewHeightConstraint.constant = UIScreen.main.bounds.height
                self?.view.layoutIfNeeded()
            }
        }
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
        //showLocationOnMap(latitude: model.lat ?? "", longitude: model.lon ?? "")
        detailsLabel.text = model.name
        startAnimatingViews(.animateIn)
        showLocationOnMap(latitude: "29.954873", longitude: "30.927861")
    }
    
    func showError(_ error: String) {
        Utilities.showAlertForView(self, withError: error)
    }
    
    func showProgress(_ show: Bool) {
        showLottieAnimation(show)
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

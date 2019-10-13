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
    @IBOutlet weak var detailsLabelTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var onBoardingViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var onBoardingViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var blurryViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var blurryViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var appImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var appImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var appImageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var appImageBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var appImageCenterConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var appNameLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var appNameBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var appNameCenterConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var suggestButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var suggestButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var suggestButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var suggestButtonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var suggestButtonTrailingConstraint: NSLayoutConstraint!
    
    // MARK: - Local Variable -
    var suggestLocationPresenter: SuggestLocationPresenterProtocol?
    var suggestedLocation: SuggestLocationEntity?
    let locationManager = CLLocationManager()
    var userLatitude: Double = 0.0
    var userLongitude: Double = 0.0
    var isCenteredForTheFirstTime = false
    var lotAnimationView: LOTAnimationView?
    var direction: AnimationDirection = .animateOut
    
    var onBoardingBottom: NSLayoutConstraint?
    
    var blurryBottom: NSLayoutConstraint?
    
    var imageTop: NSLayoutConstraint?
    var imageCenter: NSLayoutConstraint?
    var imageBottom: NSLayoutConstraint?
    
    var titleTop: NSLayoutConstraint?
    var titleCenter: NSLayoutConstraint?
    var titleBottom: NSLayoutConstraint?
    
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
        appNameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.restorAppState)))
        appImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.restorAppState)))
        
        suggestButton.layer.cornerRadius = 20
        detailsViewHeightConstraint.constant = 0
        
        onBoardingView.translatesAutoresizingMaskIntoConstraints = false
        blurryView.translatesAutoresizingMaskIntoConstraints = false
        
        onBoardingBottom = onBoardingViewBottomConstraint
        
        blurryBottom = blurryViewBottomConstraint
        
        imageTop = appImageTopConstraint
        imageCenter = appImageCenterConstraint
        imageBottom = appImageBottomConstraint
        
        titleTop = appNameLabelTopConstraint
        titleCenter = appNameCenterConstraint
        titleBottom = appNameBottomConstraint
        
        titleTop?.isActive = false
        appNameLabelTopConstraint = titleTop
        
        imageTop?.isActive = false
        appImageTopConstraint = imageTop
        
        lotAnimationView = LOTAnimationView(name: "ColoredDotsWaveLoading")
    }
    
    @objc
    func restorAppState() {
        direction = .animateOut
        startAnimating()
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
                animationView.animationSpeed = 1.0
                animationView.play()
                
                animationView.isHidden = false
                suggestButton.setAttributedTitle(nil, for: .normal)
                suggestButton.setTitle("", for: .normal)
            } else {
                animationView.isHidden = true
                suggestButton.setAttributedTitle(prepSuggestButtonAttributedTitle(), for: .normal)
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
    
    func startAnimating() {
        
        animateViews()
        animateButton()
        animateImage()
        animateTitle()
        
        UIView.animate(withDuration: ANIMATION_TIME) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    func animateViews() {
        detailsView.isHidden = direction == .animateIn ? false : true
        detailsViewHeightConstraint.constant = direction == .animateIn ? 200 : 0
        
        onBoardingBottom?.isActive = direction == .animateIn ? false : true
        onBoardingViewBottomConstraint = onBoardingBottom
        onBoardingView.isUserInteractionEnabled = direction == .animateIn ? true : false
        appNameLabel.isUserInteractionEnabled = direction == .animateIn ? true : false
        appImageView.isUserInteractionEnabled = direction == .animateIn ? true : false
        
        blurryBottom?.isActive = direction == .animateIn ? false : true
        blurryViewBottomConstraint = blurryBottom
        
        let viewHeight: CGFloat = Utilities.isWithNotsh() ? 100 : 80
        blurryViewHeightConstraint.constant = direction == .animateIn ? viewHeight : UIScreen.main.bounds.height
        onBoardingViewHeightConstraint.constant = direction == .animateIn ? viewHeight : UIScreen.main.bounds.height
        
        detailsLabelTopConstraint.constant = viewHeight + 15
    }
    
    func animateButton() {
        suggestButtonHeightConstraint.constant = direction == .animateIn ? 40 : 60
        suggestButtonWidthConstraint.constant = direction == .animateIn ? 200 : 314
        suggestButtonBottomConstraint.constant = direction == .animateIn ? 50 : 100
        suggestButtonLeadingConstraint.constant = direction == .animateIn ? 107 : 50
        suggestButtonTrailingConstraint.constant = direction == .animateIn ? 107 : 50
        
        suggestButton.setAttributedTitle(prepSuggestButtonAttributedTitle(), for: .normal)
    }
    
    func prepSuggestButtonAttributedTitle() -> NSAttributedString {
        
        let fontSize: CGFloat = direction == .animateIn ? 20 : 30
        let fontColor = direction == .animateIn ? UIColor.white : UIColor(red: 29/255, green: 115/255, blue: 209/255, alpha: 1)
        let backgroundColor = direction == .animateIn ? UIColor(red: 29/255, green: 115/255, blue: 209/255, alpha: 1) : UIColor.white
        
        suggestButton.backgroundColor = backgroundColor
        
        let font: [NSAttributedString.Key : Any]? = [NSAttributedString.Key.font: UIFont(name: "ChalkboardSE-Regular", size: fontSize)!,
                                                     NSAttributedString.Key.foregroundColor: fontColor]
        let attrText = NSMutableAttributedString(string: "Suggest", attributes: font)
        let mutableAttributedString = NSMutableAttributedString()
        
        mutableAttributedString.append(attrText)
        
        return mutableAttributedString
    }
    
    func prepSuggestedPlaceName(_ name: String) -> NSAttributedString {
        let font: [NSAttributedString.Key : Any]? = [NSAttributedString.Key.font: UIFont(name: "ChalkboardSE-Regular", size: 18)!,
                                                     NSAttributedString.Key.foregroundColor: UIColor(red: 29/255, green: 115/255, blue: 209/255, alpha: 1)]
        let attrText = NSMutableAttributedString(string: name, attributes: font)
        let mutableAttributedString = NSMutableAttributedString()
        
        mutableAttributedString.append(attrText)
        
        return mutableAttributedString
    }
    
    func animateImage() {
        
        imageTop?.isActive = direction == .animateIn ? true : false
        if direction == .animateIn {
            imageTop?.constant = 0
        }
        appImageTopConstraint = imageTop
        
        imageBottom?.isActive = direction == .animateIn ? false : true
        appImageBottomConstraint = imageBottom
        
        appImageHeightConstraint.constant = direction == .animateIn ? 50 : 200
        appImageWidthConstraint.constant = direction == .animateIn ? 50 : 200
        
        let screenWidth = UIScreen.main.bounds.width
        let imagePositionFromCenter: CGFloat = (screenWidth / 4) - 15
        
        appImageCenterConstraint.constant = direction == .animateIn ? imageCenter!.constant - imagePositionFromCenter : imageCenter!.constant + imagePositionFromCenter
    }
    
    func animateTitle() {
        
        titleTop?.isActive = direction == .animateIn ? true : false
        if direction == .animateIn {
            titleTop?.constant = 10
        }
        appNameLabelTopConstraint = titleTop
        
        titleBottom?.isActive = direction == .animateIn ? false : true
        appNameBottomConstraint = titleBottom
        
        let screenWidth = UIScreen.main.bounds.width
        let titlePositionFromCenter: CGFloat = (screenWidth / 8) - 15
        
        appNameCenterConstraint.constant = direction == .animateIn ? titleCenter!.constant + titlePositionFromCenter : titleCenter!.constant - titlePositionFromCenter
        
        let fontSize: CGFloat = direction == .animateIn ? 24 : 34
        appNameLabel.font = UIFont(name: "ChalkboardSE-Regular", size: fontSize)
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
        
        detailsLabel.attributedText = prepSuggestedPlaceName(model.name ?? "")
        
        if direction == .animateOut {
            direction = .animateIn
            startAnimating()
        }
        
        showLocationOnMap(latitude: model.lat ?? "", longitude: model.lon ?? "")
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

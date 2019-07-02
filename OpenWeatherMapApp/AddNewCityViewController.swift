//
//  AddNewCityViewController.swift
//  OpenWeatherMapApp
//
//  Created by Ruslan Fatkhulov on 01/07/2019.
//  Copyright © 2019 Ruslan Fatkhulov. All rights reserved.
//

import UIKit
import CoreLocation


class AddNewCityViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    var currentCity: String?
    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var addCityButton: UIButton!
    @IBOutlet weak var currentLocationCity: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkLocationServices()
        
        currentLocationCity.isEnabled = false
        addCityButton.isEnabled = false
        cityTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    private func showAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
}


//MARK: - CLLocationManagerDelegate
extension AddNewCityViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last! as CLLocation
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(userLocation, completionHandler: { (placemarks, error) -> Void in
            if let city = placemarks?[0].locality {
                self.currentCity = city
            }
        })
    }
    
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            checkLocationAuthorization()
        } else {
            self.showAlert(
                title: "Location Services are Disabled",
                message: "To enable it go: Settings -> Privacy -> Location Services and turn On"
            )
        }
    }
    
    private func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            currentLocationCity.isEnabled = true
            break
        case .denied:
            self.showAlert(
                title: "Your Location is not Available",
                message: "To enable your location tracking: Setting -> OpenWeatherMapApp -> Location"
            )
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            break
        @unknown default:
            print("new unknown case in checkLocationAuthorization()")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

//MARK: - UITextFieldDelegate
extension AddNewCityViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldChanged() {
        if cityTextField.text?.isEmpty == false {
            addCityButton.isEnabled = true
        } else {
            addCityButton.isEnabled = false
        }
    }
}

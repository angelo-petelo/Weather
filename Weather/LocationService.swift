//
//  LocationService.swift
//  Weather
//
//  Created by Nicholas Angelo Petelo on 5/19/21.
//

import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {

    private let locationManager: CLLocationManager = CLLocationManager()
    private let geocoder: CLGeocoder = CLGeocoder()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    public func getLocation(completion: @escaping (String, CLLocation) -> Void) {
        locationManager.startUpdatingLocation()
        guard let location = locationManager.location else { return }
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemarks = placemarks, let placemark = placemarks.first, let cityName = placemark.locality {
                completion(cityName, location)
            }
        }
        locationManager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Restricted Location Authorization")
        case .denied:
            print("Denied Location Authorization")
        case .authorizedAlways, .authorizedWhenInUse:
            print("Authorized Location")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "locationAuthorized"), object: nil)
        @unknown default:
            print("Unknown default Location Authorization")
        }
    }
    
    deinit {
        print("location service deinit")
    }
}

//
//  LocationManager.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 11/13/21.
//

import CoreLocation

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    static let shared = LocationManager()
    @Published var userLocation: CLLocation?
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {

        
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    }
        
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.userLocation = location
        locationManager.stopUpdatingLocation()
    }
}

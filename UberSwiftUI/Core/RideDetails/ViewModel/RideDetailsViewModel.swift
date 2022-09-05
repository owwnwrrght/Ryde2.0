//
//  RideDetailsViewModel.swift
//  UberSwiftUI
//
//  Created by Stephan Dowless on 8/31/22.
//

import Foundation
import MapKit
import Firebase
import SwiftUI

class RideDetailsViewModel: ObservableObject {
        
    private let userLocation: CLLocation
    private let dropOffLocation: UberLocation
    
    var startLocationString: String
    var endLocationString: String
    
    @Published var pickupTime: String?
    @Published var dropOffTime: String?
    
    let distanceInMeters: Double
    
    init(userLocation: CLLocation, selectedLocation: UberLocation) {
        self.startLocationString = "Current location"
        self.endLocationString = selectedLocation.title
        self.userLocation = userLocation
        self.dropOffLocation = selectedLocation
        
        self.distanceInMeters =  userLocation.distance(from: CLLocation(latitude: selectedLocation.coordinate.latitude,
                                                                        longitude: selectedLocation.coordinate.longitude))
                
        
        calculateTripTime(forDistance: distanceInMeters)
    }
    
    func calculateTripTime(forDistance distance: Double) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: dropOffLocation.coordinate))
        request.transportType = .automobile
        let directions = MKDirections(request: request)
        
        directions.calculate { response, error in
            if let error = error {
                print("DEBUG: Failed to get directions with error \(error.localizedDescription)")
                return
            }
            
            guard let response = response, !response.routes.isEmpty else { return }
            guard let route = response.routes.first else { return }
            
            let expectedTravelTimeInSeconds = route.expectedTravelTime
            self.configurePickupAndDropOffTime(with: expectedTravelTimeInSeconds)
        }
    }
    
    func configurePickupAndDropOffTime(with expectedTravelTime: Double) {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        
        self.pickupTime = formatter.string(from: Date())
        self.dropOffTime = formatter.string(from: Date() + expectedTravelTime)
        
//        print("DEBUG: Pickup time \(self.pickupTime)")
//        print("DEBUG: Dropoff time \(self.dropOffTime)")
    }
}

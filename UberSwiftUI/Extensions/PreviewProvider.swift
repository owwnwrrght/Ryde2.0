//
//  PreviewProvider.swift
//  UberSwiftUI
//
//  Created by Stephan Dowless on 8/31/22.
//

import SwiftUI
import MapKit

extension PreviewProvider {
    
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
}

class DeveloperPreview {
    static let instance = DeveloperPreview()
    
    let mockSelectedLocation = UberLocation(title: "Starbucks", coordinate: CLLocationCoordinate2D(latitude: 37.6, longitude: -122.43))
    
    let rideDetailsViewModel = RideDetailsViewModel(
        userLocation: CLLocation(latitude: 37.75, longitude: -122.432),
        selectedLocation: UberLocation(title: "Starbucks",
                                       coordinate: CLLocationCoordinate2D(latitude: 37.6, longitude: -122.43))
    )
    
    let userLocation = CLLocation(latitude: 37.75, longitude: -122.432)
    
    let rideDetails = RideDetails(startLocation: "Current Location",
                                  endLocation: "123 Main St",
                                  userLocation: CLLocation(latitude: 37.75, longitude: -122.432))
}

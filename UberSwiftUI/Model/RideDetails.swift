//
//  RideDetails.swift
//  UberSwiftUI
//
//  Created by Stephan Dowless on 8/31/22.
//

import Foundation
import CoreLocation

struct RideDetails {
    let startLocation: String
    let endLocation: String
    let userLocation: CLLocation
//    let tripDistance: Double
//    let pickupTime: String
//    let dropOffTime: String
}


struct UberLocation {
    let title: String
    let coordinate: CLLocationCoordinate2D
}

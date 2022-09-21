//
//  TripState.swift
//  UberSwiftUI
//
//  Created by Stephan Dowless on 9/21/22.
//

import Foundation

enum TripState: Int, Codable {
    case driversUnavailable
    case rejectedByDriver
    case rejectedByAllDrivers
    case requested // value has to equal 3 to correspond to mapView tripRequested state
    case accepted
    case driverArrived
    case inProgress
    case arrivedAtDestination
    case complete
    case cancelled
}

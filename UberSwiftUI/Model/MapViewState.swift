//
//  MapViewState.swift
//  UberSwiftUI
//
//  Created by Stephan Dowless on 9/21/22.
//

import Foundation

enum MapViewState: Int {
    case noInput
    case searchingForLocation
    case locationSelected
    case tripRequested
    case tripAccepted
    case driverArrived
    case tripInProgress
    case arrivedAtDestination
    case tripCompleted
    case tripCancelled
    case polylineAdded
}

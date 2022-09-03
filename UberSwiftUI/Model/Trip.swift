//
//  Trip.swift
//  UberSwiftUI
//
//  Created by Stephan Dowless on 9/2/22.
//

import FirebaseFirestoreSwift
import Firebase

struct Trip: Codable, Identifiable {
    @DocumentID var id: String?
    let driverUid: String
    let passengerUid: String
    let pickupLocation: GeoPoint
    let dropoffLocation: GeoPoint
    let dropoffLocationName: String
    let tripCost: Double
    let tripState: TripState
    
    var tripId: String { return id ?? "" }
}

/*
    Need a link between trip state and map state
*/

enum TripState: Int, Codable {
    case driversUnavailable
    case rejectedByDriver
    case rejectedByAllDrivers
    case requested // value has to equal 3 to correspond to mapView tripRequested state
    case accepted
    case inProgress
    case complete
}

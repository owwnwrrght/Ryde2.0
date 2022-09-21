//
//  Trip.swift
//  UberSwiftUI
//
//  Created by Stephan Dowless on 9/2/22.
//

import FirebaseFirestoreSwift
import Firebase
import CoreLocation

struct Trip: Codable, Identifiable {
    @DocumentID var id: String?
    let driverUid: String
    let passengerUid: String
    let pickupLocation: GeoPoint
    let dropoffLocation: GeoPoint
    var driverLocation: GeoPoint?
    let dropoffLocationName: String
    let pickupLocationName: String
    let pickupLocationAddress: String
    let tripCost: Double
    let tripState: TripState
    let driverName: String
    let passengerName: String
    let driverImageUrl: String
    let passengerImageUrl: String?
    
    
    var tripId: String { return id ?? "" }
    
    var dropoffLocationCoordinates: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: dropoffLocation.latitude, longitude: dropoffLocation.longitude)
    }
    
    var pickupLocationCoordiantes: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: pickupLocation.latitude, longitude: pickupLocation.longitude)
    }
    
    var dropoffUberLocation: UberLocation {
        return UberLocation(title: dropoffLocationName, coordinate: dropoffLocationCoordinates)
    }
    
    var passengerFirstNameUppercased: String {
        let components = passengerName.components(separatedBy: " ")
        guard let firstName = components.first else { return passengerName.uppercased() }
        
        return firstName.uppercased()
    }
    
    var driverFirstNameUppercased: String {
        let components = driverName.components(separatedBy: " ")
        guard let firstName = components.first else { return driverName.uppercased() }
        
        return firstName.uppercased()
    }
}



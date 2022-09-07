//
//  User.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 11/29/21.
//

import Foundation
import FirebaseFirestoreSwift
import CoreLocation
import Firebase

struct User: Codable {
    @DocumentID var id: String?
    let fullname: String
    let email: String
    var phoneNumber: String?
    var profileImageUrl: String?
    var homeLocation: SavedLocation?
    var workLocation: SavedLocation?
    var accountType: AccountType
    var coordinates: GeoPoint
    var vehicle: Vehicle?
    
    var uid: String { return id ?? "" }
}

struct SavedLocation: Codable {
    let title: String
    let address: String
    let latitude: Double
    let longitude: Double
}

enum AccountType: Int, Codable {
    case passenger
    case driver
}

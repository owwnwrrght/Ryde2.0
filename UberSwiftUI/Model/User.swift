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

struct User: Decodable {
    @DocumentID var id: String?
    let fullname: String
    let email: String
    var phoneNumber: String?
    var imageUrl: String?
    var homeLocation: SavedLocation?
    var workLocation: SavedLocation?
    var accountType: AccountType
    var coordinates: GeoPoint
}

struct SavedLocation: Decodable {
    let title: String
    let address: String
    let latitude: Double
    let longitude: Double
}

enum AccountType: Int, Decodable {
    case passenger
    case driver
}

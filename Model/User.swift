//
//  User.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 11/29/21.
//

import Foundation
import FirebaseFirestoreSwift
import CoreLocation

struct User: Decodable {
    let fullname: String
    let email: String
    var phoneNumber: String?
    var imageUrl: String?
    var homeLocation: SavedLocation?
    var workLocation: SavedLocation?
}

struct SavedLocation: Decodable {
    let title: String
    let address: String
    let latitude: Double
    let longitude: Double
}

//
//  DriverRegistrationViewModel.swift
//  UberSwiftUI
//
//  Created by Stephan Dowless on 9/7/22.
//

import UIKit
import Firebase

class DriverRegistrationViewModel: ObservableObject {
    
    private let user: User
    @Published var uploadDidComplete = false
    @Published var hasUploadedProfilePhoto: Bool
    @Published var hasUploadedVehicleInfo: Bool
    
    var userFirstName: String {
        let components = user.fullname.components(separatedBy: " ")
        guard let firstName = components.first else { return "" }
        return firstName
    }
    
    init(user: User) {
        self.user = user
        
        self.hasUploadedProfilePhoto = user.profileImageUrl != nil
        self.hasUploadedVehicleInfo = user.vehicle != nil
    }
    
    func uploadVehicle(make: String, model: String, year: Int, color: VehicleColors, licensePlate: String, type: RideType) {
        let vehicle = Vehicle(make: make, model: model, year: year, color: color, licensePlateNumber: licensePlate, type: type)
        guard let encodedVehicle = try? Firestore.Encoder().encode(vehicle) else { return }
        
        COLLECTION_USERS.document(user.id ?? "").updateData(["vehicle": encodedVehicle]) { _ in
            self.uploadDidComplete = true
            self.hasUploadedVehicleInfo = true
        }
    }
    
    func uploadProfileImage(_ image: UIImage) {
        ImageUploader.uploadImage(image: image) { imageUrl in
            COLLECTION_USERS.document(self.user.id ?? "").updateData(["profileImageUrl": imageUrl]) { _ in
                self.uploadDidComplete = true
                self.hasUploadedVehicleInfo = true
            }
        }
    }
}

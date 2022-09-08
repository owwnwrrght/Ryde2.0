//
//  DriverRegistrationViewModel.swift
//  UberSwiftUI
//
//  Created by Stephan Dowless on 9/7/22.
//

import UIKit
import Firebase

class DriverRegistrationViewModel: ObservableObject {
    
    var user: User
    @Published var uploadDidComplete = false
    @Published var didCompleteRegistration = false
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
            self.user.vehicle = vehicle
            self.hasUploadedVehicleInfo = true
        }
    }
    
    func uploadProfileImage(_ imageData: Data?) {
        guard let data = imageData else { return }
        
        ImageUploader.uploadImage(withData: data) { imageUrl  in
            COLLECTION_USERS.document(self.user.id ?? "").updateData(["profileImageUrl": imageUrl]) { _ in
                self.user.profileImageUrl = imageUrl
                self.hasUploadedProfilePhoto = true
            }
        }
    }
    
    func updateAccountType() {
        COLLECTION_USERS.document(user.uid).updateData(["accountType": AccountType.driver.rawValue]) { _ in
            self.didCompleteRegistration = false
        }
    }
}

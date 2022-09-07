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
    
    init(user: User) {
        self.user = user
        uploadVehicle()
    }
    
    func uploadVehicle() {
        let vehicle = Vehicle(make: "Ford", model: "Mustang", year: 2016, color: .black, licensePlateNumber: "3CG4228", type: .black)
        guard let encodedVehicle = try? Firestore.Encoder().encode(vehicle) else { return }
        
        COLLECTION_USERS.document(user.id ?? "").updateData(["vehicle": encodedVehicle]) { _ in
            self.uploadDidComplete = true
        }
    }
    
    func uploadProfileImage(_ image: UIImage) {
        ImageUploader.uploadImage(image: image) { imageUrl in
            COLLECTION_USERS.document(self.user.id ?? "").updateData(["profileImageUrl": imageUrl]) { _ in
                self.uploadDidComplete = true
            }
        }
    }
}

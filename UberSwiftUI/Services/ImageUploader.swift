//
//  ImageUploader.swift
//  UberSwiftUI
//
//  Created by Stephan Dowless on 9/7/22.
//

import UIKit
import FirebaseStorage

struct ImageUploader {
    static func uploadImage(withData data: Data, completion: @escaping(String)-> Void) {
        guard let image = UIImage(data: data) else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }

        let ref = Storage.storage().reference(withPath: "/profile_images/\(NSUUID().uuidString)")
        
        ref.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("DEBUG: Failed to upload image \(error.localizedDescription)")
                return
            }
            
            ref.downloadURL { (url, error) in
                guard let imageUrl = url?.absoluteString else { return }
                completion(imageUrl)
            }
        }
    }
}

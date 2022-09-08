//
//  UploadProfileImageView.swift
//  UberSwiftUI
//
//  Created by Stephan Dowless on 9/5/22.
//

import SwiftUI
import PhotosUI

@available(iOS 16.0, *)
struct UploadProfileImageView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
    var body: some View {
        
        VStack {
                        
            VStack(alignment: .leading, spacing: 12) {
                Text("Profile Photo")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Text("Your profile photo helps people recognize you")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            
        
            VStack(alignment: .leading, spacing: 12) {
                Text("Guidelines")
                    .font(.headline)
                
                Text("1. Make sure you are facing the camera with your eyes and mouth clearly visible")
                    .foregroundColor(.gray)
                
                Text("2. Make sure the photo is well lit, free of glare, and in focus")
                    .foregroundColor(.gray)
                
                Text("3. No photos of a photo, filters, or alterations")
                    .foregroundColor(.gray)

            }
            .font(.subheadline)
            .padding()
            
            if let selectedImageData,
               let uiImage = UIImage(data: selectedImageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 250, height: 250)
                    .clipShape(Circle())
            } else {
                VStack {
                    Text("Example")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Image("male-profile-photo-2")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 250, height: 250)
                        .clipShape(Circle())
                }
                .padding()

            }
            
            Spacer()
            
            ZStack {
                
                if selectedImageData == nil {
                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .images,
                        photoLibrary: .shared()) {
                            Text("SELECT IMAGE")
                                .fontWeight(.bold)
                                .frame(width: UIScreen.main.bounds.width - 64, height: 50)
                                .background(.blue)
                                .cornerRadius(10)
                                .foregroundColor(.white)
                        }
                        .onChange(of: selectedItem) { newItem in
                            Task {
                                // Retrieve selected asset in the form of Data
                                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                    selectedImageData = data
                                }
                            }
                        }
                } else {
                    Button {
                        print("DEBUG: Upload profile phot here..")
                    } label: {
                        Text("UPLOAD PHOTO")
                            .fontWeight(.bold)
                            .frame(width: UIScreen.main.bounds.width - 64, height: 50)
                            .background(.blue)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }

                }
                
            }
        }
        .foregroundColor(.black)
    }
}

struct UploadProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 16.0, *) {
            UploadProfileImageView()
        } else {
            // Fallback on earlier versions
        }
    }
}

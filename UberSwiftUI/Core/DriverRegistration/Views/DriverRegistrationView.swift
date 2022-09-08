//
//  GetStartedView.swift
//  UberSwiftUI
//
//  Created by Stephan Dowless on 9/5/22.
//

import SwiftUI

struct DriverRegistrationView: View {
    @Environment(\.presentationMode) var mode
    @EnvironmentObject var viewModel: DriverRegistrationViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading) {
                    Button {
                        mode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title)
                            .imageScale(.medium)
                            .padding()
                            .foregroundColor(.black)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Make Money \nDriving, \(viewModel.userFirstName)")
                            .font(.system(size: 36))
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.black)
                        
                        Text("We just need a few things from you")
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                    }
                }
                
                .padding(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Image("make-money-driving-2")
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: 220)
                    .padding(.bottom)
                
                VStack {
                    ZStack {
                        NavigationLink {
                            if #available(iOS 16.0, *) {
                                UploadProfileImageView()
                            }
                        } label: {
                            DriverChecklistItem(imageName: "person.crop.circle.fill.badge.plus",
                                                title: "Profile photo",
                                                isComplete: $viewModel.hasUploadedProfilePhoto)
                        }
                    }
                    .disabled(viewModel.hasUploadedProfilePhoto)
                    
                    
                    ZStack {
                        NavigationLink {
                            VehicleRegistrationView()
                        } label: {
                            DriverChecklistItem(imageName: "car.circle.fill",
                                                title: "Add your vehicle",
                                                isComplete: $viewModel.hasUploadedVehicleInfo)
                        }
                    }
                    .disabled(viewModel.hasUploadedVehicleInfo)
                }
                .padding()
                
                Spacer()
            }
            .navigationBarHidden(true)
            .ignoresSafeArea()
            .padding(.top, 12)
        }
    }
}

struct DriverRegistrationView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DriverRegistrationView()
                .environmentObject(DriverRegistrationViewModel(user: dev.mockDriver))
                .navigationBarHidden(true)
        }
    }
}



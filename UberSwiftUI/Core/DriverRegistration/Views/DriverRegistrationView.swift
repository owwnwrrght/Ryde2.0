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
    
    var hasCompletedAllRegistrationItems: Bool {
        return viewModel.hasUploadedVehicleInfo && viewModel.hasUploadedProfilePhoto
    }
    
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
                            .foregroundColor(Color.theme.primaryTextColor)
                    }
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Make Money \nDriving, \(viewModel.userFirstName)")
                            .font(.system(size: 36))
                            .fontWeight(.semibold)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color.theme.primaryTextColor)
                        
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
                                
                if hasCompletedAllRegistrationItems {
                    Button {
                        viewModel.updateAccountType()
                    } label: {
                        HStack {
                            Text("GET STARTED")
                                .fontWeight(.bold)
                            Image(systemName: "arrow.right")
                        }
                        .padding()
                        .background(.blue)
                        .clipShape(Capsule())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding()
                        .shadow(color: .gray, radius: 4, x: 0, y: 0)
                    }
                }
                
                Spacer()
            }
            .navigationBarHidden(true)
            .ignoresSafeArea()
            .padding(.top, 12)
            .onReceive(viewModel.$didCompleteRegistration) { didCompleteRegistration in
                if didCompleteRegistration {
                    mode.wrappedValue.dismiss()
                }
            }
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



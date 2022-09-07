//
//  GetStartedView.swift
//  UberSwiftUI
//
//  Created by Stephan Dowless on 9/5/22.
//

import SwiftUI

struct DriverRegistrationView: View {
    @Environment(\.presentationMode) var mode
    @StateObject var viewModel: DriverRegistrationViewModel
    
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
                        Text("Make Money \nDriving")
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
                    NavigationLink {
                        UploadProfileImageView()
                    } label: {
                        DriverChecklistItem(imageName: "person.crop.circle.fill.badge.plus", title: "Profile photo")
                    }
                    
                    NavigationLink {
                        VehicleRegistrationView()
                    } label: {
                        DriverChecklistItem(imageName: "car.circle.fill", title: "Add your vehicle")
                    }
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
            DriverRegistrationView(viewModel: DriverRegistrationViewModel(user: dev.mockDriver))
                .navigationBarHidden(true)
        }
    }
}

struct DriverChecklistItem: View {
    let imageName: String
    let title: String
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .font(.title)
                .imageScale(.small)
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Get started")
                
                Text(title)
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
            }
            .padding(.leading)
            
            Spacer()
            
            Image(systemName: "chevron.forward.circle.fill")
                .font(.title)
                .imageScale(.small)
        }
        .foregroundColor(.black)
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGroupedBackground)))
    }
}

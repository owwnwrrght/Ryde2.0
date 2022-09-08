//
//  SideMenuHeaderView.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 11/27/21.
//

import SwiftUI

struct SideMenuHeaderView: View {
    @Binding var isShowing: Bool
    @State var showDriverRegistrationView = false
    @EnvironmentObject var viewModel: ContentViewModel
    @State private var driverIsActive = false
    let user: User
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image("male-profile-photo")
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: 64, height: 64)
                    .clipShape(Circle())
                    .padding(.bottom, 16)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(user.fullname)
                        .font(.system(size: 16, weight: .semibold))
                    
                    Text(user.email)
                        .font(.system(size: 14))
                        .padding(.bottom, 20)
                        .opacity(0.87)
                }
            }
            
            HStack(spacing: 12) {
                VStack(alignment: .leading) {
                    Text(user.accountType == .passenger ? "Do more with your account" : "UBER DRIVER")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .opacity(0.87)
                        .padding(.bottom)
                    
                    if user.accountType == .passenger {
                        Button {
                            showDriverRegistrationView.toggle()
                        } label: {
                            HStack {
                                Image(systemName: "dollarsign.square")
                                    .font(.title2)
                                    .imageScale(.medium)
                                
                                Text("Make Money Driving" )
                                    .font(.system(size: 16, weight: .semibold))
                                    .padding(6)
                            }
                        }
                    } else {
                        HStack {
                            Image(systemName: "car.circle.fill")
                                .font(.title2)
                                .imageScale(.medium)
                            
                            Text("Active")
                                .font(.system(size: 16, weight: .semibold))
                                .padding(6)
                            
                            Spacer()
                            
                            Toggle("", isOn: $driverIsActive)
                                .tint(.blue)
                                .padding(.trailing, 32)
                                
                        }
                        .frame(maxWidth: 300)
                    }
                }
                .padding(.top, 24)
                
                Spacer()
            }
            
            Rectangle()
                .frame(width: 280, height: 0.5)
                .opacity(0.7)
                .padding(.leading, 32)
            
            Spacer()
        }
        .fullScreenCover(isPresented: $showDriverRegistrationView, content: {
            if let user = viewModel.user {
                DriverRegistrationView()
                    .environmentObject(DriverRegistrationViewModel(user: user))
            }
        })
        .padding()
    }
}

struct SideMenuHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuHeaderView(isShowing: .constant(true), user: dev.mockDriver)
    }
}

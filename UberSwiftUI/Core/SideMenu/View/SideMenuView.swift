//
//  SideMenuView.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 11/27/21.
//

import SwiftUI
import Kingfisher

struct SideMenuView: View {
    @Binding var isShowing: Bool
    var user: User
    @State private var driverIsActive = false
    @State private var showDriverRegistrationView = false
    @EnvironmentObject var viewModel: HomeViewModel
    
    init(isShowing: Binding<Bool>, user: User) {
        self._isShowing = isShowing
        self.user = user
        self._driverIsActive = State(wrappedValue: user.isActive)
    }
    
    var body: some View {
        VStack {
            headerView
                .padding(.top, 24)
            
            ForEach(SideMenuOptionViewModel.allCases, id: \.self) { option in
                if option == .settings {
                    NavigationLink(
                        destination: UserProfileView(),
                        label: {
                            SideMenuOptionView(viewModel: option)
                                .foregroundColor(Color.theme.primaryTextColor)
                        })
                } else if option == .trips {
                    NavigationLink(
                        destination: MyTripsView(user: user),
                        label: {
                            SideMenuOptionView(viewModel: option)
                                .foregroundColor(Color.theme.primaryTextColor)
                        })
                } else {
                    SideMenuOptionView(viewModel: option)
                }
            }
            
            Spacer()
        }
        .background(Color.theme.backgroundColor)
        .navigationBarHidden(true)
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView(isShowing: .constant(true), user: dev.mockDriver)
    }
}

extension SideMenuView {
    var headerView: some View {
        VStack(alignment: .leading) {
            if let user = viewModel.user {
                HStack {
                    
                    KFImage(URL(string: user.profileImageUrl ?? ""))
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
                                .foregroundColor(Color.theme.primaryTextColor)
                            }
                        } else {
                            HStack {
                                Image(systemName: "car.circle")
                                    .font(.title)
                                    .imageScale(.medium)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Active")
                                        .font(.system(size: 16, weight: .semibold))
                                    
                                    Text("Set your status to active to receive ride requests")
                                        .font(.caption)
                                        .foregroundColor(Color(.systemGray3))
                                        .multilineTextAlignment(.leading)
                                        .frame(height: 32)
                                }
                                .frame(width: 150)
                                .padding(6)
                                
                                Spacer()
                                
                                Toggle("", isOn: $driverIsActive)
                                    .tint(.blue)
                                    .padding(.trailing, 28)
                                    .onChange(of: driverIsActive) { driverIsActive in
                                        viewModel.updateDriverActiveState(driverIsActive)
                                    }
                                    
                            }
                            .frame(maxWidth: 316)
                        }
                    }
                    .padding(.top, 24)
                    
                    Spacer()
                }
                
                Rectangle()
                    .frame(width: 296, height: 0.75)
                    .opacity(0.7)
                    .padding(.top)
                    .foregroundColor(Color(.separator))
                    .shadow(color: .black.opacity(0.7), radius: 4)
                
                Spacer()
            }
        }
        .frame(height: 230)
        .background(Color.theme.backgroundColor)
        .fullScreenCover(isPresented: $showDriverRegistrationView, content: {
            if let user = user {
                DriverRegistrationView()
                    .environmentObject(DriverRegistrationViewModel(user: user))
            }
        })
        .padding()
    }
}


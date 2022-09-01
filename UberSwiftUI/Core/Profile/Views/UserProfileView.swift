//
//  UserProfileView.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 11/29/21.
//

import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State private var show = false
    
    var body: some View {
        VStack(alignment: .leading) {
            
            if let user = authViewModel.user {
                UserProfileHeader(user: user)
                    .padding()
                    .background(.white)
            }
            
            Text("Favorites")
                .padding()
            
            VStack {
                ForEach(SavedLocationOptions.allCases, id: \.self) { option in
                    NavigationLink {
                        SavedLocationInputView(show: $show, option: option)
                            .navigationBarHidden(true)
                    } label: {
                        SavedLocationCell(option: option, user: authViewModel.user)
                            .padding(6)
                    }
                    
                    if option != .work {
                        Divider()
                    }
                }
            }
            .padding(6)
            .background(.white)
            .padding(.leading, 4)
            
            Text("Settings")
                .padding()
            
            VStack {
                ForEach(SettingOptionsViewModel.allCases, id: \.self) { option in
                    SettingItemCell(viewModel: option)
                        .padding(6)
                    
                    if option != SettingOptionsViewModel.allCases.last {
                        Divider()
                    }
                }

            }
            .padding(6)
            .background(.white)
            .padding(.leading, 4)
            
            Button {
                authViewModel.signOut()
            } label: {
                HStack(alignment: .center) {
                    Text("Sign Out")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(.systemRed))
                        .padding(.leading, 24)
                    
                    Spacer()
                }
                .frame(height: 50)
                .background(.white)
            }
            .padding(.top, 40)
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .navigationBarTitle("Settings")
        .background(Color(.systemGroupedBackground))
    }
    
    var backButton: some View {
        Button {
            mode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "arrow.left")
                .font(.title)
                .imageScale(.medium)
                .padding(.vertical)
                .foregroundColor(.black)
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}

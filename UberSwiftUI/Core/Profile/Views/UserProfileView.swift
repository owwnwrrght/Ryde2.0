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
            
            if #available(iOS 16.0, *) {
                List {
                    Section {
                        if let user = authViewModel.user {
                            HStack {
                                ProfileImageView(imageUrl: user.profileImageUrl)
                                    .frame(width: 80, height: 80)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(user.fullname)
                                        .font(.headline)
                                    
                                    Text(user.email)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .imageScale(.small)
                                    .font(.title2)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    Section(header: Text("Favorites")) {
                        ForEach(SavedLocationOptions.allCases, id: \.self) { option in
                            NavigationLink {
                                SavedLocationInputView(show: $show, option: option)
                                    .navigationBarHidden(true)
                            } label: {
                                SavedLocationCell(option: option, user: authViewModel.user)
                            }
                        }
                    }
                    
                    Section(header: Text("Settings")) {
                        ForEach(SettingOptionsViewModel.allCases, id: \.self) { option in
                            SettingItemCell(viewModel: option)
                                .accentColor(.white)
                        }
                    }
                    
                    Section(header: Text("Account")) {
                        ForEach(AccountOptionsViewModel.allCases, id: \.self) { option in
                            SettingItemCell(viewModel: option)
                                .accentColor(.white)
                        }
                    }
                }
                .background(Color.theme.systemBackgroundColor)
                .scrollContentBackground(.hidden)
            }
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .navigationTitle("Settings")
        .background(Color.theme.systemBackgroundColor)
    }
    
    var backButton: some View {
        Button {
            mode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "arrow.left")
                .font(.title)
                .imageScale(.medium)
                .padding(.vertical)
                .foregroundColor(Color.theme.primaryTextColor)
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserProfileView()
                .environmentObject(AuthViewModel(window: UIWindow()))
        }
    }
}

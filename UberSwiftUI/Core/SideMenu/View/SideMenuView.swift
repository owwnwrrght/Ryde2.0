//
//  SideMenuView.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 11/27/21.
//

import SwiftUI

struct SideMenuView: View {
    @Binding var isShowing: Bool
    @EnvironmentObject var viewModel: ContentViewModel
    let user: User
    
    var body: some View {
        VStack {
            SideMenuHeaderView(isShowing: $isShowing, user: user)
                .frame(height: 220)
                .padding(.top, 24)
            
            ForEach(SideMenuOptionViewModel.allCases, id: \.self) { option in
                if option == .settings {
                    NavigationLink(
                        destination: UserProfileView(),
                        label: {
                            SideMenuOptionView(viewModel: option)
                                .foregroundColor(.black)
                        })
                } else if option == .trips {
                    NavigationLink(
                        destination: MyTripsView(),
                        label: {
                            SideMenuOptionView(viewModel: option)
                                .foregroundColor(.black)
                        })
                } else {
                    SideMenuOptionView(viewModel: option)
                }
            }
            
            Spacer()
        }
        .navigationBarHidden(true)
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView(isShowing: .constant(true), user: dev.mockDriver)
    }
}


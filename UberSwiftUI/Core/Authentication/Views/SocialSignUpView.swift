//
//  SocialSignUpView.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 12/4/21.
//

import SwiftUI

struct SocialSignUpView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            HStack(spacing: 24) {
                Rectangle()
                    .frame(width: 77, height: 1)
                    .foregroundColor(.white)
                    .opacity(0.5)
                
                Text("Sign in with social")
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
                
                Rectangle()
                    .frame(width: 76, height: 1)
                    .foregroundColor(.white)
                    .opacity(0.5)
            }
            
            HStack(spacing: 24) {
                Image("facebook-sign-in-icon")
                    .resizable()
                    .frame(width: 44, height: 44)
                
                Button {
                    viewModel.signInWithGoogle()
                } label: {
                    Image("google-sign-in-icon")
                        .resizable()
                        .frame(width: 44, height: 44)
                }

            }
            
        }
        .padding(.top, 32)
    }
}

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
                    Text("Do more with your account")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .opacity(0.87)
                        .padding(.bottom)
                    
                    Button {
                        showDriverRegistrationView.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "dollarsign.square")
                                .font(.title2)
                                .imageScale(.medium)
                            
                            Text("Make Money Driving")
                                .font(.system(size: 16, weight: .semibold))
                                .padding(6)
                        }
                    }
                    
                }
                .padding(.top, 24)
                
                Spacer()
            }
            
            Rectangle()
                .foregroundColor(.white)
                .opacity(0.7)
                .frame(width: 300, height: 0.75)
                .padding(.top)
            
            Spacer()
        }
        .fullScreenCover(isPresented: $showDriverRegistrationView, content: {
            DriverRegistrationView(viewModel: DriverRegistrationViewModel(user: user))
        })
        .foregroundColor(.white)
        .padding()
    }
}

//struct SideMenuHeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        SideMenuHeaderView(isShowing: .constant(true))
//    }
//}

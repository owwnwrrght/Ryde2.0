//
//  UserProfileHeader.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 11/29/21.
//

import SwiftUI

struct UserProfileHeader: View {
    let user: User
    
    var body: some View {
        HStack {
            Image("male-profile-photo")
                .resizable()
                .frame(width: 120, height: 120)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 8) {
                Text(user.fullname)
                
                if let phoneNumber = user.phoneNumber {
                    Text(phoneNumber)
                }
                
                Text(user.email)
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .imageScale(.small)
                .font(.title2)
                .foregroundColor(.gray)
        }
    }
}

//struct UserProfileHeader_Previews: PreviewProvider {
//    static var previews: some View {
//        UserProfileHeader()
//    }
//}

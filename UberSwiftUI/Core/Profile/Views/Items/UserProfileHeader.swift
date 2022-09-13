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
            ProfileImageView(imageUrl: user.profileImageUrl)
                .frame(width: 100, height: 100)
            
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

//struct UserProfileHeader_Previews: PreviewProvider {
//    static var previews: some View {
//        UserProfileHeader()
//    }
//}

//
//  ProfileImageView.swift
//  UberSwiftUI
//
//  Created by Stephan Dowless on 9/9/22.
//

import SwiftUI
import Kingfisher

struct ProfileImageView: View {
    let imageUrl: String?
    var body: some View {
        
        ZStack {
            if let imageUrl = imageUrl {
                KFImage(URL(string: imageUrl))
                    .resizable()
                    .scaledToFill()
                    .clipped()
//                    .frame(width: 64, height: 64)
                    .clipShape(Circle())
                    .padding(.bottom, 16)
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .clipped()
//                    .frame(width: 64, height: 64)
                    .clipShape(Circle())
                    .padding(.bottom, 16)
                    .foregroundColor(Color(.systemGray4))
            }
        }
    }
}

struct ProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImageView(imageUrl: dev.mockDriver.profileImageUrl)
    }
}

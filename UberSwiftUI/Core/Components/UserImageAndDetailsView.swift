//
//  UserImageAndDetailsView.swift
//  UberSwiftUI
//
//  Created by Stephan Dowless on 9/5/22.
//

import SwiftUI

struct UserImageAndDetailsView: View {
    let username: String
    
    var body: some View {
        HStack {
            Image("male-profile-photo")
                .resizable()
                .frame(width: 64, height: 64)
                .scaledToFill()
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(username)
                    .fontWeight(.bold)
                    .font(.body)
                
                HStack(alignment: .center, spacing: 2) {
                    Image(systemName: "star.fill")
                        .foregroundColor(Color(.systemYellow))
                        .imageScale(.small)
                    
                    Text("4.8")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
        }
    }
}

struct UserImageAndDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        UserImageAndDetailsView(username: "John Doe")
    }
}

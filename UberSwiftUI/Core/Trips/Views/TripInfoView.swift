//
//  TripInfoView.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 12/5/21.
//

import SwiftUI

struct TripInfoView: View {
    var body: some View {
        HStack {
            Image("male-profile-photo")
                .resizable()
                .frame(width: 56, height: 56)
                .scaledToFill()
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("JOHN DOE")
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
            
            HStack(spacing: 44) {
                VStack(spacing: 4) {
                    Text("Final cost")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray)
                    
                    Text("$120.00")
                        .font(.system(size: 15, weight: .semibold))
                }
                
                VStack(spacing: 4) {
                    Text("Time")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray)
                    
                    Text("30m")
                        .font(.system(size: 15, weight: .semibold))
                }
            }
        }
        .padding(.horizontal)
        .padding(4)    }
}

struct TripInfoView_Previews: PreviewProvider {
    static var previews: some View {
        TripInfoView()
    }
}

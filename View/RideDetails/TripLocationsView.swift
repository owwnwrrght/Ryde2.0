//
//  TripLocationsView.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 11/26/21.
//

import SwiftUI

struct TripLocationsView: View {
    var body: some View {
        HStack(spacing: 24) {
            VStack {
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundColor(.gray)
                
                Rectangle()
                    .frame(width: 1, height: 32)
                    .foregroundColor(.gray)
                
                Rectangle()
                    .frame(width: 8, height: 8)
                    .foregroundColor(.black)
            }
            
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Text("345 Cityhall Park")
                        .font(.system(size: 18, weight: .semibold))
                    
                    Spacer()
                    
                    Text("9:40 PM")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(.darkGray))
                }
                
                HStack {
                    Text("Barclay Stadium")
                        .font(.system(size: 18, weight: .semibold))
                    
                    Spacer()
                    
                    Text("10:10 PM")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(.darkGray))
                }
            }
        }
        .padding(.top, 16)
        .padding(.leading, 8)
    }
}

struct TripLocationsView_Previews: PreviewProvider {
    static var previews: some View {
        TripLocationsView()
    }
}

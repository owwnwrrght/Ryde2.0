//
//  TripLocationsView.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 11/26/21.
//

import SwiftUI

struct TripLocationsView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    
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
                    .background(Color(.black))
                    .frame(width: 8, height: 8)
            }
            
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Text("Current location")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(viewModel.pickupTime ?? "...")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(.darkGray))
                }
                .padding(.bottom, 10)
                
                HStack {
                    Text(viewModel.selectedLocation?.title ?? "")
                        .font(.system(size: 16, weight: .semibold))
                    
                    Spacer()
                    
                    Text(viewModel.dropOffTime ?? "..." )
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

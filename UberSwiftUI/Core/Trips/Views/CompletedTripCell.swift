//
//  CompletedTripCell.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 12/5/21.
//

import SwiftUI

struct CompletedTripCell: View {
    let trip: Trip
    let user: User
    
    var body: some View {
        VStack {
            TripInfoView(trip: trip, user: user)
                .padding(8)
            
            Divider()
            
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
                        Text(trip.pickupLocationName)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Text("1:30 PM")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(.darkGray))
                    }
                    .padding(.bottom, 10)
                    
                    HStack {
                        Text(trip.dropoffLocationName)
                            .font(.system(size: 16, weight: .semibold))
                        
                        Spacer()
                        
                        Text("2:00 PM")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(.darkGray))
                    }
                }
            }
            .padding()
        }
        .padding(8)
        .background(.white)
        .cornerRadius(10)
    }
}

struct CompletedTripCell_Previews: PreviewProvider {
    static var previews: some View {
        CompletedTripCell(trip: dev.mockTrip, user: dev.mockPassenger)
    }
}

//
//  TripInfoView.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 12/5/21.
//

import SwiftUI

struct TripInfoView: View {
    let trip: Trip
    let user: User
    
    var username: String {
        return user.accountType == .passenger ? trip.driverFirstNameUppercased : trip.passengerFirstNameUppercased
    }
    
    var imageUrl: String? {
        return user.accountType == .passenger ? trip.driverImageUrl : trip.passengerImageUrl
    }
    
    var body: some View {
        HStack {
            UserImageAndDetailsView(imageUrl: imageUrl, username: username)
            
            Spacer()
            
            HStack(spacing: 44) {
                VStack(spacing: 4) {
                    Text("Trip cost")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray)
                    
                    Text(trip.tripCost.currencyString)
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
        .padding(4)
        
        
        
    }
}

struct TripInfoView_Previews: PreviewProvider {
    static var previews: some View {
        TripInfoView(trip: dev.mockTrip, user: dev.mockPassenger)
    }
}

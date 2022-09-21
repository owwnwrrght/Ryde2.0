//
//  TripInfoView.swift
//  UberSwiftUI
//
//  Created by Stephan Dowless on 12/5/21.
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
            
            HStack(spacing: 32) {
                VStack(spacing: 4) {
                    Text("Trip cost")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray)
                    
                    Text(trip.tripCost.toCurrency())
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
    }
}

struct TripInfoView_Previews: PreviewProvider {
    static var previews: some View {
        TripInfoView(trip: dev.mockTrip, user: dev.mockPassenger)
    }
}

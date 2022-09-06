//
//  DriverArrivalView.swift
//  UberSwiftUI
//
//  Created by Stephan Dowless on 9/4/22.
//

import SwiftUI

struct DriverArrivalView: View {
    @EnvironmentObject var contentViewModel: ContentViewModel
    
    var body: some View {
        VStack(alignment: .center) {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(8)
            
            Text("YOUR DRIVER IS HERE")
                .fontWeight(.bold)
                .font(.system(size: 14))
            
            Divider()
            
            HStack {
                if let trip = contentViewModel.trip {
                    UserImageAndDetailsView(username: trip.driverName.uppercased())
                    
                    Spacer()
                    
                    DriverVehicleInfoView()
                }
            }
            .padding(.horizontal)
            
            Divider()
            
            VStack(alignment: .leading) {
                Text("TRIP")
                    .fontWeight(.semibold)
                    .font(.body)
                
                TripLocationsView()
                
                Divider()
            }
            .padding()
            
            Text("Please check your driver's license \n plate and ensure you have the correct ride")
                .font(.headline)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(height: 50)
                .padding(.bottom)
            
            Spacer()
        }
        .background(Color(.white))
        .clipShape(RoundedShape(corners: [.topLeft, .topRight]))
        .frame(height: 450)
        .shadow(color: .black, radius: 10, x: 0, y: 0)
    }
}

struct DriverArrivalView_Previews: PreviewProvider {
    static var previews: some View {
        DriverArrivalView()
            .environmentObject(ContentViewModel())
    }
}

//
//  SwiftUIView.swift
//  UberSwiftUI
//
//  Created by Stephan Dowless on 9/4/22.
//

import SwiftUI

struct PickupPassengerView: View {
    @ObservedObject var viewModel: RideDetailsViewModel
    @EnvironmentObject var contentViewModel: ContentViewModel
    
    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(8)
            
            Text("YOU'VE ARRIVED")
                .fontWeight(.bold)
                .font(.system(size: 14))
            
            Divider()
            
            TripInfoView()
            
            Divider()
            
            VStack(alignment: .leading) {
                Text("TRIP")
                    .fontWeight(.semibold)
                    .font(.body)
                
                TripLocationsView(viewModel: viewModel)
                
                Divider()
            }
            .padding()
            
            Button {
                print("DEBUG: Pickup passenger")
            } label: {
                Text("PICKUP JOHN")
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width - 64, height: 50)
                    .background(.blue)
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
            .padding()
        }
        .background(Color(.white))
        .clipShape(RoundedShape(corners: [.topLeft, .topRight]))
        .frame(height: 420)
        .shadow(color: .black, radius: 10, x: 0, y: 0)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        PickupPassengerView(viewModel: dev.rideDetailsViewModel)
    }
}

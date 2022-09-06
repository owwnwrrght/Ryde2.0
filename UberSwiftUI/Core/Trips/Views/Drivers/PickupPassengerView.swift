//
//  SwiftUIView.swift
//  UberSwiftUI
//
//  Created by Stephan Dowless on 9/4/22.
//

import SwiftUI

struct PickupPassengerView: View {
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
            
            if let trip = contentViewModel.trip, let user = contentViewModel.user {
                TripInfoView(trip: trip, user: user)
                    .padding(.vertical, 8)
                
                Divider()
                
                VStack(alignment: .leading) {
                    Text("TRIP")
                        .fontWeight(.semibold)
                        .font(.body)
                    
                    TripLocationsView()
                    
                    Divider()
                        .padding(.top)
                }
                .padding()
                
                Button {
                    contentViewModel.pickupPassenger()
                } label: {
                    Text("PICKUP JOHN")
                        .fontWeight(.bold)
                        .frame(width: UIScreen.main.bounds.width - 64, height: 50)
                        .background(.blue)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
                .padding()
                .padding(.bottom, 4)
                
                Spacer()
            }
        }
        .background(Color(.white))
        .clipShape(RoundedShape(corners: [.topLeft, .topRight]))
        .frame(height: 400)
        .shadow(color: .black, radius: 10, x: 0, y: 0)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        PickupPassengerView()
    }
}

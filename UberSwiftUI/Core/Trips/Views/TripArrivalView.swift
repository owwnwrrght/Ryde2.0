//
//  TripArrivalView.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 11/26/21.
//

import SwiftUI

struct TripArrivalView: View {
    @ObservedObject var viewModel: RideDetailsViewModel
    
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
            
            VStack(spacing: 6) {
                Text("HOW WAS YOUR TRIP?")
                    .font(.body)
                    .fontWeight(.bold)
                    .padding(.top, 16)
                
                Text("Your feedback will help up provide a better driving experience")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 15))
                    .padding(8)
                    .padding(.horizontal, 4)
                    .foregroundColor(.gray)
            }
            
            
            HStack {
                ForEach(1 ... 5, id: \.self) { index in
                    Image(systemName: "star.fill")
                        .font(.title)
                        .imageScale(.large)
                        .foregroundColor(Color(.systemGray4))
                    
                }
            }
            .padding(.top, 8)
            
            Spacer()
        }
        .background(Color(.white))
        .clipShape(RoundedShape(corners: [.topLeft, .topRight]))
        .frame(height: 520)
    }
}

struct RideArrivalView_Previews: PreviewProvider {
    static var previews: some View {
        TripArrivalView(viewModel: dev.rideDetailsViewModel)
    }
}

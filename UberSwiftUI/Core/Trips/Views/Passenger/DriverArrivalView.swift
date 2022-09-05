//
//  DriverArrivalView.swift
//  UberSwiftUI
//
//  Created by Stephan Dowless on 9/4/22.
//

import SwiftUI

struct DriverArrivalView: View {
    @ObservedObject var viewModel: RideDetailsViewModel
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
            
            driverInfoView
            
            Divider()
            
            VStack(alignment: .leading) {
                Text("TRIP")
                    .fontWeight(.semibold)
                    .font(.body)
                
                TripLocationsView(viewModel: viewModel)
                
                Divider()
            }
            .padding()
            
            Text("Please check your driver's license \n plate and ensure you have the correct ride")
                .font(.headline)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(height: 50)
                .padding(.bottom)
        }
        .background(Color(.white))
        .clipShape(RoundedShape(corners: [.topLeft, .topRight]))
        .frame(height: 420)
        .shadow(color: .black, radius: 10, x: 0, y: 0)
    }
}

struct DriverArrivalView_Previews: PreviewProvider {
    static var previews: some View {
        DriverArrivalView(viewModel: dev.rideDetailsViewModel)
    }
}

extension DriverArrivalView {
    var driverInfoView: some View {
        HStack {
            Image("male-profile-photo")
                .resizable()
                .frame(width: 64, height: 64)
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
            
            VStack(alignment: .trailing) {
                Image("uber-x")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 116, height: 64)
                
                VStack {
                    Text("Mercedes S")
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                    
                    Text("5G432K")
                        .font(.system(size: 14))
                        .fontWeight(.semibold)
                }
                .frame(width: 120)
            }
            .padding(.bottom)
        }
        .padding(.horizontal)
    }
}

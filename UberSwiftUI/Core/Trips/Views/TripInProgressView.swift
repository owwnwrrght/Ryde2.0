//
//  TripInProgressView.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 11/26/21.
//

import SwiftUI

struct TripInProgressView: View {
    @ObservedObject var viewModel: RideDetailsViewModel
    @EnvironmentObject var contentViewModel: ContentViewModel
    
    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(8)
            
            VStack(alignment: .leading) {
                Text("Your driver will arrive in 10 minutes")
                    .font(.body)
                    .fontWeight(.semibold)
                    .padding()
                
                Divider()
                
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
                        
                        HStack(spacing: 2) {
                            Text("Mercedes S -")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                            
                            Text("5G432K")
                                .font(.caption)
                                .fontWeight(.semibold)
                        }
                    }
                    .padding(.bottom)
                }
                .padding(.horizontal)
                
                Divider()
                
                VStack(alignment: .leading) {
                    Text("TRIP")
                        .fontWeight(.semibold)
                        .font(.body)
                    
                    TripLocationsView(viewModel: viewModel)
                        .padding(.bottom)
                    
                    Divider()
                }
                .padding()
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("PAYMENT")
                        .fontWeight(.semibold)
                        .font(.body)
                    
                    Text("$40.00")
                        .font(.title)
                        .fontWeight(.bold)
                }
                .padding(.leading)
                
                Divider()
            }
            
            Button {
                contentViewModel.cancelTrip()
            } label: {
                Text("CANCEL TRIP")
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width - 64, height: 50)
                    .background(Color(.systemRed))
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
            .padding()
            
            Spacer()
        }
        .background(Color(.white))
        .clipShape(RoundedShape(corners: [.topLeft, .topRight]))
        .frame(height: 620)
        .shadow(color: .black, radius: 10, x: 0, y: 0)
    }
}

struct TripInProgressView_Previews: PreviewProvider {
    static var previews: some View {
        TripInProgressView(viewModel: dev.rideDetailsViewModel)
    }
}



//
//  EnRouteToPickupLocationView.swift
//  UberSwiftUI
//
//  Created by Stephan Dowless on 9/6/22.
//

import SwiftUI

struct EnRouteToPickupLocationView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    
    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(8)
            
            if let user = homeViewModel.user {
                VStack(alignment: .leading) {
                    
                    if let trip = homeViewModel.trip {
                        HStack {
                            if user.accountType == .passenger {
                                Text("Meet your driver at \(trip.pickupLocationName)")
                                    .font(.body)
                            } else {
                                Text("Pickup \(trip.passengerName) at \(trip.pickupLocationName)")
                                    .font(.body)
                                    .multilineTextAlignment(.leading)
                                    .frame(height: 44)
                                    .lineLimit(2)
                            }
                            
                            Spacer()
                            
                            EstimatedTimeArrivalView(time: "10")
                        }
                        .padding()
                        
                        Divider()
                            .padding(.top, 8)

                        if user.accountType == .passenger {
                            HStack {
                                UserImageAndDetailsView(imageUrl: trip.driverImageUrl, username: trip.driverFirstNameUppercased)
                                    .padding(.leading)
                                
                                Spacer()
                                
                                DriverVehicleInfoView()
                                    .padding(.trailing)
                            }
                        } else {
                            HStack {
                                TripInfoView(trip: trip, user: user)
                                    .padding(.vertical)
                            }
                        }
                    }

                    Divider()
                }
            }
            
            Button {
                homeViewModel.cancelTrip()
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
        .background(Color.theme.backgroundColor)
        .clipShape(RoundedShape(corners: [.topLeft, .topRight]))
        .frame(height: 350)
        .shadow(color: .black, radius: 10, x: 0, y: 0)
    }
}

struct EnRouteToPickupLocationView_Previews: PreviewProvider {
    static var previews: some View {
        EnRouteToPickupLocationView()
            .environmentObject(dev.homeViewModel)
    }
}

//
//  EnRouteToPickupLocationView.swift
//  UberSwiftUI
//
//  Created by Stephan Dowless on 9/6/22.
//

import SwiftUI

struct EnRouteToPickupLocationView: View {
    @EnvironmentObject var contentViewModel: ContentViewModel
    
    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(8)
            
            if let user = contentViewModel.user {
                VStack(alignment: .leading) {
                    
                    if let trip = contentViewModel.trip {
                        HStack {
                            if user.accountType == .passenger {
                                Text("Meet your driver at \(trip.pickupLocationName)")
                                    .font(.body)
                                    .padding()
                            } else {
                                Text("Pickup \(trip.passengerName) at \(trip.pickupLocationName)")
                                    .font(.body)
                                    .multilineTextAlignment(.leading)
                                    .frame(height: 44)
                                    .lineLimit(2)
                                    .padding()
                            }
                            
                            Spacer()
                            
                            EstimatedTimeArrivalView()
                        }
                        
                        Divider()
                            .padding(.top, 8)

                        if user.accountType == .passenger {
                            HStack {
                                UserImageAndDetailsView(username: user.accountType == .passenger ? trip.driverName : trip.passengerName)
                                    .padding(.leading)
                                
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
        .frame(height: 340)
        .shadow(color: .black, radius: 10, x: 0, y: 0)
    }
}

struct EnRouteToPickupLocationView_Previews: PreviewProvider {
    static var previews: some View {
        EnRouteToPickupLocationView()
            .environmentObject(dev.contentViewModel)
    }
}

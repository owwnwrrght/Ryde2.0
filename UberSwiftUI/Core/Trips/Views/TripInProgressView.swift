//
//  TripInProgressView.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 11/26/21.
//

import SwiftUI

struct TripInProgressView: View {
    @EnvironmentObject var contentViewModel: ContentViewModel
    
    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(8)
            
            VStack(alignment: .leading) {
                
                if let trip = contentViewModel.trip {
                    HStack {
                        Text("Meet your driver at \(trip.pickupLocationName)")
                            .font(.body)
                            .fontWeight(.semibold)
                            .padding()
                        
                        Spacer()
                        
                        VStack {
                            Text("2")
                            
                            Text("min")
                        }
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                    }
                }
                
                Divider()
                
                
                // passenger
                HStack {
                    UserImageAndDetailsView(username: "JOHN DOE")
                        .padding(.leading)

                    DriverVehicleInfoView()
                        .padding(.trailing)
                }
                
                // driver
//
//                HStack {
//                    UserImageAndDetailsView(username: "JOHN DOE")
//                        .padding()
//
//
//                }
                
                Divider()
                
//                VStack(alignment: .leading) {
//                    Text("TRIP")
//                        .fontWeight(.semibold)
//                        .font(.body)
//                    
//                    TripLocationsView()
//                        .padding(.bottom)
//                    
//                    Divider()
//                }
//                .padding()
                
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
        TripInProgressView()
            .environmentObject(ContentViewModel())
    }
}



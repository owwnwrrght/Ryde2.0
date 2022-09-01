//
//  BookingView.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 11/24/21.
//

import SwiftUI
import MapKit

struct BookingView: View {
    @ObservedObject var viewModel: RideDetailsViewModel
    
    init(userLocation: CLLocation, selectedLocation: UberLocation) {
        self.viewModel = RideDetailsViewModel(userLocation: userLocation, selectedLocation: selectedLocation)
    }
    
    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(8)
            
            VStack(alignment: .leading, spacing: 24) {
                
                TripLocationsView(viewModel: viewModel)
                    .padding(.horizontal)
                
                Text("SUGGESTED RIDES")
                    .font(.body)
                    .fontWeight(.semibold)
                    .padding(.leading)
                    .foregroundColor(Color(.darkGray))
                
                ScrollView(.horizontal) {
                    HStack(spacing: 12) {
                        ForEach(RideType.allCases, id: \.self) { rideType in
                            VStack(alignment: .leading) {
                                Image(rideType.imageName)
                                    .resizable()
                                    .foregroundColor(Color(.systemGray5))
                                    .scaledToFit()
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(rideType.description)
                                        .font(.system(size: 14, weight: .semibold))
                                    
                                    Text(rideType.price(for: viewModel.distanceInMeters).currencyString)
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                .padding(.vertical, 8)
                                .padding(.leading)
                            }
                            .frame(width: 112, height: 140)
                            .background(Color(.systemGroupedBackground))
                            .cornerRadius(10)
                        }
                    }
                }
                .padding(.horizontal)
                
                HStack(spacing: 12) {
                    
                    Text("Visa")
                        .fontWeight(.semibold)
                        .padding(6)
                        .background(Color(.systemBlue))
                        .cornerRadius(4)
                        .foregroundColor(.white)
                        .padding(.leading)
                    
                    Text("**** 1234")
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .imageScale(.medium)
                        .padding()
                }
                .frame(height: 50)
                .background(Color(.systemGroupedBackground))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
            
            Button {
                print("Book now")
            } label: {
                Text("CONFIRM RIDE")
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                    .background(Color(.systemBlue))
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
            
            Spacer()
        }
        .background(Color.white)
        .frame(height: 500)
        .clipShape(RoundedShape(corners: [.topLeft, .topRight]))
        .shadow(color: .black, radius: 10, x: 0, y: 0)
    }
}



struct BookingView_Previews: PreviewProvider {
    static var previews: some View {
        BookingView(userLocation: dev.userLocation, selectedLocation: dev.mockSelectedLocation)
    }
}

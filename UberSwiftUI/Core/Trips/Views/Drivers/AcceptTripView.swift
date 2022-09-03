//
//  AcceptTripView.swift
//  UberSwiftUI
//
//  Created by Stephan Dowless on 9/2/22.
//

import SwiftUI
import MapKit

struct AcceptTripView: View {
    
    @EnvironmentObject var viewModel: ContentViewModel
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    )
    
    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(.top, 8)
            
            VStack {
                Text("Would you like to pickup this passenger?")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom)
                
                HStack {
                    Image("male-profile-photo")
                        .resizable()
                        .frame(width: 64, height: 64)
                        .scaledToFill()
                        .cornerRadius(10)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Stephan Dowless")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
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
                    
//                    Spinner(lineWidth: 4, height: 96, width: 96)
                }
                
                Divider()
                    .padding(2)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("Estimated Earnings")
                        .fontWeight(.semibold)
                        .font(.body)
                    
                    Text("$40.00")
                        .font(.title)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
            }
            .padding()
            
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Starbucks")
                            .font(.body)
                        
                        Text("123 Main St, Gaithersburg MD")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 6) {
                        Text("5.2")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Text("mi")
                            .foregroundColor(.gray)
                            .font(.caption)
                    }
                    
                }
                .padding(.horizontal)

                Map(coordinateRegion: $region)
                    .frame(height: 180)
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .shadow(color: .black.opacity(0.6), radius: 5, x: 0, y: 0)
                
                
            }
            .padding(.vertical)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
                .padding(.horizontal, 8)
            
            Spacer()
            
            actionButtons
            
            Spacer()
        }
        .ignoresSafeArea()
        .background(.white)
        .frame(height: 640)
        .clipShape(RoundedShape(corners: [.topLeft, .topRight]))
        .shadow(color: .black, radius: 10, x: 0, y: 0)
    }
}

struct AcceptTripView_Previews: PreviewProvider {
    static var previews: some View {
        AcceptTripView()
    }
}

extension AcceptTripView {
    var actionButtons: some View {
        HStack {
            Button {
                viewModel.rejectTrip()
            } label: {
                Text("Reject")
                    .font(.headline)
                    .padding()
                    .frame(width: (UIScreen.main.bounds.width / 2) - 32, height: 50)
                    .background(.red)
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Button {
                viewModel.acceptTrip()
            } label: {
                Text("Accept")
                    .font(.headline)
                    .padding()
                    .frame(width: (UIScreen.main.bounds.width / 2) - 32, height: 50)
                    .background(.blue)
                    .cornerRadius(10)
                    .foregroundColor(.white)

            }

        }
        .padding(.horizontal)
    }
}

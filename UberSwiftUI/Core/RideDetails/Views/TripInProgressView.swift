//
//  TripInProgressView.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 11/26/21.
//

import SwiftUI

struct TripInProgressView: View {
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
                    .padding(6)
                
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
                            .frame(width: 72, height: 56)
                        
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
                }
                .padding(.horizontal)
                
                Divider()
                
                VStack(alignment: .leading) {
                    Text("TRIP")
                        .fontWeight(.semibold)
                        .font(.body)
                    
//                    TripLocationsView()
                    
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
                    
                    HStack(spacing: 12) {
                        
                        Text("VISA")
                            .fontWeight(.semibold)
                            .padding(8)
                            .background(Color(.systemBlue))
                            .cornerRadius(4)
                            .foregroundColor(.white)
                            .padding(.leading)
                        
                        VStack(alignment: .leading) {
                            Text("**** **** **** 1234")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                            
                            Text("Expires 10/25")
                                .foregroundColor(.gray)
                                .font(.footnote)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .imageScale(.medium)
                            .padding()
                    }
                    .padding(8)
                    .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(.lightGray), lineWidth: 0.75)
                        )
                }
                .padding(8)
                
                Divider()
            }
            
            Button {
                print("Book now")
            } label: {
                Text("CANCEL TRIP")
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                    .background(Color(.systemRed))
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
            .padding(.bottom)
        }
        .background(Color(.white))
        .clipShape(RoundedShape(corners: [.topLeft, .topRight]))
        .frame(height: 500)
    }
}

struct TripInProgressView_Previews: PreviewProvider {
    static var previews: some View {
        TripInProgressView()
    }
}



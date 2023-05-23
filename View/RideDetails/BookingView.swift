//
//  BookingView.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 11/24/21.
//

import SwiftUI

struct BookingView: View {
    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(8)
            
            VStack(alignment: .leading, spacing: 24) {
                
                TripLocationsView()
                    .padding(.horizontal)
                
                Text("SUGGESTED RIDES")
                    .font(.body)
                    .fontWeight(.semibold)
                    .padding(.leading)
                    .foregroundColor(Color(.darkGray))
                
                ScrollView(.horizontal) {
                    HStack(spacing: 12) {
                        ForEach(1 ... 3, id: \.self) { index in
                            VStack(alignment: .leading) {
                                Image("uber-x")
                                    .resizable()
                                    .foregroundColor(Color(.systemGray5))
                                    .frame(width: 88, height: 64)
                                    .scaledToFit()
                                    .padding(.vertical)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("UBERX")
                                        .font(.system(size: 14, weight: .bold))
                                    
                                    Text("$25.00")
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                .padding(.bottom, 8)
                            }
                            .frame(width: 112, height: 140)
                            .background(Color(.systemGray5))
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
        BookingView()
    }
}

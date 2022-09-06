//
//  TripArrivalView.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 11/26/21.
//

import SwiftUI

struct TripArrivalView: View {
    @EnvironmentObject var contentViewModel: ContentViewModel
    let user: User
    
    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(8)
                        
            HStack {
                Spacer()
                    .frame(width: UIScreen.main.bounds.width / 2 - 64)
                                
                Text("YOU'VE ARRIVED")
                    .fontWeight(.bold)
                    .font(.system(size: 14))
                    .frame(width: 128)
                
                Spacer()
                
                Button {
                    print("DEBUG: Dismiss view..")
                } label: {
                    Image(systemName: "xmark")
                        .imageScale(.large)
                        .foregroundColor(.black)
                }
                .padding(.trailing)
            }
            .padding(.vertical, 8)
            
            Divider()
            
            TripInfoView()
                .padding(.vertical, 8)
            
            Divider()
            
            VStack(alignment: .leading) {
                Text("TRIP")
                    .fontWeight(.semibold)
                    .font(.body)
                
                TripLocationsView()
                
                Divider()
                    .padding(.top)
            }
            .padding()
            
            if user.accountType == .driver {
                Button {
                    contentViewModel.dropOffPassenger()
                } label: {
                    Text("DROP OFF STEPHAN")
                        .fontWeight(.bold)
                        .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                        .background(.blue)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
                .padding(8)
            } else {
                VStack(spacing: 6) {
                    Text("HOW WAS YOUR TRIP?")
                        .font(.body)
                        .fontWeight(.bold)
                    
                    Text("Your feedback will help up provide a better driving experience")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 15))
                        .padding(.horizontal, 4)
                        .frame(height: 48)
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
                .padding(.vertical, 8)
            }

            Spacer()
        }
        .background(Color(.white))
        .clipShape(RoundedShape(corners: [.topLeft, .topRight]))
        .frame(height: user.accountType == .driver ? 450 : 560)
        .shadow(color: .black, radius: 10, x: 0, y: 0)
    }
}

struct RideArrivalView_Previews: PreviewProvider {
    static var previews: some View {
        TripArrivalView(user: dev.mockPassenger)
    }
}

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
            
            VStack {
                if let trip = contentViewModel.trip, let user = contentViewModel.user {
                    HStack {
                        Text("En Route to destination")
                            .font(.body)
                            .fontWeight(.semibold)
                            .padding()
                        
                        Spacer()
                        
                        VStack {
                            Text("2")
                                .bold()
                            
                            Text("min")
                                .bold()
                        }
                        .frame(width: 56, height: 56)
                        .background(.blue)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .padding(.trailing)
                    }
                    
                    Divider()
                    
                    TripInfoView(trip: trip, user: user)
                        .padding(.vertical)
                                        
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
        }
        .background(Color(.white))
        .clipShape(RoundedShape(corners: [.topLeft, .topRight]))
        .frame(height: 320)
        .shadow(color: .black, radius: 10, x: 0, y: 0)
    }
}

struct TripInProgressView_Previews: PreviewProvider {
    static var contentViewModel: ContentViewModel {
        let vm = ContentViewModel()
        vm.trip = dev.mockTrip
        vm.user = dev.mockDriver
        vm.selectedLocation = dev.mockSelectedLocation
        return vm
    }
    
    static var previews: some View {
        TripInProgressView()
            .environmentObject(contentViewModel)
    }
}



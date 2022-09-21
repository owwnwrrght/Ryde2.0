//
//  CompletedTripView.swift
//  UberSwiftUI
//
//  Created by Stephan Dowless on 12/5/21.
//

import SwiftUI

struct MyTripsView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @StateObject var viewModel = TripsViewModel()
    let user: User

    var body: some View {
        VStack(alignment: .leading, spacing: -16) {
            
            HStack {
                VStack(alignment: .leading) {
                    Button {
                        mode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.title)
                            .imageScale(.medium)
                            .padding()
                            .foregroundColor(.black)
                    }
                    
                    Text("My Trips")
                        .font(.title)
                        .fontWeight(.semibold)
                        .padding(.leading)
                }
                Spacer()
            }
            .padding(.leading, 4)
            .padding(.bottom)
            .background(.white)
            
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(viewModel.trips) { trip in
                        //TODO: Implement trip date
                        Text("9/19/22")
                            .fontWeight(.semibold)
                            .font(.body)
                            .padding()
                        
                        CompletedTripCell(trip: trip, user: user)
                            .padding(4)
                            .padding(.horizontal, 8)
                    }
                }
            }
            .padding(.top, 44)
            .ignoresSafeArea()
        }
        .padding(.bottom)
        .background(Color.theme.systemBackgroundColor)
        .navigationBarHidden(true)
    }
}

struct MyTripsView_Previews: PreviewProvider {
    static var previews: some View {
        MyTripsView(user: dev.mockPassenger)
    }
}

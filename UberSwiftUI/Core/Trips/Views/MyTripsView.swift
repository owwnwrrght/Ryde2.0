//
//  CompletedTripView.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 12/5/21.
//

import SwiftUI

struct MyTripsView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

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
                    
                    ForEach(0 ... 5, id: \.self) { index in
                        Text("TODAY: 4:50 PM")
                            .fontWeight(.semibold)
                            .font(.body)
                            .padding()
                        
                        CompletedTripCell()
                            .padding()
                            .padding(.horizontal, 8)
                    }
                }
            }
            .padding(.top, 44)
            .ignoresSafeArea()
        }
        .padding(.bottom)
        .background(Color.theme.backgroundColor)
        .navigationBarHidden(true)
    }
}

struct MyTripsView_Previews: PreviewProvider {
    static var previews: some View {
        MyTripsView()
    }
}

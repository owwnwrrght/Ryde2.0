//
//  TripLoadingView.swift
//  UberSwiftUI
//
//  Created by Stephan Dowless on 9/1/22.
//

import SwiftUI

struct TripLoadingView: View {
    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding()
            
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Connecting you to a driver")
                    .font(.headline)
                
                Text("Arriving at 1:30 PM")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                
                Divider()
                
                Spacer()
            }
            .padding()
            .frame(maxWidth :.infinity, alignment: .leading)
            
            Spinner()
                .padding(.vertical, 16)
                .padding(.bottom, 16)
            
            Spacer()
            
        }
        .ignoresSafeArea()
        .background(.white)
        .clipShape(RoundedShape(corners: [.topLeft, .topRight]))
        .frame(maxHeight: 330)
        .shadow(color: .black, radius: 10, x: 0, y: 0)
    }
}

struct TripLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        TripLoadingView()
            .background(Color.gray)
    }
}

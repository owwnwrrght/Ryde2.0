//
//  CompletedTripCell.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 12/5/21.
//

import SwiftUI

struct CompletedTripCell: View {
    var body: some View {
        VStack {
            TripInfoView()
                .padding(.vertical, 8)
            
            Divider()
            
            VStack(alignment: .leading) {
                Text("TRIP")
                    .fontWeight(.semibold)
                    .font(.body)
                
                TripLocationsView()
            }
            .padding()
        }
        .background(.white)
        .cornerRadius(10)
    }
}

struct CompletedTripCell_Previews: PreviewProvider {
    static var previews: some View {
        CompletedTripCell()
    }
}

//
//  EstimateTimeArrivalView.swift
//  UberSwiftUI
//
//  Created by Stephan Dowless on 9/6/22.
//

import SwiftUI

struct EstimatedTimeArrivalView: View {
    var body: some View {
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
    }
}

struct EstimatedTimeArrivalView_Previews: PreviewProvider {
    static var previews: some View {
        EstimatedTimeArrivalView()
    }
}

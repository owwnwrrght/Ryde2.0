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
            Text("Connecting you to a driver")
                .font(.headline)
        }
    }
}

struct TripLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        TripLoadingView()
    }
}

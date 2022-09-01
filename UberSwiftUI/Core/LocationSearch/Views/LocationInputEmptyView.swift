//
//  LocationInputEmptyView.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 12/4/21.
//

import SwiftUI

struct LocationInputEmptyView: View {
    var body: some View {
        VStack(spacing: 32) {
            Image(systemName: "paperplane.circle")
                .resizable()
                .frame(width: 120, height: 120)
            
            Text("Search for a place to go")
                .font(.title2)
                .foregroundColor(Color(.darkGray))
        }
    }
}

struct LocationInputEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        LocationInputEmptyView()
    }
}

//
//  LocationInputActivationView.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 11/13/21.
//

import SwiftUI

struct LocationInputActivationView: View {
//    var animation: Namespace.ID
    
    var body: some View {
        HStack(spacing: 8) {
            
            Rectangle()
                .fill(Color.black)
                .frame(width: 8 , height: 8)
                .padding(.horizontal)
            
            Text("Where to?")
                .foregroundColor(Color(.darkGray))
            
            Spacer()
        }
//        .matchedGeometryEffect(id: "LocationInput", in: animation)
        .frame(width: UIScreen.main.bounds.width - 64, height: 50)
        .background(Color.white.opacity(0.9))
        .padding(.top, 108)
    }
}

struct LocationInputActivationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationInputActivationView()
    }
}

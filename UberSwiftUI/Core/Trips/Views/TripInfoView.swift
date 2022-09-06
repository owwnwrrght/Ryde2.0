//
//  TripInfoView.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 12/5/21.
//

import SwiftUI

struct TripInfoView: View {
    var body: some View {
        HStack {
            UserImageAndDetailsView(username: "JOHN DOE")
            
            Spacer()
            
            HStack(spacing: 44) {
                VStack(spacing: 4) {
                    Text("Final cost")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray)
                    
                    Text("$120.00")
                        .font(.system(size: 15, weight: .semibold))
                }
                
                VStack(spacing: 4) {
                    Text("Time")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray)
                    
                    Text("30m")
                        .font(.system(size: 15, weight: .semibold))
                }
            }
        }
        .padding(.horizontal)
        .padding(4)    }
}

struct TripInfoView_Previews: PreviewProvider {
    static var previews: some View {
        TripInfoView()
    }
}

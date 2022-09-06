//
//  DriverVehicleInfoView.swift
//  UberSwiftUI
//
//  Created by Stephan Dowless on 9/5/22.
//

import SwiftUI

struct DriverVehicleInfoView: View {
    var body: some View {
        VStack(alignment: .center) {
            Image("uber-x")
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 64)
            
            HStack {
                Text("Mercedes S -")
                    .font(.system(size: 14))
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                
                Text("5G432K")
                    .font(.system(size: 14))
                    .fontWeight(.semibold)
            }
            .frame(width: 160)
            .padding(.bottom)
        }
    }
}

struct DriverVehicleInfoView_Previews: PreviewProvider {
    static var previews: some View {
        DriverVehicleInfoView()
    }
}

//
//  LocationCell.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 12/4/21.
//

import SwiftUI
import MapKit

struct LocationCell: View {
    let result: MKLocalSearchCompletion
    
    var body: some View {
        HStack {
            Image(systemName: "mappin.circle.fill")
                .resizable()
                .foregroundColor(Color.blue)
                .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(result.title)
                    .font(.body)
                
                Text(result.subtitle)
                    .font(.system(size: 15))
                    .foregroundColor(Color(.gray))
                
                Divider()
            }
            .padding(.leading, 8)
            .padding(.vertical, 8)
            
            Spacer()
        }
        .padding(.leading)
    }
}

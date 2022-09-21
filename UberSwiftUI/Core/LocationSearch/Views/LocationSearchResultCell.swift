//
//  LocationCell.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 12/4/21.
//

import SwiftUI
import MapKit

struct LocationSearchResultCell: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack {
            Image(systemName: "mappin.circle.fill")
                .resizable()
                .foregroundColor(Color.blue)
                .frame(width: 40, height: 40)
                .accentColor(.white)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                
                Text(subtitle)
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

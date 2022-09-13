//
//  SavedLocationCell.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 11/29/21.
//

import SwiftUI

struct SavedLocationCell: View {
    let option: SavedLocationOptions
    var user: User?
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: option.imageName)
                .imageScale(.medium)
                .font(.title)
                .foregroundColor(Color(.systemBlue))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(option.title)
                    .foregroundColor(Color.theme.primaryTextColor)
                    .font(.system(size: 15))
                    .fontWeight(.semibold)
                
                Text(locationText(forOption: option))
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
        }
    }
    
    func locationText(forOption option: SavedLocationOptions) -> String {
        guard let user = user else { return "" }
        
        switch option {
        case .home:
            guard let homeLocation = user.homeLocation else { return "Add Home"}
            return homeLocation.title
        case .work:
            guard let workLocation = user.workLocation else { return "Add Work" }
            return workLocation.title
        }
    }
}

//struct SavedLocationCell_Previews: PreviewProvider {
//    static var previews: some View {
//        SavedLocationCell(option: .work, address: "123 Main St")
//    }
//}

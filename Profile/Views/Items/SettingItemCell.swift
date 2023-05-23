//
//  SettingItemCell.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 11/29/21.
//

import SwiftUI

struct SettingItemCell: View {
    let viewModel: SettingOptionsViewModel
    
    var body: some View {
        NavigationLink {
            Text(viewModel.title)
        } label: {
            HStack(spacing: 12) {
                Image(systemName: viewModel.imageName)
                    .imageScale(.large)
                    .font(.title)
                    .foregroundColor(Color(viewModel.imageBackgroundColor))
                
                Text(viewModel.title)
                    .font(.system(size: 15))
                    .foregroundColor(.black)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .imageScale(.small)
                    .font(.title2)
                    .foregroundColor(.gray)
            }
        }

    }
}

struct SettingItemCell_Previews: PreviewProvider {
    static var previews: some View {
        SettingItemCell(viewModel: .paymentMethods)
    }
}

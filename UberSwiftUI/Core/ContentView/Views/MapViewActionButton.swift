//
//  MapViewActionButton.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 11/26/21.
//

import SwiftUI

struct MapViewActionButton: View {
    let state: MapViewState
    let action: () -> Void
    
    var body: some View {
        HStack {
            Button(action: action, label: {
                Image(systemName: imageNameForState(state: state))
                    .font(.title2)
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.white)
                    .clipShape((Circle()))
                    .shadow(color: .black, radius: 5, x: 0, y: 0)
            })
            .padding(12)
            .padding(.top, 32)
            
            Spacer()
        }
    }
    
    func imageNameForState(state: MapViewState) -> String {
        switch state {
        case .searchingForLocation,
                .locationSelected,
                .transitioning,
                .tripAccepted,
                .tripRequested:
            return "arrow.left"
        case .noInput:
            return "line.3.horizontal"
        }
    }
}

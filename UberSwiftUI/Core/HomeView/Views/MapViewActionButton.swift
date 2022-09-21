//
//  MapViewActionButton.swift
//  UberSwiftUI
//
//  Created by Stephan Dowless on 11/26/21.
//

import SwiftUI

struct MapViewActionButton: View {
    @Binding var state: MapViewState
    @Binding var showSideMenu: Bool
    @EnvironmentObject var viewModel: LocationSearchViewModel
        
    var body: some View {
        HStack {
            Button {
                withAnimation(.spring()) {
                    actionForState()
                }
            } label: {
                Image(systemName: imageNameForState(state: state))
                    .font(.title2)
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.white)
                    .clipShape((Circle()))
                    .shadow(color: .black, radius: 5, x: 0, y: 0)
            }
            .padding(12)
            .padding(.top, 32)
            
            Spacer()
        }
    }
    
    func imageNameForState(state: MapViewState) -> String {
        switch state {
        case .searchingForLocation,
                .locationSelected,
                .tripAccepted,
                .tripRequested,
                .tripCompleted,
                .polylineAdded:
            return "arrow.left"
        case .noInput, .tripCancelled:
            return "line.3.horizontal"
        default:
            return "line.3.horizontal"
        }
    }
    
    func actionForState() {
        switch state {
        case .noInput:
            showSideMenu.toggle()
        case .searchingForLocation:
            state = .noInput
        case .locationSelected, .polylineAdded:
            state = .noInput
            viewModel.selectedLocation = nil
        case .tripRequested:
            state = .noInput
            viewModel.selectedLocation = nil
        default: break
        }
    }
}

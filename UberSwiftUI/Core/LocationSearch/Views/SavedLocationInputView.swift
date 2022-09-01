//
//  SavedLocationInputView.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 12/4/21.
//

import SwiftUI

struct SavedLocationInputView: View {
    @Binding var show: Bool
    @EnvironmentObject var viewModel: LocationSearchViewModel
    let option: SavedLocationOptions
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    mode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title)
                        .imageScale(.medium)
                        .padding()
                }
                
                TextField("Where to?", text: $viewModel.queryFragment)
                    .frame(height: 32)
                    .padding(.leading)
                    .background(Color(.systemGray5))
                    .padding(.trailing)
            }
            
            LocationResultsView(config: .savedLocations(option), show: $show)
        }
        .navigationBarHidden(true)
    }
}

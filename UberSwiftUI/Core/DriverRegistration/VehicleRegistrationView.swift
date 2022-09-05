//
//  VehicleRegistrationView.swift
//  UberSwiftUI
//
//  Created by Stephan Dowless on 9/5/22.
//

import SwiftUI

struct VehicleRegistrationView: View {
    @State private var vehicleName = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Text("Your Car")
                    .font(.system(size: 36))
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                
                VStack(spacing: 32) {
                    VehicleInputField(text: $vehicleName, title: "Vehicle Make", placeholder: "Enter make..")
                    
                    VehicleInputField(text: $vehicleName, title: "Vehicle Model", placeholder: "Enter model..")
                    
                    VehicleInputField(text: $vehicleName, title: "Vehicle Year", placeholder: "2022")
                    
                    VehicleInputField(text: $vehicleName, title: "License Plate", placeholder: "G53XYC")
                    
                    VehicleInputField(text: $vehicleName, title: "Color", placeholder: "Enter color..")
                }
                .padding()
                
                Button {
                    
                } label: {
                    Text("ADD VEHICLE")
                        .fontWeight(.bold)
                        .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                        .background(.blue)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
            }
        }
    }
}

struct VehicleInputField: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .fontWeight(.semibold)
                .font(.footnote)
                .opacity(0.87)
            
            TextField(placeholder, text: $text)
            
            Divider()
        }
    }
}

struct VehicleRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VehicleRegistrationView()
        }
    }
}

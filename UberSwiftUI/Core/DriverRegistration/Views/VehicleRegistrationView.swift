//
//  VehicleRegistrationView.swift
//  UberSwiftUI
//
//  Created by Stephan Dowless on 9/5/22.
//

import SwiftUI

struct VehicleRegistrationView: View {
    @State private var make = ""
    @State private var model = ""
    @State private var year = ""
    @State private var licensePlate = ""
    @State private var color = ""
    @State private var type = ""
    @EnvironmentObject var viewModel: DriverRegistrationViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                Text("Your Car")
                    .font(.system(size: 36))
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.black)
                    .padding()
                
                VStack(spacing: 16) {
                    VehicleInputField(text: $make, title: "Make", placeholder: "Enter make..")
                    
                    VehicleInputField(text: $model, title: "Model", placeholder: "Enter model..")
                    
                    VehicleInputField(text: $year, title: "Year", placeholder: "Enter year...")
                    
                    VehicleInputField(text: $licensePlate, title: "License Plate", placeholder: "G53XYC")
                    
                    VehicleInputField(text: $color, title: "Color", placeholder: "Enter color..")
                    
                    VehicleInputField(text: $type, title: "Uber Type", placeholder: "Select type..")

                }
                .padding(.horizontal, 8)
                .padding()
                
                Button {
                    viewModel.uploadVehicle(
                        make: make,
                        model: model,
                        year: Int(year) ?? 0,
                        color: .black,
                        licensePlate: licensePlate,
                        type: .uberX
                    )
                } label: {
                    Text("ADD VEHICLE")
                        .fontWeight(.bold)
                        .frame(width: UIScreen.main.bounds.width - 64, height: 50)
                        .background(.blue)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
                .padding(.top)
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
                .foregroundColor(.black)
            
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

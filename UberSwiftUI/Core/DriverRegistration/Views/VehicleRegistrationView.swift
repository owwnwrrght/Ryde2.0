//
//  VehicleRegistrationView.swift
//  UberSwiftUI
//
//  Created by Stephan Dowless on 9/5/22.
//

import SwiftUI

enum InputType {
    case text
    case picker([Any])
}

struct VehicleRegistrationView: View {
    @State private var make = ""
    @State private var model = ""
    @State private var year = ""
    @State private var licensePlate = ""
    @State private var color = VehicleColors.black.rawValue
    @State private var type = RideType.uberX.rawValue
    @EnvironmentObject var viewModel: DriverRegistrationViewModel
    @Environment(\.presentationMode) var mode
    
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
                                        
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Color")
                            .fontWeight(.semibold)
                            .font(.footnote)
                            .opacity(0.87)
                            .foregroundColor(.black)
                        
                        Picker("", selection: $color) {
                            ForEach(VehicleColors.allCases) { color in
                                Text(color.description)
                            }
                        }
                        .labelStyle(.titleOnly)
                        .accentColor(.black)
                        .offset(x: -10)
                        
                        Divider()
                    }
                                        
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Vehicle Type")
                            .fontWeight(.semibold)
                            .font(.footnote)
                            .opacity(0.87)
                            .foregroundColor(.black)
                        
                        Picker("", selection: $type) {
                            ForEach(RideType.allCases) { type in
                                Text(type.description)
                            }
                        }
                        .labelStyle(.titleOnly)
                        .accentColor(.black)
                        .offset(x: -10)
                        
                        Divider()
                    }

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
            .foregroundColor(.black)
        }
        .onReceive(viewModel.$uploadDidComplete) { success in
            if success {
                mode.wrappedValue.dismiss()
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

//struct VehicleSelectionView: View {
//    let title: String
//    let content: Content
//
//    init(title: String, @ViewBuilder content: () -> Content) {
//        self.title = title
//        self.content = content
//    }
//
//    var body: some View {
//        Text("Vehicle Type")
//            .fontWeight(.semibold)
//            .font(.footnote)
//            .opacity(0.87)
//            .foregroundColor(.black)
//
//        content
//    }
//}

struct VehicleRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VehicleRegistrationView()
                .environmentObject(DriverRegistrationViewModel(user: dev.mockDriver))
        }
    }
}

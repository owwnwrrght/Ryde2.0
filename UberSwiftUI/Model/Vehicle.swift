//
//  Vehicle.swift
//  UberSwiftUI
//
//  Created by Stephan Dowless on 9/5/22.
//

import Foundation

struct Vehicle {
    let make: String
    let model: String
    let year: Int
    let color: VehicleColors
    let licensePlateNumber: String
    let type: RideType
}

enum VehicleColors: Int {
    case black
    case white
    case red
    case yellow
    case gray
    case blue
}


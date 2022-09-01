//
//  Ride.swift
//  UberSwiftUI
//
//  Created by Stephan Dowless on 8/31/22.
//

import Foundation

enum RideType: CaseIterable {
    case uberX
    case black
    case uberXL
    
    var description: String {
        switch self {
        case .uberX:return "UberX"
        case .black:return "Uber Black"
        case .uberXL:return "Uber XL"
        }
    }
    
    var imageName: String {
        switch self {
        case .uberX:return "uber-x"
        case .black:return "uber-black"
        case .uberXL:return "uber-x"
        }
    }
    
    func price(for distance: Double) -> Double {
        switch self {
        case .uberX:return distance * 1.5
        case .black: return distance * 1.75
        case .uberXL:return distance * 2
        }
    }
}

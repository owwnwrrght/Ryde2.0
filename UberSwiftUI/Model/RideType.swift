//
//  Ride.swift
//  UberSwiftUI
//
//  Created by Stephan Dowless on 8/31/22.
//

import Foundation

enum RideType: Int, CaseIterable, Identifiable, Codable {
    case uberX
    case black
    case uberXL
    
    var id: Int { return rawValue }
    
    var currentGasPricePerGallon: Double { return 4.3 }
    
    var description: String {
        switch self {
        case .uberX:return "UberX"
        case .black:return "Uber Black"
        case .uberXL:return "UberXL"
        }
    }
    
    var imageName: String {
        switch self {
        case .uberX: return "uber-x"
        case .black: return "uber-black"
        case .uberXL: return "uber-x"
        }
    }
    
    var baseFare: Double {
        switch self {
        case .uberX: return 5
        case .black: return 25
        case .uberXL: return 10
        }
    }
    
    func price(for distanceInMeters: Double) -> Double {
        let distanceInMiles = distanceInMeters / 1600
        
        switch self {
        case .uberX: return distanceInMiles * 1.5 + baseFare
        case .black: return distanceInMiles * 1.75 + baseFare
        case .uberXL: return distanceInMiles * 2 + baseFare
        }
    }
}

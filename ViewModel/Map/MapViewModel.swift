//
//  MapViewModel.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 11/13/21.
//

import Foundation

class MapViewModel: ObservableObject {
    private let locationManager: LocationManager
    
    init() {
        self.locationManager = LocationManager.shared
    }
    
}

//
//  DriverAnnotation.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 11/30/21.
//

import MapKit


class DriverAnnotation: NSObject, MKAnnotation {
    @objc dynamic var coordinate: CLLocationCoordinate2D
    var uid: String
    
    init(uid: String, coordinate: CLLocationCoordinate2D) {
        self.uid = uid
        self.coordinate = coordinate
    }
    
    func updatePosition(withCoordinate coordinate: CLLocationCoordinate2D) {
        UIView.animate(withDuration: 0.2) {
            self.coordinate = coordinate
        }
    }
}

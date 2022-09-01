//
//  DriverAnnotation.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 11/30/21.
//

import MapKit


class DriverAnnotation: NSObject, MKAnnotation {
    @objc dynamic var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.755, longitude: -122.5)
//    var uid: String
    
//    init(uid: String, coordinate: CLLocationCoordinate2D) {
//        self.uid = uid
//        self.coordinate = coordinate
//    }
    
    func updatePosition(withCoordinate coordinate: CLLocationCoordinate2D) {
//        print("DEBUG: Input coordinate is \(coordinate)")
        UIView.animate(withDuration: 0.2) {
            self.coordinate = coordinate
//            print("DEBUG: New coordinate is \(self.coordinate)")
        }
    }
}

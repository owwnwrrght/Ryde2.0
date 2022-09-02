//
//  ContentViewModel.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 11/12/21.
//

import Foundation
import CoreLocation
import GeoFireUtils
import Firebase

class ContentViewModel: ObservableObject {
    
    @Published var drivers = [User]()
//    @Published var mapState = MapViewState.noInput
    
    let latitude = 37.3346
    let longitude = -122.0090
    var location: CLLocationCoordinate2D
    let db = Firestore.firestore()
        
    let radius: Double = 50 * 1000
    var didExecuteFetchDrivers = false
    
    init() {
        print("DEBUG: Did init view model..")
        self.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        fetchNearbyDrivers(withCoordinates: self.location)
    }
    

    
    func uploadData() {
        let hash = GFUtils.geoHash(forLocation: location)
        let documentData: [String: Any] = [
            "geohash": hash,
            "lat": latitude,
            "lng": longitude
        ]
        
        let ref = db.collection("cities").document("LON")
        ref.setData(documentData)
    }
    
    func fetchNearbyDrivers(withCoordinates coordinates: CLLocationCoordinate2D) {
        let queryBounds = GFUtils.queryBounds(forLocation: coordinates, withRadius: radius)
        didExecuteFetchDrivers = true
        
        let queries = queryBounds.map { bound -> Query in
            return COLLECTION_USERS
                .order(by: "geohash")
                .start(at: [bound.startValue])
                .end(at: [bound.endValue])
        }
        
        for query in queries {
            query.getDocuments(completion: getDocumentsCompletion)
        }
    }
    
    func getDocumentsCompletion(snapshot: QuerySnapshot?, error: Error?) -> () {
        guard let documents = snapshot?.documents else { return }
        
        documents.forEach { doc in
            guard let driver = try? doc.data(as: User.self), driver.accountType == .driver else { return }
            let coordinates = CLLocation(latitude: driver.coordinates.latitude, longitude: driver.coordinates.longitude)
            let centerPoint = CLLocation(latitude: location.latitude, longitude: location.longitude)
            
            let distance = GFUtils.distance(from: centerPoint, to: coordinates)
            
            if distance <= radius {
                self.drivers.append(driver)
            }
        }
    }
}

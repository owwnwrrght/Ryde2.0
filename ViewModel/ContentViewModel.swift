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

class ContentViewModel {
    
    let latitude = 51.5074
    let longitude = 0.12780
    var location: CLLocationCoordinate2D
    let radius: Double = 50 * 1000
    let db = Firestore.firestore()
    
    var matchingDocs = [QueryDocumentSnapshot]()
    
    init() {
        self.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        fetchNearbyCities()
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
    
    func fetchNearbyCities() {
        let queryBounds = GFUtils.queryBounds(forLocation: location, withRadius: radius)
        
        let queries = queryBounds.map { bound -> Query in
            return db.collection("cities")
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
            print("DEBUG: Doc is \(doc.data())")
            
            let lat = doc.data()["lat"] as? Double ?? 0
            let lng = doc.data()["lng"] as? Double ?? 0
            let coordinates = CLLocation(latitude: lat, longitude: lng)
            let centerPoint = CLLocation(latitude: location.latitude, longitude: location.longitude)
            
            let distance = GFUtils.distance(from: centerPoint, to: coordinates)
            
            
            
            if distance < radius {
                matchingDocs.append(doc)
            }
        }
    }
    
}

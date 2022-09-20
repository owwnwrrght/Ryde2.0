//
//  TripViewModel.swift
//  UberSwiftUI
//
//  Created by Stephan Dowless on 9/2/22.
//

import SwiftUI
import Firebase

class TripsViewModel: ObservableObject {
    
    @Published var trips = [Trip]()
    
    init() {
        fetchTrips()
    }
    
    func fetchTrips() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_USERS.document(uid).collection("user-trips").getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            let results = documents.compactMap{ try? $0.data(as: Trip.self) }
            self.trips = results
        }
    }
}

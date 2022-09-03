//
//  TripViewModel.swift
//  UberSwiftUI
//
//  Created by Stephan Dowless on 9/2/22.
//

import SwiftUI
import Firebase

/*
 This view model is used when a trip has been created.
*/

class TripViewModel: ObservableObject {
    
    private let trip: Trip
    
    init(trip: Trip) {
        self.trip = trip
    }
    
    func acceptTrip() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        COLLECTION_RIDES.document(currentUid).updateData(["tripState": MapViewState.tripAccepted.rawValue]) { _ in
            print("DEBUG: Did accept trip")
        }
    }
    
    func addTripObserverForPassenger() {
        
    }
}

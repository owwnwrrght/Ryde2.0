//
//  TripService.swift
//  UberSwiftUI
//
//  Created by Stephan Dowless on 9/4/22.
//

import Firebase

typealias FirestoreCompletion = (((Error?) -> Void)?)

struct TripService {
    
    // MARK: - Properties
    
    var trip: Trip?
    var user: User?
        
    // MARK: - Helpers
    
    private func updateTripState(_ trip: Trip, state: TripState, completion: FirestoreCompletion) {
        COLLECTION_RIDES.document(trip.tripId).updateData(["tripState": state.rawValue], completion: completion)
    }
    
    private func deleteTrip(completion: FirestoreCompletion) {
        guard let trip = trip else { return }
        COLLECTION_RIDES.document(trip.tripId).delete(completion: completion)
    }    
}

// MARK: - Driver API

extension TripService {
    func addTripObserverForDriver(listener: @escaping(FIRQuerySnapshotBlock)) {
        guard let user = user, user.accountType == .driver, let uid = user.id else { return }
        COLLECTION_RIDES.whereField("driverUid", isEqualTo: uid).addSnapshotListener(listener)
    }
    
    func acceptTrip(completion: FirestoreCompletion) {
        guard let trip = trip else { return }
        guard let user = user, user.accountType == .driver else { return }
                
        COLLECTION_RIDES.document(trip.tripId) .updateData(["tripState": MapViewState.tripAccepted.rawValue], completion: completion)
    }
    
    func rejectTrip(completion: FirestoreCompletion) {
        guard let trip = trip else { return }
        updateTripState(trip, state: .rejectedByDriver, completion: completion)
    }
    
    func didArriveAtPickupLocation(completion: FirestoreCompletion) {
        guard let trip = trip else { return }
        updateTripState(trip, state: .driverArrived, completion: completion)
    }
}

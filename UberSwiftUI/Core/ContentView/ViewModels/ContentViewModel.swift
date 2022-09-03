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

/*
 ContentViewModel and AuthViewModel need user object.
 Currently running two API calls in each class to get user data
 Need to figure out a way to either combine both view models into 1, or share the user object between them
 Could potentially cache user data??
 
 Ideal solution:
 Create user service
*/

class ContentViewModel: ObservableObject {
    
    @Published var drivers = [User]()
    @Published var trip: Trip?
    @Published var mapState = MapViewState.noInput
    
    let radius: Double = 50 * 1000
    var didExecuteFetchDrivers = false
    
    private var user: User?
    private var driverQueue = [User]()
    var userLocation: CLLocationCoordinate2D?
    var selectedLocation: UberLocation?
    
    init() {
        fetchUser()
    }
    
    func fetchUser() {
        UserService.fetchUser { user in
            self.user = user
            
            switch user.accountType {
            case .driver:
                self.observeTripRequests()
            case .passenger:
                self.addTripObserverForPassenger()
            }
        }
    }
    
    private func updateTripState(_ trip: Trip, state: TripState, completion: ((Error?) -> Void)?) {
        COLLECTION_RIDES.document(trip.tripId).updateData(["tripState": state.rawValue], completion: completion)
    }
}

// MARK: - Driver API

extension ContentViewModel {
    func observeTripRequests() {
        guard let currentUser = self.user, currentUser.accountType == .driver else { return }
        guard let uid = currentUser.id else { return }

        COLLECTION_RIDES.whereField("driverUid", isEqualTo: uid).addSnapshotListener { snapshot, error in
            guard let change = snapshot?.documentChanges.first, change.type == .added else { return }
            guard let trip = try? change.document.data(as: Trip.self) else { return }
            self.trip = trip

            self.mapState = .tripRequested
        }
    }
    
    func acceptTrip() {
        guard let trip = trip else { return }
        guard let user = user, user.accountType == .driver else { return }
        
        COLLECTION_RIDES
            .document(trip.tripId)
            .updateData(["tripState": MapViewState.tripAccepted.rawValue]) { _ in
                self.mapState = .tripAccepted
        }
    }
    
    func rejectTrip() {
        guard let trip = trip else { return }
        
        updateTripState(trip, state: .rejectedByDriver) { _ in
            self.mapState = .noInput
        }
        
    }
}

// MARK: - Passenger API

extension ContentViewModel {
   private func addTripObserverForPassenger() {
        guard let user = user, user.accountType == .passenger, let uid = user.id else { return }
        
        COLLECTION_RIDES.whereField("passengerUid", isEqualTo: uid).addSnapshotListener { snapshot, error in
            guard let change = snapshot?.documentChanges.first, change.type == .added || change.type == .modified else { return }
            switch change.type {
            case .added, .modified:
                guard let trip = try? change.document.data(as: Trip.self) else { return }
                self.trip = trip
                
                if trip.tripState == .rejectedByDriver {
                    self.requestRide()
                }
                
                if trip.tripState == .accepted {
                    self.mapState = .tripAccepted
                }
            case .removed:
                print("DEBUG: Trip rejected by driver, send next request..")
            }
        }
    }
    
    func requestRide() {
        if driverQueue.isEmpty {
            guard let trip = trip else { return }
            updateTripState(trip, state: .rejectedByAllDrivers) { _ in
                self.mapState = .noInput
            }
            
            return
        }
        
        let driver = driverQueue.removeFirst()
        sendRideRequestToDriver(driver)
    }
    
    private func sendRideRequestToDriver(_ driver: User) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let driverUid = driver.id else { return }
        guard let userLocation = userLocation, let selectedLocation = selectedLocation else { return }
        
        if let trip = trip {
            let updatedData: [String: Any] = [
                "tripState": TripState.requested.rawValue,
                "driverUid": driver.id ?? ""
            ]
            COLLECTION_RIDES.document(trip.tripId).updateData(updatedData) { _ in
                print("DEBUG: Updated trip data..")
            }
        } else {
            let pickupGeoPoint = GeoPoint(latitude: userLocation.latitude, longitude: userLocation.longitude)
            let dropoffGeoPoint = GeoPoint(latitude: selectedLocation.coordinate.latitude, longitude: selectedLocation.coordinate.longitude)
            
            let data: [String: Any] = [
                "driverUid": driverUid,
                "passengerUid": currentUid,
                "pickupLocation": pickupGeoPoint,
                "dropoffLocation": dropoffGeoPoint,
                "tripCost": 0.0,
                "dropoffLocationName": selectedLocation.title,
                "tripState": MapViewState.tripRequested.rawValue
            ]
            
            COLLECTION_RIDES.document().setData(data) { _ in
                self.mapState = .tripRequested
            }
        }
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
    
    private func getDocumentsCompletion(snapshot: QuerySnapshot?, error: Error?) -> () {
        guard let documents = snapshot?.documents else { return }
        guard let userLocation = userLocation else { return }
        var drivers = [User]()
        
        documents.forEach { doc in
            guard let driver = try? doc.data(as: User.self), driver.accountType == .driver else { return }
            let coordinates = CLLocation(latitude: driver.coordinates.latitude, longitude: driver.coordinates.longitude)
            let centerPoint = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
            
            let distance = GFUtils.distance(from: centerPoint, to: coordinates)
            
            if distance <= radius {
                drivers.append(driver)
            }
        }
        
        self.drivers.append(contentsOf: drivers)
        self.driverQueue = self.drivers
        print("DEBUG: Drivers array \(self.drivers)")
    }
}

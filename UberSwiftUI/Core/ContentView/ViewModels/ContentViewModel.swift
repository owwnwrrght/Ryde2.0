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
    
    // MARK: - Properties
    
    @Published var drivers = [User]()
    @Published var trip: Trip?
    @Published var mapState = MapViewState.noInput
    
    let radius: Double = 50 * 1000
    var didExecuteFetchDrivers = false
    var userLocation: CLLocationCoordinate2D?
    var selectedLocation: UberLocation?
    
    private var user: User?
    private var driverQueue = [User]()
    private var tripService = TripService()

    // MARK: - Lifecycle
    
    init() {
        fetchUser()
    }
    
    // MARK: - Helpers
        
    private func reset() {
        self.mapState = .noInput
        self.selectedLocation = nil
        self.trip = nil
    }
    
    func getPlacemark(forLocation location: CLLocation, completion: @escaping (CLPlacemark?, Error?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { placemarks, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let placemark = placemarks?.first else { return }
            completion(placemark, nil)
        })
    }
    
    func createPickupAndDropoffRegionsForTrip() {
        guard let trip = trip else { return }
        LocationManager.shared.createPickupRegionForTrip(trip)
        LocationManager.shared.createDropoffRegionForTrip(trip)
    }
}

// MARK: - Shared API

extension ContentViewModel {
    private func fetchUser() {
        UserService.fetchUser { user in
            self.user = user
            self.tripService.user = user
            
            switch user.accountType {
            case .driver:
                self.addTripObserverForDriver()
            case .passenger:
                self.addTripObserverForPassenger()
            }
        }
    }
    
    private func updateTripState(_ trip: Trip, state: TripState, completion: ((Error?) -> Void)?) {
        COLLECTION_RIDES.document(trip.tripId).updateData(["tripState": state.rawValue], completion: completion)
    }
    
    private func deleteTrip() {
        guard let trip = trip else { return }
        
        COLLECTION_RIDES.document(trip.tripId).delete { _ in
            self.reset()
        }
    }
}

// MARK: - Driver API

extension ContentViewModel {
    func addTripObserverForDriver() {
        tripService.addTripObserverForDriver { snapshot, error in
            guard let change = snapshot?.documentChanges.first else { return }
            guard let trip = try? change.document.data(as: Trip.self) else { return }
            self.trip = trip
            self.tripService.trip = trip
            
            switch change.type {
            case .added, .modified:
                if trip.tripState == .requested {
                    self.mapState = .tripRequested
                } else if trip.tripState == .cancelled {
                    self.mapState = .tripCancelled
                    self.deleteTrip()
                }
                
            case .removed:
                self.mapState = .tripCancelled
            }
        }
    }
    
    func acceptTrip() {
        guard let trip = trip else { return }
        self.selectedLocation = UberLocation(title: trip.dropoffLocationName, coordinate: trip.dropoffLocationCoordinates)
        
        tripService.acceptTrip { _ in
            self.createPickupAndDropoffRegionsForTrip()
            self.mapState = .tripAccepted
        }
    }
    
    func rejectTrip() {
        tripService.rejectTrip { _ in
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
                self.tripService.trip = trip
                
                if self.selectedLocation == nil {
                    self.selectedLocation = UberLocation(title: trip.dropoffLocationName, coordinate: trip.dropoffLocationCoordinates)
                }
                
                if trip.tripState == .rejectedByDriver {
                    self.requestRide()
                } else if trip.tripState == .accepted {
                    self.createPickupAndDropoffRegionsForTrip()
                    self.mapState = .tripAccepted
                    
                }
            case .removed:
                print("DEBUG: Trip cancelled by passenger, send next request..")
            }
        }
    }
    
    func requestRide() {
        if driverQueue.isEmpty {
            guard let trip = trip else { return }
            updateTripState(trip, state: .rejectedByAllDrivers) { _ in
                self.deleteTrip()
            }
        } else {
            let driver = driverQueue.removeFirst()
            sendRideRequestToDriver(driver)
        }
    }
    
    func cancelTrip() {
        guard let trip = trip else { return }
        
        updateTripState(trip, state: .cancelled) { _ in
            self.reset()
        }
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
            
            getPlacemark(forLocation: CLLocation(latitude: pickupGeoPoint.latitude, longitude: pickupGeoPoint.longitude)) { placemark, error in
                let data: [String: Any] = [
                    "driverUid": driverUid,
                    "passengerUid": currentUid,
                    "pickupLocation": pickupGeoPoint,
                    "dropoffLocation": dropoffGeoPoint,
                    "tripCost": 0.0,
                    "dropoffLocationName": selectedLocation.title,
                    "pickupLocationName": placemark?.name ?? "Current location",
                    "tripState": TripState.requested.rawValue
                ]
                
                COLLECTION_RIDES.document().setData(data) { _ in
                    self.mapState = .tripRequested
                }
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
    }
}

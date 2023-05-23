//
//  LocationSearchViewModel.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 11/21/21.
//

import Foundation
import MapKit
import Firebase

enum LocationStatus: Equatable {
    case idle
    case noResults
    case isSearching
    case error(String)
    case result
}

class LocationSearchViewModel: NSObject, ObservableObject {
    
    // MARK: - Properties 
    
    @Published private(set) var searchResults = [MKLocalSearchCompletion]()
    @Published var selectedLocation: MKLocalSearchCompletion?
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40.759211,  longitude: -73.984638),
                                               span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
    private let searchCompleter = MKLocalSearchCompleter()
    
    var queryFragment: String = "" {
        didSet {
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    // MARK: - Lifecycle
    
    
    override init() {
        super.init()
        self.searchCompleter.delegate = self
        self.searchCompleter.queryFragment = queryFragment
    }
    
    // MARK: - Helpers
    
    func selectLocation(location: MKLocalSearchCompletion, forConfig config: LocationResultsViewConfig) {
        switch config {
        case .savedLocations(let option):
            uploadSavedLocation(location: location, forOption: option)
        case .ride:
            self.selectedLocation = location
        }
    }
    
    func clearMapView() {
        self.selectedLocation = nil
    }
    
    func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion,
                        completion: @escaping MKLocalSearch.CompletionHandler) {
        
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        let search = MKLocalSearch(request: searchRequest)
        
        search.start(completionHandler: completion)
        
    }
}

// MARK: - API

extension LocationSearchViewModel {
    func uploadSavedLocation(location: MKLocalSearchCompletion, forOption option: SavedLocationOptions) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        self.locationSearch(forLocalSearchCompletion: location) { response, error in
            guard let item = response?.mapItems.first else { return }
            
            let coordinate = item.placemark.coordinate
            let title = location.title
            let address = location.subtitle
            
            let data: [String: Any] = ["title": title,
                                       "address": address,
                                       "latitude": coordinate.latitude,
                                       "longitude": coordinate.longitude] as [String : Any]
            
            COLLECTION_USERS.document(uid).updateData([option.databaseKey: data])
        }
    }
}

// MARK: - MKLocalSearchCompleterDelegate


extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.searchResults = completer.results
//        self.status = completer.results.isEmpty ? .noResults : .result
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
//        self.status = .error(error.localizedDescription)
    }
}

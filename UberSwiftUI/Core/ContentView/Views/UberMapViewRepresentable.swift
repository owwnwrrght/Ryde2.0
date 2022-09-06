//
//  UberMapView.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 11/12/21.
//

import MapKit
import SwiftUI
import GeoFireUtils
import Firebase

struct UberMapViewRepresentable: UIViewRepresentable {
    
    // MARK: - Properties
    
    @Binding var mapState: MapViewState
    @EnvironmentObject var contentViewModel: ContentViewModel
    @EnvironmentObject var viewModel: LocationSearchViewModel
    
    let mapView = MKMapView()
    
    // MARK: - Lifecycle
    
    init(mapState: Binding<MapViewState>) {
        self._mapState = mapState
    }
    
    func makeUIView(context: Context) -> some UIView {
        mapView.isRotateEnabled = false
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: "driver")
                
        return mapView
    }
        
    func updateUIView(_ uiView: UIViewType, context: Context) {
//        print("DEBUG: Updating view...")
        //FIXME: Use map state to prevent updates when trip state is updated
        
        if mapState == .locationSelected {
            context.coordinator.addAnnotationAndGeneratePolyline()
            return
        }
        
        if !contentViewModel.drivers.isEmpty && mapState == .noInput {
            context.coordinator.addDriversToMap(contentViewModel.drivers)
        }
                
        if mapState == .noInput {
            context.coordinator.clearMapView()
            return
        }
    }
    
    func makeCoordinator() -> MapCoordinator {
        .init(parent: self)
    }
}

extension UberMapViewRepresentable {

    class MapCoordinator: NSObject, MKMapViewDelegate {
        let parent: UberMapViewRepresentable
        var currentRegion: MKCoordinateRegion?
        var userLocation: MKUserLocation?
        
        private var drivers = [User]()
        
        // MARK: - Lifecycle
        
        init(parent: UberMapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        // MARK: - MKMapViewDelegate
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            // this will cause mapview to constantly center if user is changing location
            self.userLocation = userLocation
            let region = MKCoordinateRegion(
                center: userLocation.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
            self.currentRegion = region
            
            parent.mapView.setRegion(region, animated: true)
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let over = MKPolylineRenderer(overlay: overlay)
            over.strokeColor = .systemBlue
            over.lineWidth = 6
            return over
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
            
            if let annotation = annotation as? DriverAnnotation {
                let view = MKAnnotationView(annotation: annotation, reuseIdentifier: "driver")
                view.image = UIImage(named: "chevron-sign-to-right")
                return view
            }
            
            return nil
        }
        
        // MARK: - Helpers
        
        func configurePolyline() {
            guard let destinationCoordinate = parent.viewModel.selectedUberLocation?.coordinate else { return }

            self.parent.contentViewModel.getDestinationRoute(destinationCoordinate) { route in
                self.parent.mapState = .polylineAdded
                self.parent.mapView.addOverlay(route.polyline)
                let rect = self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect,
                                                               edgePadding: .init(top: 64, left: 32, bottom: 500, right: 32))
                self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            }
        }
        
        func generatePolyline(forPlacemark placemark: MKPlacemark) {
            guard let userLocation = self.userLocation else { return }
            let userPlacemark = MKPlacemark(coordinate: userLocation.coordinate)
            
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: userPlacemark)
            request.destination = MKMapItem(placemark: placemark)
            
            let directions = MKDirections(request: request)
            
            directions.calculate { response, err in
                if let err = err {
                    print("DEBUG: Failed to generate polyline with error \(err.localizedDescription)")
                    return
                }
                
                guard let route = response?.routes.first else { return }
                
                let expectedTravelTimeInSeconds = route.expectedTravelTime
                self.configurePickupAndDropOffTime(with: expectedTravelTimeInSeconds)
                
                self.parent.mapView.addOverlay(route.polyline)
                let rect = self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect,
                                                               edgePadding: .init(top: 64, left: 32, bottom: 500, right: 32))
                self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            }
        }
        
        func configurePickupAndDropOffTime(with expectedTravelTime: Double) {
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a"
            
            self.parent.contentViewModel.pickupTime = formatter.string(from: Date())
            self.parent.contentViewModel.dropOffTime = formatter.string(from: Date() + expectedTravelTime)
        }
        
        func addAnnotationAndGeneratePolyline() {
            guard let destinationCoordinate = parent.viewModel.selectedUberLocation?.coordinate else { return }
            self.parent.mapView.removeAnnotations(parent.mapView.annotations)
            let anno = MKPointAnnotation()
            anno.coordinate = destinationCoordinate
//            let placemark = MKPlacemark(coordinate: destinationCoordinate)
            
            self.parent.mapView.addAnnotation(anno)
            self.parent.mapView.selectAnnotation(anno, animated: true)
            
            self.configurePolyline()
        }
        
        func clearMapView() {
            let annotations = parent.mapView.annotations.filter({ !$0.isKind(of: DriverAnnotation.self) })
            parent.mapView.removeAnnotations(annotations)
            parent.mapView.removeOverlays(parent.mapView.overlays)
            
            if let currentRegion = currentRegion {
                parent.mapView.setRegion(currentRegion, animated: true)
            }
        }
        
        func addDriversToMap(_ drivers: [User]) {
            let driverAnnotations = drivers.map({
                DriverAnnotation(
                    uid: $0.id ?? NSUUID().uuidString,
                    coordinate: CLLocationCoordinate2D(latitude: $0.coordinates.latitude,longitude: $0.coordinates.longitude)
                )
            })
                        
            self.parent.mapView.addAnnotations(driverAnnotations)
        }
    }
}

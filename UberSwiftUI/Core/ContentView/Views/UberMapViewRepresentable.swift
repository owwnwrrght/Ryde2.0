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
        mapView.register(DriverAnnotation.self, forAnnotationViewWithReuseIdentifier: "driver")
                
        return mapView
    }
        
    func updateUIView(_ uiView: UIViewType, context: Context) {
        guard let user = contentViewModel.user else { return }
                
        if mapState == .locationSelected && user.accountType == .passenger {
            context.coordinator.addAnnotationAndGeneratePolyline()
            return
        }
        
        if mapState == .tripAccepted && user.accountType == .driver {
            context.coordinator.addAnnotationAndGeneratePolylineToPassenger()
            return
        }
        
        if mapState == .tripAccepted, let trip = contentViewModel.trip, user.accountType == .passenger {
            context.coordinator.configureMapForTrip(trip)
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
        var mapViewNeedsPadding = false
        
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
        
        func configurePolyline(withDestinationCoordinate coordinate: CLLocationCoordinate2D) {
            guard let userLocation = self.userLocation else { return }
            
            self.parent.contentViewModel.getDestinationRoute(from: userLocation.coordinate, to: coordinate) { route in
                self.parent.mapState = .polylineAdded
                self.parent.mapView.addOverlay(route.polyline)
                let rect = self.parent.mapView.mapRectThatFits(route.polyline.boundingMapRect,
                                                               edgePadding: .init(top: 64, left: 32, bottom: 500, right: 32))
                self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            }
        }
        
        func configureMapForTrip(_ trip: Trip) {
            let annotations = parent.mapView.annotations.filter({ !$0.isKind(of: DriverAnnotation.self) })
            let driverAnnotations = parent.mapView.annotations.filter({ $0.isKind(of: DriverAnnotation.self) }) as! [DriverAnnotation]
            
            parent.mapView.removeAnnotations(annotations)
            parent.mapView.removeOverlays(parent.mapView.overlays)
            
            driverAnnotations.forEach { driverAnno in
                if driverAnno.uid != trip.driverUid {
                    self.parent.mapView.removeAnnotation(driverAnno)
                }
            }
            
            parent.mapView.showAnnotations(parent.mapView.annotations, animated: false)
            parent.mapView.setVisibleMapRect(parent.mapView.visibleMapRect,
                                             edgePadding: .init(top: 64, left: 32, bottom: 360, right: 32),
                                             animated: true)
        }
        
        func addAnnotationAndGeneratePolyline() {
            guard let destinationCoordinate = parent.viewModel.selectedUberLocation?.coordinate else { return }
            let annotations = parent.mapView.annotations.filter({ !$0.isKind(of: DriverAnnotation.self) })
            self.parent.mapView.removeAnnotations(annotations)
            addAndSelectAnnotation(withCoordinate: destinationCoordinate)
            
            self.configurePolyline(withDestinationCoordinate: destinationCoordinate)
        }
        
        func addAnnotationAndGeneratePolylineToPassenger() {
            guard let trip = parent.contentViewModel.trip else { return }
            self.parent.mapView.removeAnnotations(parent.mapView.annotations)
            addAndSelectAnnotation(withCoordinate: trip.pickupLocationCoordiantes)
            
            self.configurePolyline(withDestinationCoordinate: trip.pickupLocationCoordiantes)
        }
        
        func addAndSelectAnnotation(withCoordinate coordinate: CLLocationCoordinate2D) {
            let anno = MKPointAnnotation()
            anno.coordinate = coordinate
            
            self.parent.mapView.addAnnotation(anno)
            self.parent.mapView.selectAnnotation(anno, animated: true)
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

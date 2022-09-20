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
            context.coordinator.updateDriverPositionForTrip(trip)
            context.coordinator.configureMapForTrip(trip)
            return
        }
                
        if mapState == .noInput {
            context.coordinator.clearMapView()
            context.coordinator.addDriversToMapAndUpdateLocation(contentViewModel.drivers)
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
        var didSetVisibleMapRectForTrip = false
        
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
            
            if let user = parent.contentViewModel.user, user.accountType == .driver {
                parent.contentViewModel.updateDriverLocation(withCoordinate: userLocation.coordinate)
            }
            
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
            if !didSetVisibleMapRectForTrip {
                let annotations = parent.mapView.annotations.filter({ !$0.isKind(of: DriverAnnotation.self) })
                let driverAnnotations = parent.mapView.annotations.filter({ $0.isKind(of: DriverAnnotation.self) }) as! [DriverAnnotation]
                
                parent.mapView.removeAnnotations(annotations)
                parent.mapView.removeOverlays(parent.mapView.overlays)
                
                driverAnnotations.forEach { driverAnno in
                    if driverAnno.uid != trip.driverUid {
                        self.parent.mapView.removeAnnotation(driverAnno)
                    }
                }
            }
            
            parent.mapView.showAnnotations(parent.mapView.annotations, animated: false)
            parent.mapView.setVisibleMapRect(parent.mapView.visibleMapRect,
                                             edgePadding: .init(top: 64, left: 32, bottom: 360, right: 32) ,
                                             animated: !didSetVisibleMapRectForTrip)

            didSetVisibleMapRectForTrip = true
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
            didSetVisibleMapRectForTrip = false
            let annotations = parent.mapView.annotations.filter({ !$0.isKind(of: DriverAnnotation.self) })
            guard !parent.mapView.overlays.isEmpty, !annotations.isEmpty else { return }
            
            parent.mapView.removeAnnotations(annotations)
            parent.mapView.removeOverlays(parent.mapView.overlays)
            
            if let currentRegion = currentRegion {
                parent.mapView.setRegion(currentRegion, animated: true)
            }
        }
        
        func addDriversToMapAndUpdateLocation(_ drivers: [User]) {
            drivers.forEach { driver in
                let driverCoordinate = CLLocationCoordinate2D(latitude: driver.coordinates.latitude,longitude: driver.coordinates.longitude)
                let annotation = DriverAnnotation( uid: driver.id ?? NSUUID().uuidString, coordinate: driverCoordinate)
                
                var driverIsVisible: Bool {
                    return self.parent.mapView.annotations.contains(where: { annotation -> Bool in
                        guard let driverAnno = annotation as? DriverAnnotation else { return false }
                        if driverAnno.uid == driver.id ?? "" {
                            driverAnno.updatePosition(withCoordinate: driverCoordinate)
                            return true
                        }
                        return false
                    })
                }
                
                if !driverIsVisible{
                    self.parent.mapView.addAnnotation(annotation)
                }
            }
        }
        
        func updateDriverPositionForTrip(_ trip: Trip) {
            guard let tripDriver = parent.contentViewModel.drivers.first(where: { $0.uid == trip.driverUid }) else { return }
            let driverAnnotations = parent.mapView.annotations.filter({ $0.isKind(of: DriverAnnotation.self) }) as? [DriverAnnotation]
            guard let driverAnno = driverAnnotations?.first(where: { $0.uid == trip.driverUid }) else { return }
            let driverCoordinates = CLLocationCoordinate2D(latitude: tripDriver.coordinates.latitude,longitude: tripDriver.coordinates.longitude)
            
            driverAnno.updatePosition(withCoordinate: driverCoordinates)

        }
    }
}

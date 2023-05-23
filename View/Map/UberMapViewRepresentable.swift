//
//  UberMapView.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 11/12/21.
//

import MapKit
import SwiftUI

struct UberMapViewRepresentable: UIViewRepresentable {
    
    // MARK: - Properties
    
    @Binding var region: MKCoordinateRegion
    @Binding var mapState: MapViewState
    @EnvironmentObject var viewModel: LocationSearchViewModel
        
    let mapView = MKMapView()
    
    init(region: Binding<MKCoordinateRegion>, mapState: Binding<MapViewState>) {
        self._region = region
        self._mapState = mapState
    }
    
    func makeUIView(context: Context) -> some UIView {
        mapView.setRegion(region, animated: true)
        mapView.isRotateEnabled = false
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
                        
        return mapView
    }
        
    func updateUIView(_ uiView: UIViewType, context: Context) {        
        if let selectedLocation = viewModel.selectedLocation {
            context.coordinator.addAnnotationAndGeneratePolyline(forSearchResult: selectedLocation)
        }
                
        if mapState == .noInput {
            context.coordinator.clearMapView()
        }
    }
    
    func makeCoordinator() -> MapCoordinator {
        .init(parent: self)
    }
}

extension UberMapViewRepresentable {

    class MapCoordinator: NSObject, MKMapViewDelegate {
        let parent: UberMapViewRepresentable
        var driverAnno: DriverAnnotation!
        
        // MARK: - Lifecycle
        
        init(parent: UberMapViewRepresentable) {
            self.parent = parent
            super.init()
            
            addDriversToMap()

            let tap = UITapGestureRecognizer(target: self, action: #selector(moveDriverLocation))
            parent.mapView.addGestureRecognizer(tap)
        }
        
        // MARK: - MKMapViewDelegate
        
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let over = MKPolylineRenderer(overlay: overlay)
            over.strokeColor = .systemBlue
            over.lineWidth = 6
            return over
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if let annotation = annotation as? DriverAnnotation {
                let view = MKAnnotationView(annotation: annotation, reuseIdentifier: "driver")
                view.image = UIImage(named: "chevron-sign-to-right")
                return view
            }
            
            return nil
        }
        
        // MARK: - Helpers
        
        @objc func moveDriverLocation() {
            print("DEBUG: Driver coordinate is \(driverAnno.coordinate)")
            let newLat = driverAnno.coordinate.latitude + 0.002
            let newLong = driverAnno.coordinate.longitude + 0.002

            driverAnno.updatePosition(withCoordinate: CLLocationCoordinate2D(latitude: newLat, longitude: newLong))
        }
        
        func addDriversToMap() {
            self.driverAnno = DriverAnnotation(uid: NSUUID().uuidString,
                                               coordinate: CLLocationCoordinate2D(latitude: 40.755,  longitude: -73.97))
            parent.mapView.addAnnotation(driverAnno)
        }

        func generatePolyline(forPlacemark placemark: MKPlacemark) {
            guard let userLocation = LocationManager.shared.userLocation else { return }
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
                
                guard let polyline = response?.routes.first?.polyline else { return }
                
                self.parent.mapView.addOverlay(polyline)
                let rect = self.parent.mapView.mapRectThatFits(polyline.boundingMapRect,
                                                               edgePadding: .init(top: 64, left: 32, bottom: 500, right: 32))
                self.parent.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            }
        }
        
        func addAnnotationAndGeneratePolyline(forSearchResult result: MKLocalSearchCompletion) {
            self.parent.mapView.removeAnnotations(parent.mapView.annotations)
            
            parent.viewModel.locationSearch(forLocalSearchCompletion: result) { response, error in
                guard let item = response?.mapItems.first else { return }
                let anno = MKPointAnnotation()
                anno.coordinate = item.placemark.coordinate
                
                self.parent.mapView.addAnnotation(anno)
                self.parent.mapView.selectAnnotation(anno, animated: true)
                
                self.generatePolyline(forPlacemark: item.placemark)
            }
        }
        
        func clearMapView() {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            parent.mapView.removeOverlays(parent.mapView.overlays)
            parent.mapView.setRegion(parent.viewModel.region, animated: true)
        }
    }
}

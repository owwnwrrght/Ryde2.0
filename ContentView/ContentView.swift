//
//  ContentView.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 11/12/21.
//

import SwiftUI
import MapKit

enum MapViewState {
    case noInput
    case searchingForLocation
    case locationSelected
    case tripAccepted
    case transitioning
}

struct ContentView: View {
    private let viewModel = MapViewModel()
    @State private var showLocationInputView = false
    @State private var showSideMenu = false
    @State private var mapState = MapViewState.noInput
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @Namespace var animation
    
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40.759211,  longitude: -73.984638),
                                           span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
    var body: some View {
        Group {
            if authViewModel.userSession == nil {
                LoginView()
            } else {
                NavigationView {
                    ZStack {
                        if showSideMenu {
                            if let user = authViewModel.user {
                                SideMenuView(isShowing: $showSideMenu, user: user)
                            }
                        }
                        
                        ZStack(alignment: .bottom) {
                            ZStack(alignment: .top) {
                                UberMapViewRepresentable(region: $region, mapState: $mapState)
                                
                                if mapState == .noInput {
                                    LocationInputActivationView(animation: animation)
                                        .matchedGeometryEffect(id: "LocationInput", in: animation)
                                        .onTapGesture {
                                            withAnimation(.spring()) {
                                                self.mapState = .searchingForLocation
                                            }
                                        }
                                } else if mapState == .searchingForLocation {
                                    RideLocationInputView(show: $showLocationInputView, animation: animation)
                                }
                                
                                MapViewActionButton(state: mapState, action: {
                                    withAnimation(.spring()) {
                                        actionForState(state: mapState)
                                    }
                                })
                            }
                            
                            if mapState == .locationSelected {
                                BookingView()
                                    .transition(.move(edge: .bottom))
                            }
                        }
//                        .cornerRadius(showSideMenu ? 20 : 10)
//                        .offset(x: showSideMenu ? 300 : 0, y: showSideMenu ? 44 : 0)
                        .offset(x: showSideMenu ? 300 : 0, y: 0)
//                        .scaleEffect(showSideMenu ? 0.8 : 1)
                        .onReceive(locationViewModel.$selectedLocation, perform: { location in
                            if location != nil {
                                self.mapState = .transitioning
                                
                                DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
                                    self.mapState = .locationSelected
                                }
                            }
                        })
                        .ignoresSafeArea()
                    }
                    .onAppear(perform: {
                        self.showSideMenu = false
                    })
                    .navigationBarHidden(true)
                }
            }
        }
    }
    
    func actionForState(state: MapViewState) {
        switch state {
        case .noInput:
            showSideMenu.toggle()
        case .searchingForLocation:
            mapState = .noInput
        case .locationSelected:
            mapState = .noInput
            locationViewModel.clearMapView()
        default: break
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



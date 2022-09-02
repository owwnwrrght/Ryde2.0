//
//  ContentView.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 11/12/21.
//

import SwiftUI
import MapKit

enum MapViewState: Int {
    case noInput
    case searchingForLocation
    case locationSelected
    case tripRequested
    case tripAccepted
    case transitioning
}

struct ContentView: View {
    @State private var showLocationInputView = false
    @State private var showSideMenu = false
    @State private var mapState = MapViewState.noInput
    @State private var userLocation: CLLocation?
    @Namespace var animation
    
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var contentViewModel: ContentViewModel
            
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
                                UberMapViewRepresentable(mapState: $mapState)
                                
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
                            
                            if mapState == .locationSelected,
                               let location = locationViewModel.selectedUberLocation,
                               let userLocation = userLocation {
                                BookingView(userLocation: userLocation,
                                            selectedLocation: location,
                                            nearbyDrivers: contentViewModel.drivers,
                                            mapState: $mapState)
                                .transition(.move(edge: .bottom))
                            } else if mapState == .tripRequested {
                                withAnimation(.spring()) {
                                    TripLoadingView()
                                        .transition(.move(edge: .bottom))
                                }
                            } else if mapState == .tripAccepted {
                                TripInProgressView()
                                    .transition(.move(edge: .bottom))
                            }
                        }
                        .offset(x: showSideMenu ? 300 : 0, y: 0)
                        .onReceive(locationViewModel.$selectedLocation, perform: { location in
                            if location != nil {
                                self.mapState = .transitioning
                                
                                DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
                                    self.mapState = .locationSelected
                                }
                            }
                        })
                        .onReceive(LocationManager.shared.$userLocation, perform: { userLocation in
                            self.userLocation = userLocation
                            guard let userLocation = userLocation, !contentViewModel.didExecuteFetchDrivers else { return }
                            contentViewModel.fetchNearbyDrivers(withCoordinates: userLocation.coordinate)
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
            locationViewModel.selectedLocation = nil
        case .tripRequested:
            mapState = .noInput
            locationViewModel.selectedLocation = nil
        default: break
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthViewModel(window: UIWindow()))
    }
}



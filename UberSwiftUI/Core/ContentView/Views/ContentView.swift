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
    case driverArrived
    case tripInProgress
    case arrivedAtDestination
    case tripCompleted
    case tripCancelled
}

struct ContentView: View {
    @State private var showLocationInputView = false
    @State private var showSideMenu = false
    @State private var userLocation: CLLocation?
    @Namespace var animation
    
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var contentViewModel: ContentViewModel
            
    var body: some View {
        Group {
            if authViewModel.userSession == nil {
                LoginView()
            } else if let user = authViewModel.user {
                NavigationView {
                    ZStack {
                        if showSideMenu {
                            SideMenuView(isShowing: $showSideMenu, user: user)
                        }
                        
                        ZStack(alignment: .bottom) {
                            ZStack(alignment: .top) {
                                UberMapViewRepresentable(mapState: $contentViewModel.mapState)
                                
                                if contentViewModel.mapState == .noInput {
                                    LocationInputActivationView(animation: animation)
                                        .matchedGeometryEffect(id: "LocationInput", in: animation)
                                        .onTapGesture {
                                            withAnimation(.spring()) {
                                                self.contentViewModel.mapState = .searchingForLocation
                                            }
                                        }
                                } else if contentViewModel.mapState == .searchingForLocation {
                                    RideLocationInputView(show: $showLocationInputView, animation: animation)
                                }
                                
                                MapViewActionButton(state: $contentViewModel.mapState, showSideMenu: $showSideMenu)
                            }
                            
                            if let userLocation = userLocation {
                                if contentViewModel.mapState == .locationSelected, let location = locationViewModel.selectedUberLocation {
                                    BookingView(userLocation: userLocation, selectedLocation: location)
                                        .transition(.move(edge: .bottom))
                                } else if contentViewModel.mapState == .tripRequested {
                                    if user.accountType == .passenger {
                                        withAnimation(.spring()) {
                                            TripLoadingView()
                                                .transition(.move(edge: .bottom))
                                        }
                                    } else {
                                        if let trip = contentViewModel.trip {
                                            withAnimation(.spring()) {
                                                AcceptTripView(trip: trip)
                                                    .transition(.move(edge: .bottom))
                                            }
                                        }
                                        
                                    }
                                } else if contentViewModel.mapState == .tripAccepted, let trip = contentViewModel.trip {
                                    TripInProgressView(
                                        viewModel: RideDetailsViewModel(userLocation: userLocation,
                                                                        selectedLocation: trip.dropoffUberLocation)
                                    )
                                        .transition(.move(edge: .bottom))
                                } else if contentViewModel.mapState == .driverArrived, let trip = contentViewModel.trip {
                                    if user.accountType == .passenger {
                                        withAnimation(.spring()) {
                                            DriverArrivalView(viewModel: RideDetailsViewModel(userLocation: userLocation,
                                                                                              selectedLocation: trip.dropoffUberLocation))
                                                .transition(.move(edge: .bottom))
                                        }
                                    } else {
                                        withAnimation(.spring()) {
                                            PickupPassengerView(viewModel: RideDetailsViewModel(userLocation: userLocation,
                                                                                                selectedLocation: trip.dropoffUberLocation))
                                                .transition(.move(edge: .bottom))
                                        }
                                    }
                                } else if contentViewModel.mapState == .arrivedAtDestination, let trip = contentViewModel.trip {
                                    TripArrivalView(
                                        viewModel: RideDetailsViewModel(userLocation: userLocation,
                                                                                    selectedLocation: trip.dropoffUberLocation),
                                        user: user
                                    )
                                    .transition(.move(edge: .bottom))
                                }
                            }
                        }
                        .offset(x: showSideMenu ? 300 : 0, y: 0)
                        .onReceive(locationViewModel.$selectedUberLocation, perform: { location in
                            if location != nil {
                                self.contentViewModel.selectedLocation = location
                                self.contentViewModel.mapState = .locationSelected
                            }
                        })
                        .onReceive(LocationManager.shared.$userLocation, perform: { userLocation in
                            self.userLocation = userLocation
                            contentViewModel.userLocation = userLocation?.coordinate
                            guard let userLocation = userLocation, !contentViewModel.didExecuteFetchDrivers else { return }
                            
                            if user.accountType == .passenger {
                                contentViewModel.fetchNearbyDrivers(withCoordinates: userLocation.coordinate)
                            }
                        })
                        .onReceive(LocationManager.shared.$didEnterPickupRegion, perform: { didEnterPickupRegion in
                            if didEnterPickupRegion && user.accountType == .driver {
                                contentViewModel.updateTripStateToArrived()
                            }
                        })
                        .onReceive(LocationManager.shared.$didEnterDropoffRegion, perform: { didEnterDropoffRegion in
                            if didEnterDropoffRegion {
                                print("DEBUG: Did enter dropoff region")
                                contentViewModel.updateTripStateToDropoff()
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthViewModel(window: UIWindow()))
    }
}

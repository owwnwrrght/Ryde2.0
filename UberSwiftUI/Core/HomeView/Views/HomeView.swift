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
    case polylineAdded
}

struct HomeView: View {
    @State private var showLocationInputView = false
    @State private var showSideMenu = false
    @State private var userLocation: CLLocation?
    @Namespace var animation
    
    @EnvironmentObject var locationViewModel: LocationSearchViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
            
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
                                UberMapViewRepresentable(mapState: $homeViewModel.mapState)
                                
                                if homeViewModel.mapState == .noInput && user.accountType == .passenger {
                                    LocationInputActivationView()
                                        .onTapGesture {
                                            withAnimation(.spring()) {
                                                self.homeViewModel.mapState = .searchingForLocation
                                            }
                                        }
                                } else if homeViewModel.mapState == .searchingForLocation {
                                    RideLocationInputView(show: $showLocationInputView, animation: animation)
                                }
                                
                                MapViewActionButton(state: $homeViewModel.mapState, showSideMenu: $showSideMenu)
                            }
                            
                            if let view = homeViewModel.viewForState(user: user) {
                                withAnimation(.spring()) {
                                    view
                                        .transition(.move(edge: .bottom))
                                }
                            }
                        }
                        .offset(x: showSideMenu ? 316 : 0, y: 0)
                        .shadow(color: showSideMenu ? .black : .clear, radius: 10, x: 0, y: 0)
                        .onReceive(locationViewModel.$selectedUberLocation, perform: { location in
                            if location != nil {
                                self.homeViewModel.selectedLocation = location
                                self.homeViewModel.mapState = .locationSelected
                            }
                        })
                        .onReceive(LocationManager.shared.$userLocation, perform: { userLocation in
                            self.userLocation = userLocation
                            homeViewModel.userLocation = userLocation?.coordinate
                            guard let userLocation = userLocation, !homeViewModel.didExecuteFetchDrivers else { return }
                            
                            if user.accountType == .passenger {
                                homeViewModel.fetchNearbyDrivers(withCoordinates: userLocation.coordinate)
                            }
                        })
                        .onReceive(LocationManager.shared.$didEnterPickupRegion, perform: { didEnterPickupRegion in
                            if didEnterPickupRegion && user.accountType == .driver {
                                homeViewModel.updateTripStateToArrived()
                            }
                        })
                        .onReceive(LocationManager.shared.$didEnterDropoffRegion, perform: { didEnterDropoffRegion in
                            if didEnterDropoffRegion {
                                print("DEBUG: Did enter dropoff region")
                                homeViewModel.updateTripStateToDropoff()
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
        HomeView()
            .environmentObject(AuthViewModel(window: UIWindow()))
    }
}

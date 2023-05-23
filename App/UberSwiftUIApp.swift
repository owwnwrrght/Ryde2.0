//
//  UberSwiftUIApp.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 11/12/21.
//

import SwiftUI
import Firebase
import GoogleSignIn

//@main
//struct UberSwiftUIApp: App {
//
//    @StateObject var locationViewModel = LocationSearchViewModel()
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
//
//    init() {
//        configureAuthentication()
//    }
//
//    var body: some Scene {
//        WindowGroup {
//            LoginView()
//                .environmentObject(locationViewModel)
//        }
//    }
//}

@UIApplicationMain
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

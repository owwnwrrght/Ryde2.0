//
//  UberSwiftUIApp.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 11/12/21.
//

import SwiftUI
import Firebase
import GoogleSignIn

/*
 We use app delegate here instead of SwiftUI methods for Google Sign In capability
 Root view is configured in SceneDelegate
*/

@UIApplicationMain
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

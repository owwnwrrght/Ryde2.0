//
//  AuthViewModel.swift
//  UberSwiftUI
//
//  Created by Stephen Dowless on 11/26/21.
//

import SwiftUI
import GoogleSignIn
import Firebase
import FirebaseFirestoreSwift
import GeoFireUtils

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var isAuthenticating = false
    @Published var error: Error?
    @Published var user: User?
    
    private let window: UIWindow?
        
    init(window: UIWindow?) {
        self.window = window
        userSession = Auth.auth().currentUser
        fetchUser()
    }
    
    func signIn(withEmail email: String, password: String) {
        self.isAuthenticating = true
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to sign in with error: \(error.localizedDescription)")
                self.isAuthenticating = false
                self.error = error
                return
            }
            
            self.isAuthenticating = false
            self.userSession = result?.user
            self.fetchUser()
        }
    }
    
    func createUser(withName name: String, email: String ) -> User? {
        guard let userLocation = LocationManager.shared.userLocation else { return nil }
        
        print("DEBUG: User location is \(userLocation.coordinate)")
        
        let user = User(
            fullname: name,
            email: email,
            accountType: .passenger,
            coordinates: GeoPoint(latitude: userLocation.coordinate.latitude,
                                  longitude: userLocation.coordinate.longitude),
            isActive: false
        )
        
        return user
    }
    
    func registerUser(withEmail email: String, fullname: String, password: String) {
        self.isAuthenticating = true
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to sign in with error: \(error.localizedDescription)")
                self.isAuthenticating = false
                self.error = error
                return
            }
            
            guard let firebaseUser = result?.user else { return }
            guard let user = self.createUser(withName: fullname, email: email) else { return }
                    
            self.userSession = firebaseUser
            self.isAuthenticating = false
            
            self.uploadUserData(withUid: firebaseUser.uid, user: user)
        }
    }
    
    func signInWithGoogle() {
        guard let app = FirebaseApp.app() else { return }
        guard let clientID = app.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        
        guard let rootVC = window?.rootViewController else { return }
                
        GIDSignIn.sharedInstance.signIn(with: config, presenting: rootVC) { user, error in
            self.isAuthenticating = true
            
            if let error = error {
                print("DEBUG: Google sign in failed with error: \(error.localizedDescription)")
                self.isAuthenticating = false
                self.error = error
                return
            }
            
            guard let googleUser = user else { return }
            guard let authToken = googleUser.authentication.idToken else { return }
            let accessToken = googleUser.authentication.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: authToken, accessToken: accessToken)

            guard let profile = googleUser.profile else { return }
            
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    print("DEBUG: Failed to sign in with error: \(error.localizedDescription)")
                    self.isAuthenticating = false
                    self.error = error
                    return
                }
                
                guard let firebaseUser = result?.user else { return }
                self.userSession = firebaseUser

                COLLECTION_USERS.document(firebaseUser.uid).getDocument { snapshot, _ in
                    self.isAuthenticating = false

                    if snapshot == nil {
                        guard let user = self.createUser(withName: profile.name, email: profile.email) else { return }
                        self.uploadUserData(withUid: firebaseUser.uid, user: user)
                    } else {
                        guard let user = try? snapshot?.data(as: User.self) else { return }
                        print("DEBUG: User is \(user)")
                        self.user = user
                    }
                }
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.user = nil
        } catch let error {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    private func uploadUserData(withUid uid: String, user: User) {
        guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }
        
        COLLECTION_USERS.document(uid).setData(encodedUser) { _ in
            self.fetchUser()
        }
    }
    
    func fetchUser() {
        guard let uid = userSession?.uid else { return }
        
        UserService.fetchUser(withUid: uid) { user in
            self.user = user
        }
    }
}

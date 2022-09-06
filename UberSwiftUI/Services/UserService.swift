//
//  UserService.swift
//  UberSwiftUI
//
//  Created by Stephan Dowless on 9/2/22.
//

import Firebase

struct UserService {
    static func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {
        
        COLLECTION_USERS.document(uid).getDocument { snapshot, _ in
            guard let snapshot = snapshot else { return }
            guard let user = try? snapshot.data(as: User.self) else { return }
            
            completion(user)
        }
    }
}

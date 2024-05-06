//
//  SettingsViewModel.swift
//  Eco_Harbour_SwiftUI
//
//  Created by user1 on 18/03/24.
//
import SwiftUI
import Foundation
import FirebaseAuth
import UIKit
import FirebaseFirestore


@MainActor
final class SettingsViewModel:ObservableObject{
    func logout() {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            UserDefaults.standard.removeObject(forKey: "userID")
            
            let isLoggedInSet = UserDefaults.standard.bool(forKey: "isLoggedIn")
            let userIDExists = UserDefaults.standard.string(forKey: "userID") != nil
            
            if !isLoggedInSet || !userIDExists {
                let preLoginView = LoginView()
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = UIHostingController(rootView: preLoginView)
                    window.makeKeyAndVisible()
                }
            } else {
                let loginView = CarouselView()
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = UIHostingController(rootView: loginView)
                    window.makeKeyAndVisible()
                }
            }
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

//
//  ECommerceAppPizzaApp.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 05.06.2023.
//

import SwiftUI
import FirebaseCore
import FirebaseCore
import Firebase
import FirebaseAuth

@main
struct ECommerceAppPizzaApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @AppStorage("FirstLaunch") var firstLaunch: Bool = true
    
    var body: some Scene {
        WindowGroup {
            if firstLaunch {
                OnboardingView {
                    firstLaunch = false
                }
                .preferredColorScheme(.light)
            } else {
                MainPage()
                    .preferredColorScheme(.light)
            }
        }
    }
}



class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}




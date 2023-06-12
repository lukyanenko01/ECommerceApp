//
//  ECommerceAppPizzaApp.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 05.06.2023.
//

import SwiftUI
import FirebaseCore

@main
struct ECommerceAppPizzaApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    
    var body: some Scene {
        WindowGroup {
            MainPage()
                .preferredColorScheme(.light)
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


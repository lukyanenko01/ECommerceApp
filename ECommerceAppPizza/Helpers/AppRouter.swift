//
//  AppRouter.swift
//  ECommerceAppPizza
//
//  Created by Vladimir Lukyanenko on 20.06.2023.
//

import SwiftUI

struct AppRouter {
    static func switchRootView<V: View>(to rootView: V) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = UIHostingController(rootView: rootView)
            window.makeKeyAndVisible()
        }
    }
}

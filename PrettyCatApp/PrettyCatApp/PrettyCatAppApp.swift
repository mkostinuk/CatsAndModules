//
//  PrettyCatAppApp.swift
//  PrettyCatApp
//
//  Created by Max Kostyniuk on 13.05.2026.
//

import SwiftUI
import Firebase
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        CrashlyticsConsents.shared.applySavedConsent()
        CrashLogs.shared.appOpened()
        return true
    }
}

@main
struct PrettyCatAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            CatListView()
        }
    }
}

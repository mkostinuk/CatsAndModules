//
//  CrashLogs.swift
//  PrettyCatApp
//
//  Created by Max Kostyniuk on 25.05.2026.
//
import Foundation
import FirebaseCrashlytics
import Networking
class CrashLogs{
    static let shared = CrashLogs()
    
    private init(){}
    
    func appOpened(){
        Crashlytics.crashlytics().log("app opened")
        Crashlytics.crashlytics().setCustomValue("CatListView", forKey: "current_screen")
    }
    func openedScreen(_ screen: String){
        Crashlytics.crashlytics().log("Screen [\(screen)] opened")

    }
    func reloadStart(){
        Crashlytics.crashlytics().log("user clicked button [GetNew]")
        Crashlytics.crashlytics().setCustomValue("reload_start", forKey: "last_action")
    }
    func loadCats(){
        Crashlytics.crashlytics().log("cats loaded")
        Crashlytics.crashlytics().setCustomValue("cats_loaded", forKey: "last_action")
    }
    func crashTapped(buttonName: String, type: String){
        Crashlytics.crashlytics().log("user clicked button [\(buttonName)] ")
        Crashlytics.crashlytics().setCustomValue(type, forKey: "crash_type")
        Crashlytics.crashlytics().setCustomValue("crash_button_tapped", forKey: "last_action")

    }
}

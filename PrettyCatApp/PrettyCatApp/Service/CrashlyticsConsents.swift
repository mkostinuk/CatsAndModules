//
//  CrashlyticsConsents.swift
//  PrettyCatApp
//
//  Created by Max Kostyniuk on 25.05.2026.
//

import Foundation
import FirebaseCrashlytics

class CrashlyticsConsents{
    static let shared = CrashlyticsConsents()
    private let askedKey = "crahlytics_consents_asked"
    private let allowedKey = "crahlytics_consents_allowed"
    
    private init() {}
    
    var shouldAsk: Bool{ !UserDefaults.standard.bool(forKey: askedKey) }
    
    func saveConsent(isAllowed: Bool){
        UserDefaults.standard.set(true, forKey: askedKey)
        UserDefaults.standard.set(isAllowed, forKey: allowedKey)
        
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(isAllowed)
        Crashlytics.crashlytics().log(isAllowed ? "user allowed crashlytics collections":
                                        "user declined crashlytics collections")
        Crashlytics.crashlytics().setCustomValue(isAllowed, forKey: "crashlytics_consent")
    }
    func applySavedConsent() {
        let wasAsked = UserDefaults.standard.bool(forKey: askedKey)
        if wasAsked {
            let isAllowed = UserDefaults.standard.bool(forKey: allowedKey)
            Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(isAllowed)
        } else {
            Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(false)
        }
        
    }
    
    
}

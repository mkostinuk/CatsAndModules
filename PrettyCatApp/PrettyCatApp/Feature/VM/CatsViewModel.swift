//
//  CatsViewModel.swift
//  PrettyCatApp
//
//  Created by Max Kostyniuk on 13.05.2026.
//

import Foundation
import Networking
import Combine
import FirebasePerformance
import FirebaseCrashlytics
@MainActor
final class CatsViewModel: ObservableObject{
    @Published var dogCats:[CatDog] = []
    
    func loadCats() async{
        let trace = Performance.startTrace(name: "load_cats")
        defer{
            trace?.stop()
        }
        CrashLogs.shared.reloadStart()
        do{
            let type = Bundle.main.object(forInfoDictionaryKey: "AnimalType") as? String ?? "CATS"
            dogCats = try await (type == "DOGS" ? getDogs() : getCats())
            trace?.setValue("success", forAttribute: "result")
            CrashLogs.shared.loadCats()
        } catch{
            trace?.setValue("error", forAttribute: "result")
            Crashlytics.crashlytics().log("Failed to load cats: \(error.localizedDescription)")
            Crashlytics.crashlytics().setCustomValue(error.localizedDescription, forKey: "load_cats_error")
            print(error.localizedDescription)
        }
    }
    
    
}

//
//  ContentView.swift
//  PrettyCatApp
//
//  Created by Max Kostyniuk on 13.05.2026.
//

import SwiftUI
import Networking
import FirebaseCrashlytics

struct CatListView: View {
    @StateObject var viewmodel = CatsViewModel()
    @State private var showCrashlyticsConsentAlert = false
    var body: some View {
        NavigationStack{
            ScrollView{
                ButtonBar()
                Button(){
                    Task {
                        await handleButtonReload()
                    }
                } label: {
                    Text("Get New")
                    Image(systemName: "arrow.triangle.2.circlepath")
                }.foregroundStyle(.mint)
                LazyVStack{
                    ForEach(viewmodel.dogCats){
                        cat in
                        NavigationLink{
                            CatDetailsView(cat: cat)
                        } label: {
                            CatDetailsView(cat: cat)
                        }.buttonStyle(.plain)
                    }
                }
            }
            .task {
                if CrashlyticsConsents.shared.shouldAsk{
                    showCrashlyticsConsentAlert = true
                }
                if viewmodel.dogCats.isEmpty{
                    await viewmodel.loadCats()
                }
            }
            .alert("Crash Reports", isPresented: $showCrashlyticsConsentAlert){
                Button(action: {CrashlyticsConsents.shared.saveConsent(isAllowed: true)}){
                    Text("Accept")
                }
                Button(action: {CrashlyticsConsents.shared.saveConsent(isAllowed: false)}){
                    Text("Decline")
                }
            } message: {
                Text("Allow this app to collect crash reports ???")
            }
        }
    }
    private func handleButtonReload() async {
        await viewmodel.loadCats()
    }
}
struct ButtonBar: View{
    var body: some View{
        HStack(spacing: 3){
            Button("Crash 1"){
                CrashLogs.shared.crashTapped(buttonName: "Crash 1", type: "fatalError")
                fatalError("Crash 1 was triggered")
            }.foregroundStyle(.red).padding()
            Button("Crash 2"){
                CrashLogs.shared.crashTapped(buttonName: "Crash 2", type: "array out of bounds")
                let array = [1, 2, 3]
                _ = array[10]
            }.foregroundStyle(.yellow).padding()
            Button("Crash 3") {
                CrashLogs.shared.crashTapped(buttonName: "Crash 3", type: "nil unwrap")
                let value: String? = nil
                _ = value!
            }.foregroundStyle(.orange)
        }
    }
}

#Preview {
    CatListView()
}


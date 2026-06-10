//
//  TraceImageView.swift
//  PrettyCatApp
//
//  Created by Max Kostyniuk on 25.05.2026.
//

import SwiftUI
import FirebasePerformance
import FirebaseCrashlytics

struct TraceImageView: View{
    let url: URL?
    
    @State private var trace: Trace?
    @State private var didStart = false
    @State private var didStop = false
    var body: some View{
        AsyncImage(url: url){ phase in
            switch phase{
            case .empty :
                ProgressView()
                    .frame(height: 300)
                    .frame(maxWidth: .infinity)
                    .onAppear(){
                        startImageTrace()
                    }
            case .success(let image):
                image.resizable()
                    .frame(height: 300)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .onAppear(){
                        stopImageTrace(result: "success")
                    }
            case .failure:
                Image(systemName: "photo").resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .frame(maxWidth: .infinity)
                    .onAppear(){
                        stopImageTrace(result: "error")
                    }
            default:
                EmptyView()
            }
        }.onAppear(){
            startImageTrace()
            CrashLogs.shared.openedScreen("CatDetailsView")
        }
    }
    private func startImageTrace(){
        guard !didStart else{
            return
        }
        didStart = true
        trace = Performance.startTrace(name: "image_load")
        if let url {
            trace?.setValue(url.host ?? "unknown", forAttribute: "host")
        }
    }
    private func stopImageTrace(result: String){
        guard didStart, !didStop else{
            return
        }
        didStop = true
        trace?.setValue(result, forAttribute: "result")
        trace?.stop()
    }
}

//
//  CatView.swift
//  PrettyCatApp
//
//  Created by Max Kostyniuk on 13.05.2026.
//
import SwiftUI
import Networking
struct CatDetailsView: View {
    let cat: CatDog
    let colors: [Color] = [.red, .blue, .green, .orange, .purple, .pink]
    var body: some View {
        VStack {
            TraceImageView(url: URL(string: cat.url))
            Text(cat.name).font(.title2)
                .fontDesign(.monospaced)
                .foregroundStyle(colors.randomElement()!)
        }.overlay(RoundedRectangle(cornerRadius: 12)
            .strokeBorder( colors.randomElement()!, lineWidth: 2))
        .padding(.horizontal, 10)

    }
}

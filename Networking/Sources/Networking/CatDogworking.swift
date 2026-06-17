// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
private let catUrl = "https://api.thecatapi.com/v1/images/search?limit=10"
private let dogUrl = "https://api.thedogapi.com/v1/images/search?limit=10"

public struct CatDog: Codable, Identifiable{
    public let id: String
    public let url: String
    public let width: Int
    public let height: Int
    
    
    public init(id: String, url: String, width: Int = 0, height: Int = 0) {

        self.id = id

        self.url = url

        self.width = width

        self.height = height

    }
}

@available(macOS 12.0, *)
@available(iOS 15.0, *)
public func getCats() async throws -> [CatDog]{
    guard let url = URL(string: catUrl) else{
        throw URLError(.badURL)
    }
    let (data, response) = try await URLSession.shared.data(from: url)
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else{
        throw URLError(.badServerResponse)
    }
    return try JSONDecoder().decode([CatDog].self, from: data)
}

@available(macOS 12.0, *)
@available(iOS 15.0, *)
public func getDogs() async throws -> [CatDog] {
    guard let url = URL(string: dogUrl) else { throw URLError(.badURL) }
    let (data, response) = try await URLSession.shared.data(from: url)
    guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
        throw URLError(.badServerResponse)
    }
    return try JSONDecoder().decode([CatDog].self, from: data)
}

public extension CatDog{
    var name: String {["Meow or Haw", "UKma Cat", "Frankiv the best", "CatDogIOS", "---", "Animal"].randomElement()!}
}

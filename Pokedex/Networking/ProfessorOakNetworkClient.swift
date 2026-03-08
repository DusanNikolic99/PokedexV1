//
//  ProfessorOakNetworkClient.swift
//  Pokedex
//
//  Created by Dusan Nikolic on 08/03/2026.
//

import Foundation

final class ProfessorOakNetworkClient: Sendable {

    private let session: URLSession
    
    /// Network client initalizer
    /// This one is configured with:
    ///  1. timeoutIntervalForRequest which catches if the server accepts the request but then goes silent
    ///  2. timeoutIntervalForResource which catches if a server sends data very slowly forever
    init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        config.timeoutIntervalForResource = 30
        self.session = URLSession(configuration: config)
    }
    
    
    // MARK: Fetch Pokemon List
    /// Fetches one page of the Pokemon list.
    /// - Parameters:
    ///   - offset: How many Pokemon to skip.
    ///   - limit: Batch size lmited to 42
    func fetchPokemonList(offset: Int, limit: Int = 42) async throws -> PokeListResponse {
        // Creating the pokemon endpoint url
        var components = URLComponents(string: "https://pokeapi.co/api/v2/pokemon")!
        components.queryItems = [
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        // Fetching data
        return try await fetch(url: url, type: PokeListResponse.self)
    }
    

    // MARK: Fetch Pokemon Details
    /// Fetchng details about a single pokemon
    func fetchPokemonDetail(id: Int) async throws -> PokeDetail {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)") else {
            throw NetworkError.invalidURL
        }
        return try await fetch(url: url, type: PokeDetail.self)
    }
    

    // MARK: Generic fetcher
    private func fetch<T: Decodable>(url: URL, type: T.Type) async throws -> T {
        // Performing network call
        let (data, response) = try await session.data(from: url)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw NetworkError.badResponse
        }
        
        // Decoding response object
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed(error)
        }
    }
}

// MARK: Image fetching
extension ProfessorOakNetworkClient {
    func fetchImageData(from urlString: String) async throws -> Data {
        try await fetchImageData(from: urlString, cachePolicy: .useProtocolCachePolicy)
    }

    func fetchImageDataNoCache(from urlString: String) async throws -> Data {
        try await fetchImageData(from: urlString, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
    }

    private func fetchImageData(from urlString: String, cachePolicy: URLRequest.CachePolicy) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url, cachePolicy: cachePolicy)

        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw NetworkError.badResponse
        }
        return data
    }
}


// MARK: NetworkErrors
enum NetworkError: LocalizedError {
    case invalidURL
    case badResponse
    case decodingFailed(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:           return "Invalid Url"
        case .badResponse:          return "Server Error."
        case .decodingFailed(let e): return "Decoding failed: \(e.localizedDescription)"
        }
    }
}

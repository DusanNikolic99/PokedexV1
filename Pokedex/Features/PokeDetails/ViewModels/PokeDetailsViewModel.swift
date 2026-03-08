//
//  PokeDetailsViewModel.swift
//  Pokedex
//
//  Created by Dusan Nikolic on 08/03/2026.
//

import Foundation
import SwiftUI


@MainActor
@Observable
final class PokeDetailViewModel {
    private(set) var detail: PokeDetail?
    private(set) var imageData: Data?
    private(set) var isLoading = false

    // ProfessorOakNetworkClient is NOT a singleton – new instance per ViewModel.
    @ObservationIgnored private let networkClient = ProfessorOakNetworkClient()
    @ObservationIgnored private let pokemonID: Int

    init(pokemonID: Int) {
        self.pokemonID = pokemonID
    }

    
    func loadPokeDetails() async {
        isLoading = true

        do {
            let fetched = try await networkClient.fetchPokemonDetail(id: pokemonID)
            detail = fetched

            // Don't fetch image from cache
            if let pokemonURL = fetched.sprites.frontDefault {
                imageData = try await networkClient.fetchImageDataNoCache(from: pokemonURL)
            }
        } catch {
            // Add error handeling
        }

        isLoading = false
    }
}

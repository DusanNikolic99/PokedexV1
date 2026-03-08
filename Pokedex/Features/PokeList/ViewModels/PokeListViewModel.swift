//
//  PokeListViewModel.swift
//  Pokedex
//
//  Created by Dusan Nikolic on 08/03/2026.
//

import Foundation
import SwiftUI

@MainActor
@Observable
final class PokeListViewModel {
    private(set) var pokemonList: [PokeListElem] = []
    private(set) var isLoading = false

    @ObservationIgnored private let batchSize = 42
    @ObservationIgnored private let totalCount = 151
    @ObservationIgnored private var isFetchingAll = false
    
    // Network client
    @ObservationIgnored private let networkClient = ProfessorOakNetworkClient()

    func loadAllPokemon() async {
        guard !isFetchingAll else { return }
        isFetchingAll = true
        isLoading = true

        do {
            var collected: [PokeListElem] = []
            var offset = 0

            // Fetch in batches of exactly 42 until we have all 151
            while offset < totalCount {
                let remaining = totalCount - offset
                let limit = min(batchSize, remaining)

                let response = try await networkClient.fetchPokemonList(offset: offset, limit: limit)
                collected.append(contentsOf: response.results)
                pokemonList = collected
                offset += limit
            }

        } catch {
            // Add error handeling...
        }

        isLoading = false
    }
}

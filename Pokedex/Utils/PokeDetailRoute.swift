//
//  PokeDetailRoute.swift
//  Pokedex
//
//  Created by Dusan Nikolic on 08/03/2026.
//

import Foundation

/// Represents a navigation event to the Pokémon detail screen.
/// Contains the minimum data needed to fetch and display the detail view.
struct PokeDetailRoute: Hashable, Codable, Sendable {
    let pokemonID: Int
    let pokemonName: String
}

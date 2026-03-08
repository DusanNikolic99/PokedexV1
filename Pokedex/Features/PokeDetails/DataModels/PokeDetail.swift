//
//  PokeDetail.swift
//  Pokedex
//
//  Created by Dusan Nikolic on 08/03/2026.
//

struct PokeDetail: Decodable, Identifiable, Sendable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let sprites: Sprites
    let types: [TypeSlot]

    struct Sprites: Decodable, Sendable {
        let frontDefault: String?

        enum CodingKeys: String, CodingKey {
            case frontDefault = "front_default"
        }
    }

    struct TypeSlot: Decodable, Sendable {
        let slot: Int
        let type: PokemonType
    }

    struct PokemonType: Decodable, Sendable {
        let name: String
        let url: String
    }
}

extension PokeDetail {
    var formattedName: String {
        name.capitalized
    }

    var heightInMeters: String {
        let meters = Double(height) / 10.0
        return String(format: "%.1f m", meters)
    }

    var weightInKg: String {
        let kg = Double(weight) / 10.0
        return String(format: "%.1f kg", kg)
    }

    var typeNames: [String] {
        types.sorted { $0.slot < $1.slot }.map { $0.type.name.capitalized }
    }
}

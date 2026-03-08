//
//  PokeListElem.swift
//  Pokedex
//
//  Created by Dusan Nikolic on 08/03/2026.
//

import Foundation

struct PokeListElem: Decodable, Identifiable, Sendable {
    let name: String
    let url: String

    var id: Int {
        // Extract ID from URL: https://pokeapi.co/api/v2/pokemon/1/
        let components = url.split(separator: "/")
        return Int(components.last ?? "0") ?? 0
    }
}

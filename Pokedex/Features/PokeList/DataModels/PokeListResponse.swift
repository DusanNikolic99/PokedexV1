//
//  PokeListResponse.swift
//  Pokedex
//
//  Created by Dusan Nikolic on 08/03/2026.
//

import Foundation

struct PokeListResponse: Decodable, Sendable {
    let count: Int
    let next: String?
    let results: [PokeListElem]
}

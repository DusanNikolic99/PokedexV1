//
//  PokeCard.swift
//  Pokedex
//
//  Created by Dusan Nikolic on 08/03/2026.
//

import SwiftUI

struct PokeCard: View {

    let elem: PokeListElem

    private var paddedID: String {
        String(format: "#%03d", elem.id)
    }

    private var pokeImageURL: String {
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(elem.id).png"
    }

    var body: some View {
        HStack(spacing: 16) {
            CachedListImage(urlString: pokeImageURL, size: 56)

            Text(elem.name.capitalized)
                .font(.system(.body, design: .rounded, weight: .medium))
                .foregroundStyle(.primary)

            Spacer()

            Text(paddedID)
                .font(.system(.subheadline, design: .monospaced))
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

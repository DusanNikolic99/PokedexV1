//
//  PokeListView.swift
//  Pokedex
//
//  Created by Dusan Nikolic on 08/03/2026.
//

import SwiftUI

struct PokeListView: View {

    @State private var viewModel = PokeListViewModel()
    @State private var path: [PokeDetailRoute] = []

    var body: some View {
        NavigationStack(path: $path) {
            content
                .navigationTitle("Pokedex")
                .navigationBarTitleDisplayMode(.large)
                .navigationDestination(for: PokeDetailRoute.self) { route in
                    PokeDetailView(route: route)
                }
        }
        .task {
            await viewModel.loadAllPokemon()
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.pokemonList.isEmpty && viewModel.isLoading {
            loadingView
        } else {
            listView
        }
    }

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.4)
            Text("Henter Pokémon…")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var listView: some View {
        List {
            ForEach(viewModel.pokemonList) { elem in
                NavigationLink(value: PokeDetailRoute(pokemonID: elem.id, pokemonName: elem.name)) {
                    PokeCard(elem: elem)
                }
            }

            if viewModel.isLoading {
                HStack(spacing: 8) {
                    ProgressView()
                    Text("Laster inn flere…")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .listStyle(.plain)
    }
}

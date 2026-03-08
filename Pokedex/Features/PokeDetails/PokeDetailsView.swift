//
//  PokeDetailsView.swift
//  Pokedex
//
//  Created by Dusan Nikolic on 08/03/2026.
//

import SwiftUI
import UIKit


struct PokeDetailView: View {

    let route: PokeDetailRoute

    @State private var viewModel: PokeDetailViewModel

    init(route: PokeDetailRoute) {
        self.route = route
        // New ViewModel (and new ProfessorOakNetworkClient) per detail screen
        _viewModel = State(
            wrappedValue: PokeDetailViewModel(pokemonID: route.pokemonID)
        )
    }

    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                loadingView
            } else if let detail = viewModel.detail {
                detailContent(detail: detail)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(route.pokemonName.capitalized)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadPokeDetails()
        }
    }

    // MARK: Loading View
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.4)
            Text("Loading Pokemon…")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 400)
    }

    // MARK: Pokemon Details
    @ViewBuilder
    private func detailContent(detail: PokeDetail) -> some View {
        VStack(spacing: 0) {

            // Header card with sprite + types
            headerCard(detail: detail)
                .padding(.top, 20)
            
            // Stat card with the pokemons properties
            statsCard(detail: detail)
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 32)
        }
    }

    // MARK: Pokemon Image Card
    private func headerCard(detail: PokeDetail) -> some View {
        VStack(spacing: 16) {

            ZStack {
                // Background circle
                Circle()
                    .fill(Color(.lightGray))
                    .frame(width: 180, height: 180)
                
                //Pokemon image
                if let data = viewModel.imageData, let uIImage = UIImage(data: data) {
                    Image(uiImage: uIImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 160, height: 160)
                }
                
                else if viewModel.isLoading {
                    ProgressView()
                }
                
                else {
                    Image(systemName: "questionmark")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(24)
    }

    // MARK: Pokemon Stats Card

    private func statsCard(detail: PokeDetail) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Info")
                .font(.system(.headline, design: .rounded))
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 12)

            StatRow(label: "Height", value: detail.heightInMeters)
            StatRow(label: "Weight", value: detail.weightInKg)
            StatRow(label: "Type", value: detail.typeNames.joined(separator: " /"))
        }
    }
}

// MARK: StatRow
// Maybe move out in its own file?
private struct StatRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.system(.body, design: .rounded, weight: .medium))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
    }
}

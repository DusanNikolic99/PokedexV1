//
//  CachedListImage.swift
//  Pokedex
//
//  Created by Dusan Nikolic on 08/03/2026.
//

import SwiftUI

/// Loads a sprite image for the list view.
/// Images are stored in `ImageCache` (in-memory) so they are not re-downloaded
/// when scrolled out of and back into view.
struct CachedListImage: View {

    let urlString: String
    let size: CGFloat

    // The cache itself (ImageCache.shared actor) is shared across all instances.
    private let networkClient = ProfessorOakNetworkClient()

    @State private var imageData: Data?
    @State private var isLoading = true

    var body: some View {
        Group {
            if let data = imageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
            } else if isLoading {
                ProgressView()
                    .frame(width: size, height: size)
            }
        }
        .task(id: urlString) {
            await loadImage()
        }
    }

    private func loadImage() async {
        // Check in-memory cache first
        if let cached = await ImageCache.shared.image(for: urlString) {
            imageData = cached
            isLoading = false
            return
        }

        // Download and cache
        do {
            let data = try await networkClient.fetchImageData(from: urlString)
            await ImageCache.shared.store(data, for: urlString)
            imageData = data
        } catch {
            // Silently fail, Add an error View
        }
        isLoading = false
    }
}

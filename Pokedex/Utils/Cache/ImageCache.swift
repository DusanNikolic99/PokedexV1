//
//  ImageCache.swift
//  Pokedex
//
//  Created by Dusan Nikolic on 08/03/2026.
//

import Foundation
import SwiftUI

/// Thread-safe, in-memory image cache (keyed by URL string).
/// Only used for list-view images – detail images always bypass this cache.
actor ImageCache {

    static let shared = ImageCache()

    private var cache = NSCache<NSString, NSData>()

    private init() {}

    /// Get image if it exists.
    /// Otherwise, nil is returned
    func image(for key: String) -> Data? {
        cache.object(forKey: key as NSString) as Data?
    }
    
    /// Store fetched image in cache for a spesific key
    func store(_ data: Data, for key: String) {
        cache.setObject(data as NSData, forKey: key as NSString)
    }
}

//
//  FavoritesManager.swift
//  KaizenGame
//
//  Created by Gustavo Quenca on 26/09/2024.
//

import Foundation

class FavoritesManager {
    private let favoritesKey = "favoriteEvents"
    
    func save(favoriteEventIDs: [String]) {
        UserDefaults.standard.set(favoriteEventIDs, forKey: favoritesKey)
    }

    func load() -> [String] {
        return UserDefaults.standard.array(forKey: favoritesKey) as? [String] ?? []
    }
}

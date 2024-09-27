//
//  SportsViewModel.swift
//  KaizenGame
//
//  Created by Gustavo Quenca on 24/09/2024.
//

import Foundation
import Combine

class SportsViewModel: ObservableObject {
    @Published var sports: [Sport] = []
    @Published var errorMessage: String?
    
    private var sportsRepository: SportsRepository
    private var favoritesManager: FavoritesManager
    private var countdownManager: CountdownManager
    
    init(sportsRepository: SportsRepository, countdownManager: CountdownManager, favoritesManager: FavoritesManager) {
        self.sportsRepository = sportsRepository
        self.countdownManager = countdownManager
        self.favoritesManager = favoritesManager
    }
    
    func fetchSportsData() async {
        do {
            let sports = try await sportsRepository.fetchSportsData()
            DispatchQueue.main.async {
                self.sports = sports
                self.errorMessage = nil
                self.startCountdownTimers()
                self.loadFavorites()
            }
        } catch let error as NetworkError {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Unexpected error: \(error.localizedDescription)"
            }
        }
    }
    
    // Load favorites from the FavoritesManager
    func loadFavorites() {
        let favoriteIDs = favoritesManager.load()
        for sportIndex in sports.indices {
            for eventIndex in sports[sportIndex].events.indices {
                if favoriteIDs.contains(sports[sportIndex].events[eventIndex].eventID) {
                    sports[sportIndex].events[eventIndex].favorite = true
                } else {
                    sports[sportIndex].events[eventIndex].favorite = false
                }
                
                // Sort events within each sport, putting favorites first
                sports[sportIndex].events.sort { $0.favorite && !$1.favorite }
                
            }
        }
    }
    
    func startCountdownTimers() {
        for sport in sports {
            for event in sport.events {
                countdownManager.startCountdown(for: event) { [weak self] remainingTime in
                    self?.updateCountdown(for: event, remainingTime: remainingTime)
                }
            }
        }
    }
    
    func toggleFavorite(forEventID eventID: String) {
        for sportIndex in sports.indices {
            for eventIndex in sports[sportIndex].events.indices {
                if sports[sportIndex].events[eventIndex].eventID == eventID {
                    // Toggle the favorite state
                    sports[sportIndex].events[eventIndex].favorite.toggle()
                    
                    // Make sure the updated array is reflected in the UI
                    updateFavorites()  // Save to persistent storage
                    break
                }
            }
        }
    }
    
    // Call this method when you toggle a favorite event
    func updateFavorites() {
        var favorites = [String]()
        for sport in sports {
            for event in sport.events where event.favorite {
                print("Favorite eventID: \(event.eventID)")
                favorites.append(event.eventID)
            }
        }
        favoritesManager.save(favoriteEventIDs: favorites)
    }
    
    private func updateCountdown(for event: Event, remainingTime: Int) {
        if remainingTime <= 0 {
            countdownManager.stopCountdown(for: event.eventID)
        }
    }
}

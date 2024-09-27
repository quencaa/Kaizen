//
//  EventCellViewModel.swift
//  KaizenGame
//
//  Created by Gustavo Quenca on 26/09/2024.
//
import Foundation

class EventCellViewModel {
    var events: [Event]
    var sportID: String
    
    init(events: [Event], sportID: String) {
        self.events = events
        self.sportID = sportID
    }

    func event(at index: Int) -> Event? {
        guard index >= 0 && index < events.count else { return nil }
        return events[index]
    }

    func numberOfEvents() -> Int {
        return events.count
    }

    var sportIdentifier: String {
        return sportID
    }
    
    func toggleFavorite(at index: Int) {
        guard index >= 0 && index < events.count else { return }
        events[index].favorite.toggle()  // Toggle the favorite state of the event
    }
}

//
//  CountdownManager.swift
//  KaizenGame
//
//  Created by Gustavo Quenca on 26/09/2024.
//

import Foundation

class CountdownManager {
    private var countdownTimers: [String: Timer] = [:]

    func startCountdown(for event: Event, updateHandler: @escaping (Int) -> Void) {
        guard countdownTimers[event.eventID] == nil else { return }
        
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            let now = Int(Date().timeIntervalSince1970)
            let remainingTime = event.eventStartTime - now
            updateHandler(remainingTime)
            
            if remainingTime <= 0 {
                self.countdownTimers[event.eventID]?.invalidate()
                self.countdownTimers.removeValue(forKey: event.eventID)
            }
        }
        countdownTimers[event.eventID] = timer
    }

    func stopCountdown(for eventID: String) {
        countdownTimers[eventID]?.invalidate()
        countdownTimers.removeValue(forKey: eventID)
    }
}

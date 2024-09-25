//
//  Event.swift
//  KaizenGame
//
//  Created by Gustavo Quenca on 24/09/2024.
//
import Foundation

struct Event: Codable {
    let eventID: String
    let sportID: String
    let eventName: String
    let eventStartTime: Int

    enum CodingKeys: String, CodingKey {
        case eventID = "i"
        case sportID = "si"
        case eventName = "d"
        case eventStartTime = "tt"
    }
}

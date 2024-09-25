//
//  Sport.swift
//  KaizenGame
//
//  Created by Gustavo Quenca on 24/09/2024.
//

import Foundation

struct Sport: Codable {
    let sportID: String
    let sportName: String
    let events: [Event]

    enum CodingKeys: String, CodingKey {
        case sportID = "i"
        case sportName = "d"
        case events = "e"
    }
}

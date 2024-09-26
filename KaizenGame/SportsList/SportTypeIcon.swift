//
//  SportTypeIcon.swift
//  KaizenGame
//
//  Created by Gustavo Quenca on 25/09/2024.
//

import UIKit

enum SportType: String {
    case soccer = "SOCCER"
    case basketball = "BASKETBALL"
    case tennis = "TENNIS"
    case volleyball = "VOLLEYBALL"
    case handball = "HANDBALL"
    case futsal = "FUTSAL"
    case tabletennis = "TABLETENNIS"
    case esports = "ESPORTS"
    case icehockey = "ICEHOCKEY"
    case snooker = "SNOOKER"
    case darts = "DARTS"

    var icon: UIImage {
        return SportType.loadImage(for: self)
    }

    // Helper function to load the image and provide a fallback
    private static func loadImage(for sport: SportType) -> UIImage {
        let imageName: String
        switch sport {
        case .soccer:
            imageName = "soccerball"
        case .basketball:
            imageName = "sportscourt"
        case .tennis:
            imageName = "tennisball"
        case .volleyball:
            imageName = "circle.grid.3x3"
        case .handball:
            imageName = "hand.raised"
        case .futsal:
            imageName = "soccerball"
        case .tabletennis:
            imageName = "figure.table.tennis"
        case .esports:
            imageName = "figure.disc.sports"
        case .icehockey:
            imageName = "figure.hockey"
        case .snooker:
            imageName = "table.furniture"
        case .darts:
            imageName = "die.face.6"
        }
        // default image
        return UIImage(systemName: imageName) ?? UIImage(systemName: "circle")!
    }
}

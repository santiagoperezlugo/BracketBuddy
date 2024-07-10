//
//  Player.swift
//  BracketBuddy
//
//  Created by Santiago on 1/18/24.
//

import Foundation
import SwiftUI

enum TeamColor: String, Codable, Hashable, CaseIterable {
    case blue = "Blue"
    case red = "Red"
    case green = "green"
    case orange = "orange"
    case pink = "pink"
    case yellow = "yellow"
    case purple = "purple"
    case cyan = "cyan"
    case indigo =  "indigo"
    case teal = "teal"
    // ... add more colors as needed

    // Convert to SwiftUI Color
    var color: Color {
        switch self {
        case .blue:
            return .blue
        case .red:
            return .red
        case .green:
            return .green
        case .orange:
            return .orange
        case .pink:
            return .pink
        case .yellow:
            return .yellow
        case .purple:
            return .purple
        case .cyan:
            return .cyan
        case .indigo:
            return .indigo
        case .teal:
            return .teal
        }
    }
}

// A simple structure to represent a player.
struct Player: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var teamColor: TeamColor?
    
    // Conformance to `Hashable`
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Conformance to `Equatable`
    static func == (lhs: Player, rhs: Player) -> Bool {
        lhs.id == rhs.id
    }
    
    // Conformance to `Codable` is already provided by default for this struct
}

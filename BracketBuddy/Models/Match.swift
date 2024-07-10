//
//  Match.swift
//  BracketBuddy
//
//  Created by Santiago on 1/19/24.
//

import Foundation
// Represents a single match in the bracket between two players.
struct Match: Identifiable, Hashable {
    var id = UUID()
    var team1: [Player] // Not optional, should be an array
    var team2: [Player] // Not optional, should be an array
    var winner: [Player]? // Optional array of Players (the winning team)
    var isFinal: Bool = false 

    init(team1: [Player], team2: [Player], winner: [Player]? = nil) {
        self.team1 = team1
        self.team2 = team2
        self.winner = winner
    }
}



//
//  Bracket.swift
//  BracketBuddy
//
//  Created by Santiago on 1/19/24.
//

import Foundation

// Represents the entire bracket for the tournament, consisting of multiple matches.
struct Bracket: Hashable, Equatable {
    var matches: [Match]

    init(matches: [Match]) {
        self.matches = matches
    }
}



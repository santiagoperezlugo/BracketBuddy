//
//  PlayerView.swift
//  BracketBuddy
//
//  Created by Santiago on 1/23/24.
//
import SwiftUI

struct PlayerView: View {
    var player: Player
    var isColorChangeAllowed: Bool
    var colorTapped: () -> Void

    var body: some View {
        HStack {
            Text(player.name)
                .padding()
                .background(player.teamColor?.color ?? .clear) // Use .clear for transparency if `teamColor` is `nil`
                .cornerRadius(10)
                .onTapGesture {
                    // Only allow changing color if isColorChangeAllowed is true
                    if isColorChangeAllowed {
                        colorTapped()
                    }
                }
        }
    }
}

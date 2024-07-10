//
//  TeamsView.swift
//  BracketBuddy
//
//  Created by Santiago on 1/18/24.
//
import SwiftUI

struct TeamsView: View {
    var teams: [[Player]]

    var body: some View {
        List {
            ForEach(0..<teams.count, id: \.self) { teamIndex in
                Section(header: Text("Team \(teamIndex + 1)")) {
                    ForEach(teams[teamIndex], id: \.self) { player in
                        Text(player.name)
                    }
                }
            }
        }
        .navigationTitle("Teams")
    }
    
    private func TeamView(team: [Player]) -> some View {
        VStack {
            ForEach(team, id: \.id) { player in
                Text(player.name)
                    .frame(maxWidth: .infinity, alignment: .center) // Center the text in the available space
            }
        }
    }
}

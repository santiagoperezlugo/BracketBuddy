//
//  TournamentViewModel.swift
//  BracketBuddy
//
//  Created by Santiago on 1/18/24.
//

import Combine
import SwiftUI

class TournamentViewModel: ObservableObject {
    @Published var players: [Player] = []
    private var teamsGenerated = false
    @Published var numberOfTeams: Int = 2
    @Published var playersPerTeam: Int = 2
    @Published var bracket: Bracket?
    @Published var tournamentWinner: Player?
    @Published var isFinalMatch: Bool = false
    @Published var isRandomized: Bool = true{
        didSet {
            if isRandomized {
                clearTeamColors()
            } else {
                assignTeamColors()
            }
        }
    }
    
    
    
    var teams : [[Player]]{
        return generateTeams()
    }
    
    // Add a new player to the list.
    func addPlayer(name: String) {
            let newPlayer = Player(name: name)
            players.append(newPlayer)
            print("Added player: \(name)")
            if !isRandomized {
                assignTeamColors()
            }
        }

        func generateTeams() -> [[Player]] {
            if isRandomized {
                return generateRandomTeams()
            } else {
                return groupPlayersByTeamColor()
            }
        }

        var colorsToAssign: [TeamColor] {
            Array(TeamColor.allCases.prefix(numberOfTeams))
        }

    private func groupPlayersByTeamColor() -> [[Player]] {
        var teamsDict = [TeamColor: [Player]]()
        colorsToAssign.forEach { teamsDict[$0] = [] }
        for player in players {
            if let color = player.teamColor {
                teamsDict[color]?.append(player)
            }
        }
        return teamsDict.values.filter { !$0.isEmpty }
    }


    private func generateRandomTeams() -> [[Player]] {
        print("Generating random teams")
        let shuffledPlayers = players.shuffled()

        // If there is only one team, return all players as a single team.
        if numberOfTeams == 1 {
            return [shuffledPlayers]
        }

        // Calculate the number of players per team
        let baseTeamSize = players.count / numberOfTeams
        let teamsWithExtraPlayer = players.count % numberOfTeams

        var teams: [[Player]] = []
        var startIndex = 0

        // Distribute players into teams
        for teamIndex in 0..<numberOfTeams {
            let teamSize = baseTeamSize + (teamIndex < teamsWithExtraPlayer ? 1 : 0)
            let endIndex = startIndex + teamSize
            if endIndex <= shuffledPlayers.count {
                let team = Array(shuffledPlayers[startIndex..<endIndex])
                teams.append(team)
            }
            startIndex = endIndex
        }

        return teams
    }



        func resetPlayers() {
            players.removeAll()
        }

        private func clearTeamColors() {
            for index in players.indices {
                players[index].teamColor = nil
            }
        }

        func assignTeamColors() {
            for i in 0..<players.count {
                players[i].teamColor = colorsToAssign[i % colorsToAssign.count]
            }
        }
    
    
    func generateBracket() {
        let teams = generateTeams() // Generate the teams
        // If there's only one team, do not generate any matches.
        guard teams.count > 1 else {
            bracket = Bracket(matches: [])
            return
            }
        var matches = [Match]()

        for i in stride(from: 0, to: teams.count, by: 2) {
            let team1 = teams[safe: i] ?? []
            let team2 = teams[safe: i + 1] ?? []

            let match = Match(team1: team1, team2: team2)
            matches.append(match)
        }

        bracket = Bracket(matches: matches)
    }


    
    func generateNextRound() {
        guard let currentMatches = bracket?.matches else { return }
        let winners: [[Player]] = currentMatches.compactMap { $0.winner }
        createMatchesFromTeams(winners: winners)
        isFinalMatch = winners.count == 2
    }
    
    // This method takes an array of players (winners from the previous round) and creates the next round's matches
    func createMatchesFromTeams(winners: [[Player]]) {
        guard winners.count % 2 == 0 else {
            print("Number of teams is not even. Please handle this case appropriately.")
            return
        }

        var matches = [Match]()
        for i in stride(from: 0, to: winners.count, by: 2) {
            let match = Match(team1: winners[i], team2: winners[i + 1])
            matches.append(match)
        }
        bracket = Bracket(matches: matches)
    }
    
    func markWinner(for matchId: UUID, winnerTeam: [Player]) {
            if let index = bracket?.matches.firstIndex(where: { $0.id == matchId }) {
                bracket?.matches[index].winner = winnerTeam
            }
        }
    
    func determineTournamentWinner() {
        if isFinalMatch, let finalMatch = bracket?.matches.first {
            // If the match has a winner, set it as the tournament winner
            if let winnerTeam = finalMatch.winner {
                tournamentWinner = winnerTeam.first // Assuming there's only one player in a winner team
            }
            // Reset the tournament for a new game
            resetTournament()
        }
    }


    private func resetTournament() {
        bracket = nil
        isFinalMatch = false
        players.removeAll()
    }

    
    
}


// Helper to safely access array elements
extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}



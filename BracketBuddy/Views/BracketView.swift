//
//  BracketView.swift
//  BracketBuddy
//
//  Created by Santiago on 1/19/24.
//

// BracketView.swift
import SwiftUI
    
struct BracketView: View {
//    @Binding var bracket: Bracket // Now this is a binding to allow changes
    @Binding var isPresented: Bool
    @ObservedObject var tournamentVM: TournamentViewModel

    var body: some View {
        NavigationView {
            List(tournamentVM.bracket?.matches ?? []) { match in
                VStack {
                    HStack {
                        PlayerButton(team: match.team1, isWinner: match.winner == match.team1, matchId: match.id) { winnerTeam in
                            tournamentVM.markWinner(for: match.id, winnerTeam: winnerTeam)
                        }
                        Text("vs")
                            .padding(.horizontal)
                        PlayerButton(team: match.team2, isWinner: match.winner == match.team2, matchId: match.id) { winnerTeam in
                            tournamentVM.markWinner(for: match.id, winnerTeam: winnerTeam)
                        }
                    }
                }

            }
            

            .navigationBarTitle("Tournament Bracket", displayMode: .inline)
            .navigationBarItems(leading: Button("Back") {
                self.isPresented = false
            }, trailing: Button("Next Round") {
                // Generate the next round
                generateNextRound()
            }.disabled(!allMatchesHaveWinners()))
        }
    }

    func markWinner(for matchId: UUID, winner: [Player]) {
        if let matchIndex = tournamentVM.bracket?.matches.firstIndex(where: { $0.id == matchId }) {
            tournamentVM.bracket?.matches[matchIndex].winner = winner
        }
    }

    func allMatchesHaveWinners() -> Bool {
        tournamentVM.bracket?.matches.allSatisfy { $0.winner != nil } ?? false
    }

    func generateNextRound() {
        // Logic to create the next round matches from winners
        tournamentVM.generateNextRound()
    }
    @ViewBuilder
    private func PlayerButton(team: [Player], isWinner: Bool, matchId: UUID, action: @escaping ([Player]) -> Void) -> some View {
        Button(action: { action(team) }) {
            Text(team.map { $0.name }.joined(separator: ", "))
                .foregroundColor(isWinner ? .green : .primary)
                .fontWeight(isWinner ? .bold : .regular)
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .background(isWinner ? Color.green.opacity(0.2) : Color.clear)
        .cornerRadius(8)
    }

    
    private func TeamView(team: [Player]) -> some View {
            ForEach(team, id: \.id) { player in
                Text(player.name)
            }
        }
    
    
}

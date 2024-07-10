//
//  ContentView.swift
//  BracketBuddy
//
//  Created by Santiago on 1/18/24.
//

import SwiftUI

// ContentView is the primary view of your app.
struct ContentView: View {
    // @StateObject is a property wrapper that instantiates an observable object (TournamentViewModel).
    // This instance is responsible for all the logic related to managing players and generating teams.
    @StateObject var tournamentVM = TournamentViewModel()
    
    // States for error handling
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    @State var teams: [[Player]] = []
    @State private var showTeams = false
    // @State is a property wrapper that reflects a mutable state managed by SwiftUI.
    // Here, it's used for the text field where the user enters a new player's name.
    @State private var newPlayerName: String = ""
    
    @State private var showingBracket = false
    @State private var selectedBracket: Bracket? = nil
    
    @State private var showCongratulatoryScreen = false

    let backgroundGradient = LinearGradient(
            gradient: Gradient(colors: [Color.white, Color.blue.opacity(0.3)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    // The body property defines the view's layout and content.
    var body: some View {
        // NavigationView is a container that manages navigation between views and provides a navigation bar.
        NavigationStack {
            // VStack arranges its child views in a vertical line.
            VStack {
                HStack {
                    Image(systemName: "soccerball")
                        .imageScale(.large)
                    Text("BracketBuddy")
                        .font(.title) // Adjust the font as needed
                    Image(systemName: "football")
                        .imageScale(.large)
                        .foregroundColor(.brown)
                }
                .padding(.horizontal) // Add padding to the sides
                TextField("Enter player name", text: $newPlayerName)
                
                
                // A button to add a new player, triggers the addPlayer function in the view model.
                Button("Add Player") {
                    //trims white spaces from players and checks if empty
                    if newPlayerName.trimmingCharacters(in: .whitespaces).isEmpty {
                        errorMessage = "Player name cannot be empty."
                        showErrorAlert = true
                    } else {
                        tournamentVM.addPlayer(name: newPlayerName)
                        newPlayerName = ""
                    }
                }
                
                .alert(isPresented: $showErrorAlert) {
                    Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                }


                
                // Stepper allows to increase or decrease a number. Here, it's used to set the number of teams.
                Stepper("Number of Teams: \(tournamentVM.numberOfTeams)", value: $tournamentVM.numberOfTeams, in: 1...16) { _ in
                    if !tournamentVM.isRandomized {
                        tournamentVM.assignTeamColors()
                    }
                }
                // Another Stepper for setting the number of players per team.
//                Stepper("Players per Team: \(tournamentVM.playersPerTeam)", value: $tournamentVM.playersPerTeam, in: 1...10)
                
                // Toggle switch to choose between random or custom team generation.
                Toggle("Randomize Teams", isOn: $tournamentVM.isRandomized)
                
                
                // A list that displays each player in the tournamentVM.players array.
                List {
                    ForEach($tournamentVM.players) { $player in
                        PlayerView(
                            player: $player.wrappedValue, // Use wrappedValue to get the Player instance
                            isColorChangeAllowed: !tournamentVM.isRandomized, // Pass the actual Bool value, not the Binding
                            colorTapped: {
                                // Ensure we are allowed to change the color
                                if !tournamentVM.isRandomized {
                                    // First, find the current color's index in the array of all cases
                                    let allColors = TeamColor.allCases
                                    let currentColorIndex = allColors.firstIndex(of: $player.teamColor.wrappedValue ?? .blue) ?? 0

                                    
                                    // Determine the next color based on the current number of teams
                                    let nextColorIndex: Int
                                    switch tournamentVM.numberOfTeams {
                                    case 2:
                                        // Cycle between two colors
                                        nextColorIndex = (currentColorIndex + 1) % 2
                                    case 3:
                                        // Cycle between three colors
                                        nextColorIndex = (currentColorIndex + 1) % 3
                                    case 4:
                                        // Cycle between four colors, and so on...
                                        nextColorIndex = (currentColorIndex + 1) % 4
                                    // Add more cases as needed for more teams
                                    case 5:
                                        // Cycle between four colors, and so on...
                                        nextColorIndex = (currentColorIndex + 1) % 5
                                    case 6:
                                        // Cycle between four colors, and so on...
                                        nextColorIndex = (currentColorIndex + 1) % 6
                                    case 7:
                                        // Cycle between four colors, and so on...
                                        nextColorIndex = (currentColorIndex + 1) % 7
                                    case 8:
                                        // Cycle between four colors, and so on...
                                        nextColorIndex = (currentColorIndex + 1) % 8
                                    case 9:
                                        // Cycle between four colors, and so on...
                                        nextColorIndex = (currentColorIndex + 1) % 9
                                    default:
                                        // If the number of teams doesn't match any case, use default logic
                                        nextColorIndex = (currentColorIndex + 1) % allColors.count
                                    }
                                    
                                    // Assign the next color to the player
                                    if let newColor = allColors[safe: nextColorIndex] {
                                        $player.teamColor.wrappedValue = newColor
                                    }
                                }
                            }

                        )
                    }

                }


                
                Button("Generate Teams") {
                    tournamentVM.generateTeams()
                    showTeams = !tournamentVM.teams.isEmpty
                    print("Show teams sheet: \(showTeams)")
                }
                .padding()
                .buttonStyle(BlackButtonStyle())
                .sheet(isPresented: $showTeams) {
                    TeamsView(teams: tournamentVM.teams)
                }
                // Generate Bracket Button
                Button("Generate Bracket") {
                    tournamentVM.generateBracket()
                    if tournamentVM.bracket != nil {
                        showingBracket = true // Set this to true to show the bracket view
                    }
                }
                .buttonStyle(BlackButtonStyle())
                // Clear Players Button
                Button("Clear Players") {
                    tournamentVM.resetPlayers()
                }
                .padding()
                .buttonStyle(BlackButtonStyle())
            }
            .padding() // Adds padding around the VStack content
            .background(backgroundGradient.edgesIgnoringSafeArea(.all))
        }
        .fullScreenCover(isPresented: $showingBracket) {
            if tournamentVM.bracket != nil {
                BracketView(isPresented: $showingBracket, tournamentVM: tournamentVM)
            } else {
                Text("No Bracket Available").padding()
            }
        }
        .onChange(of: tournamentVM.tournamentWinner) { winner in
            if winner != nil {
                showCongratulatoryScreen = true
            }
        }
        .fullScreenCover(isPresented: $showCongratulatoryScreen) {
            CongratulatoryView(winner: Player(name: "Sample Player"), onDismiss: {
                showCongratulatoryScreen = false // This will dismiss the full-screen cover
            })
            
        }
    }
}

// A preview provider that generates a preview of ContentView in Xcode's canvas.
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct CongratulatoryView: View {
    let winner: Player
    let onDismiss: () -> Void

    var body: some View {
        VStack {
            Text("Congratulations \(winner.name)!")
                .font(.largeTitle)
                .padding()
            Button("Back to Main Screen") {
                onDismiss() // This should be provided by ContentView and should toggle the state
            }
            .padding()
        }
    }
}

struct BlackButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .font(.custom("Helvetica-Bold", size: 13))
            .background(Color.cyan)
            .foregroundColor(.white)
            .cornerRadius(40)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}



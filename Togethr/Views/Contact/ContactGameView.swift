// Views/Contact/ContactGameView.swift
import SwiftUI

struct ContactGameView: View {
    
    @Binding var navPath: NavigationPath
    let players: [String]
    let secretWord: String
    
    // --- Game State ---
    @State private var revealedCount: Int = 1
    @State private var currentPlayerIndex: Int = 0
    @State private var scores: [Int]
    
    // State for the "Undo" feature
    @State private var history: [GameState] = []
    
    // A struct to hold a snapshot of the game state
    struct GameState {
        let revealedCount: Int
        let currentPlayerIndex: Int
        let scores: [Int]
    }
    
    // Computed property for the partially revealed word
    var displayedWord: String {
        String(secretWord.prefix(revealedCount))
    }
    
    // Computed property for the current player's name
    var currentPlayerName: String {
        players[currentPlayerIndex]
    }
    
    init(navPath: Binding<NavigationPath>, players: [String], secretWord: String) {
        self._navPath = navPath
        self.players = players
        self.secretWord = secretWord
        
        // Initialize scores to 0 for all players
        self._scores = State(initialValue: Array(repeating: 0, count: players.count))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            
            // --- Score & Turn Info ---
            HStack {
                VStack(alignment: .leading) {
                    Text("Scores")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    ForEach(players.indices, id: \.self) { index in
                        Text("\(players[index]): **\(scores[index])**")
                    }
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Current Turn")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text(currentPlayerName)
                        .font(.title2)
                        .fontWeight(.bold)
                }
            }
            .padding()
            .background(.regularMaterial)
            .cornerRadius(12)
            
            Spacer()
            
            // --- Displayed Word ---
            Text(displayedWord)
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .kerning(4) // Add spacing between letters
                .padding()
            
            Text("The word has \(secretWord.count) letters.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            // --- Game Actions ---
            VStack(spacing: 12) {
                // "Contact Successful" button
                Button(action: contactSuccessful) {
                    Text("Contact Successful")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .font(.headline)
                        .cornerRadius(12)
                }
                
                // "Pass / Stumped" button
                Button(action: passTurn) {
                    Text("Pass / Stumped")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .font(.headline)
                        .cornerRadius(12)
                }
                
                // "Guessed Word" button
                Button(action: wordGuessed) {
                    Text("Word Was Guessed!")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .font(.headline)
                        .cornerRadius(12)
                }
            }
            
            // --- Undo Button ---
            Button(action: undoLastAction) {
                Label("Undo Last Action", systemImage: "arrow.uturn.backward")
            }
            .disabled(history.isEmpty) // Disable if no history
            .padding(.top, 20)
            
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Contact")
    }
    
    // --- Game Logic Functions ---
    
    func saveCurrentState() {
        let currentState = GameState(
            revealedCount: revealedCount,
            currentPlayerIndex: currentPlayerIndex,
            scores: scores
        )
        history.append(currentState)
    }
    
    func contactSuccessful() {
        saveCurrentState()
        
        // Award point to current player
        scores[currentPlayerIndex] += 1
        
        // Reveal next letter
        revealedCount += 1
        
        // Move to next player
        nextPlayer()
        
        // Check for "lose" condition (word fully revealed but not guessed)
        if revealedCount == secretWord.count {
            // In this version, we'll just navigate to the result screen
            // The "winner" is the one with the highest score
            navigateToResult()
        }
    }
    
    func passTurn() {
        saveCurrentState()
        
        // Just move to the next player
        nextPlayer()
    }
    
    func wordGuessed() {
        // Don't save state, this is a final action
        
        // The current player is the one who guessed it
        // Award them a bonus (e.g., 3 points)
        scores[currentPlayerIndex] += 3
        
        // End the game
        navigateToResult()
    }
    
    func undoLastAction() {
        guard let lastState = history.popLast() else { return }
        
        // Restore the previous state
        self.revealedCount = lastState.revealedCount
        self.currentPlayerIndex = lastState.currentPlayerIndex
        self.scores = lastState.scores
    }
    
    func nextPlayer() {
        currentPlayerIndex = (currentPlayerIndex + 1) % players.count
    }
    
    func navigateToResult() {
        // Find the player with the highest score
        let maxScore = scores.max() ?? 0
        let winnerIndex = scores.firstIndex(of: maxScore) ?? 0
        let winnerName = players[winnerIndex]
        
        // Handle ties
        let allWinners = players.indices
            .filter { scores[$0] == maxScore }
            .map { players[$0] }
        
        let winnerDisplay = allWinners.count > 1 ? "It's a tie!" : "\(winnerName) Wins!"
        
        navPath.append(GameNavigation.contactResult(
            winner: winnerDisplay,
            secretWord: secretWord
        ))
    }
}

struct ContactGameView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContactGameView(
                navPath: .constant(NavigationPath()),
                players: ["Alice", "Bob"],
                secretWord: "ELEPHANT"
            )
        }
    }
}

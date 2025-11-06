// Views/Contact/ContactGameView.swift
import SwiftUI

struct ContactGameView: View {
    
    @Binding var navPath: NavigationPath
    let secretWord: String
    
    // --- Game State ---
    @State private var revealedCount: Int = 1
    
    // State for the "Undo" feature
    // We only need to store the count of revealed letters
    @State private var history: [Int] = []
    
    // Computed property for the partially revealed word
    var displayedWord: String {
        String(secretWord.prefix(revealedCount))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            
            Spacer()
            
            // --- Displayed Word ---
            Text(displayedWord)
                .font(.system(size: 64, weight: .bold, design: .rounded))
                .kerning(5) // Add spacing between letters
                .padding()
            
            Text("The word has \(secretWord.count) letters.")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Spacer()
            
            // --- Game Actions for Word Master ---
            VStack(spacing: 12) {
                // "Reveal Next Letter" button
                Button(action: revealNextLetter) {
                    Text("Reveal Next Letter")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .font(.headline)
                        .cornerRadius(12)
                }
                // Disable if all letters are already revealed
                .disabled(revealedCount == secretWord.count)
                
                // "Guessers Got It!" button
                Button(action: {
                    // Win condition
                    navigateToResult(didWin: true, reason: "You guessed the word!")
                }) {
                    Text("Guessers Got It!")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .font(.headline)
                        .cornerRadius(12)
                }
                
                // "Guessers Give Up" button
                Button(action: {
                    // Lose condition
                    navigateToResult(didWin: false, reason: "You gave up!")
                }) {
                    Text("Guessers Give Up")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .font(.headline)
                        .cornerRadius(12)
                }
            }
            
            // --- Undo Button ---
            Button(action: undoLastAction) {
                Label("Undo Last Letter Reveal", systemImage: "arrow.uturn.backward")
            }
            .disabled(history.isEmpty) // Disable if no history
            .padding(.top, 30)
            
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Contact")
    }
    
    // --- Game Logic Functions ---
    
    func saveCurrentState() {
        // Save the current letter count to the history
        history.append(revealedCount)
    }
    
    func revealNextLetter() {
        saveCurrentState()
        
        // Reveal next letter
        if revealedCount < secretWord.count {
            revealedCount += 1
        }
        
        // Check for win condition (all letters revealed)
        if revealedCount == secretWord.count {
            navigateToResult(didWin: true, reason: "All letters were revealed!")
        }
    }

    func undoLastAction() {
        // Restore the previous letter count from history
        guard let lastCount = history.popLast() else { return }
        self.revealedCount = lastCount
    }
    
    func navigateToResult(didWin: Bool, reason: String) {
        navPath.append(GameNavigation.contactResult(
            didGuessersWin: didWin,
            secretWord: secretWord,
            reason: reason
        ))
    }
}

struct ContactGameView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContactGameView(
                navPath: .constant(NavigationPath()),
                secretWord: "ELEPHANT"
            )
        }
    }
}
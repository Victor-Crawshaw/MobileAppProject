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
        // NEW: ZStack for gradient
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.7),
                    Color.cyan.opacity(0.7)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                
                Spacer()
                
                // --- Displayed Word ---
                // MODIFIED: Styled to match 20Q "Question #"
                Text(displayedWord)
                    .font(.system(size: 80, weight: .bold, design: .rounded))
                    .kerning(5) // Add spacing between letters
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 5, y: 5)
                    .padding()
                
                Text("The word has \(secretWord.count) letters.")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.8)) // MODIFIED: Color
                
                Spacer()
                
                // --- Game Actions for Word Master ---
                // MODIFIED: Switched to Capsule buttons
                VStack(spacing: 15) {
                    
                    // MODIFIED: "Reveal Next Letter" button (Primary Green)
                    Button(action: revealNextLetter) {
                        Text("Reveal Next Letter")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                Capsule()
                                    .fill(Color.green.gradient)
                                    .shadow(color: .black.opacity(0.2), radius: 4, y: 4)
                            )
                            .foregroundColor(.white)
                    }
                    
                    // MODIFIED: "Guesser Won" button (Primary Green)
                    Button(action: {
                        navigateToResult(didWin: true, reason: "You guessed the word!")
                    }) {
                        Text("Guesser Won!")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                Capsule()
                                    .fill(Color.green.gradient)
                                    .shadow(color: .black.opacity(0.2), radius: 4, y: 4)
                            )
                            .foregroundColor(.white)
                    }
                    
                    // MODIFIED: "Give Up" button (Destructive Red)
                    Button(action: {
                        navigateToResult(didWin: false, reason: "The guessers gave up!")
                    }) {
                        Text("Give Up")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                Capsule()
                                    .fill(Color.red.gradient) // Red for destructive
                                    .shadow(color: .black.opacity(0.2), radius: 4, y: 4)
                            )
                            .foregroundColor(.white)
                    }
                    
                }
                .padding(.horizontal, 30)
                
                // MODIFIED: "Undo" button (Secondary Stroked)
                Button(action: undoLastAction) {
                    Text("Undo Last Reveal")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            Capsule()
                                .stroke(Color.white.opacity(0.7), lineWidth: 2)
                                .fill(Color.white.opacity(0.2))
                        )
                        .foregroundColor(.white)
                }
                .disabled(history.isEmpty) // Disable if no history
                .padding(.top, 30)
                .padding(.horizontal, 30)
                
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Contact")
    }
    
    // --- Game Logic Functions (UNCHANGED) ---
    
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
        NavigationStack { // MODIFIED: Use NavigationStack
            ContactGameView(
                navPath: .constant(NavigationPath()),
                secretWord: "ELEPHANT"
            )
        }
    }
}

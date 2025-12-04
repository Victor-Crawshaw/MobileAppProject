// Views/Contact/ContactGameView.swift
import SwiftUI

struct ContactGameView: View {
    
    // MARK: - Properties
    @Binding var navPath: NavigationPath
    let secretWord: String
    let timeLimit: TimeInterval?
    
    // --- Game State ---
    // Tracks how many letters of the secret word are currently shown
    @State private var revealedCount: Int = 1
    // Tracks history for Undo functionality
    @State private var history: [Int] = []
    
    // --- Timer State ---
    @State private var timeRemaining: TimeInterval = 0
    @State private var timerRunning = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // Computed property to show only the revealed portion
    var displayedWord: String {
        String(secretWord.prefix(revealedCount))
    }
    
    // Formats time remaining for display
    var timeString: String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var body: some View {
        ZStack {
            // MARK: Background
            Color(red: 0.05, green: 0.0, blue: 0.15).ignoresSafeArea()
            
            // Background Glow (Changes color based on timer urgency)
            GeometryReader { geo in
                Circle()
                    .fill(timeLimit != nil && timeRemaining < 30 ? Color.red.opacity(0.1) : Color.blue.opacity(0.1))
                    .frame(width: 400, height: 400)
                    .blur(radius: 80)
                    .position(x: geo.size.width / 2, y: geo.size.height * 0.3)
            }
            
            VStack(spacing: 30) {
                
                // MARK: 1. HUD Header
                HStack {
                    // Abort Button (Resets Navigation)
                    Button(action: {
                        navPath = NavigationPath() // Reset to Home
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "xmark.circle.fill")
                            Text("ABORT GAME")
                        }
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(.red.opacity(0.8))
                        .padding(8)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    Spacer()
                    
                    // Timer Display (if enabled)
                    if timeLimit != nil {
                        Text(timeString)
                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                            .foregroundColor(timeRemaining < 30 ? .red : .orange)
                            .padding(8)
                            .background(RoundedRectangle(cornerRadius: 8).stroke(timeRemaining < 30 ? Color.red : Color.orange, lineWidth: 1))
                    }
                }
                .padding(.top, 10)
                .padding(.horizontal)
                
                Spacer()
                
                // MARK: 2. The Word Display
                VStack(spacing: 15) {
                    Text("CURRENT REVEAL")
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(.teal)
                        .tracking(3)
                    
                    // Shows the letters revealed so far
                    Text(displayedWord)
                        .font(.system(size: 60, weight: .black, design: .monospaced))
                        .foregroundColor(.white)
                        .shadow(color: .purple, radius: 15)
                    
                    // Shows dashes for the remaining hidden letters
                    HStack(spacing: 5) {
                        ForEach(0..<(secretWord.count - revealedCount), id: \.self) { _ in
                            Circle()
                                .fill(Color.white.opacity(0.2))
                                .frame(width: 8, height: 8)
                        }
                    }
                }
                
                Spacer()
                
                // MARK: 3. Game Controls
                VStack(spacing: 20) {
                    
                    // REVEAL LETTER Button
                    // Used when the guessers successfully make "Contact"
                    Button(action: revealNextLetter) {
                        HStack {
                            Image(systemName: "eye.fill")
                            Text("REVEAL NEXT LETTER")
                        }
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .shadow(color: .blue.opacity(0.5), radius: 10)
                    }
                    .buttonStyle(BouncyGameButtonStyle())
                    
                    HStack(spacing: 15) {
                        // UNDO Button
                        // Reverts the last "Reveal" action
                        Button(action: undoLastAction) {
                            HStack {
                                Image(systemName: "arrow.uturn.backward")
                                Text("UNDO")
                            }
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        .disabled(history.isEmpty) // Disable if nothing to undo
                        .opacity(history.isEmpty ? 0.5 : 1.0)
                        
                        // GIVE UP Button
                        // Triggers a Loss for the Guessers
                        Button(action: giveUp) {
                            HStack {
                                Image(systemName: "flag.fill")
                                Text("GIVE UP")
                            }
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.2))
                            .foregroundColor(.red)
                            .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            // Initialize timer if a limit was set
            if let limit = timeLimit {
                timeRemaining = limit
                timerRunning = true
            }
        }
        .onReceive(timer) { _ in
            guard timerRunning, timeLimit != nil else { return }
            
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timerRunning = false
                navigateToResult(didWin: false, reason: "Time Ran Out!")
            }
        }
    }
    
    // MARK: - Logic Functions
    
    // Advances the game state by showing one more letter
    func revealNextLetter() {
        history.append(revealedCount) // Save state for undo
        if revealedCount < secretWord.count {
            revealedCount += 1
        }
        
        // Win Condition: Word is fully revealed
        if revealedCount == secretWord.count {
            timerRunning = false
            navigateToResult(didWin: true, reason: "The word was fully revealed!")
        }
    }

    // Reverts the last reveal
    func undoLastAction() {
        guard let lastCount = history.popLast() else { return }
        self.revealedCount = lastCount
    }
    
    // Manual surrender
    func giveUp() {
        navigateToResult(didWin: false, reason: "The Guessers Surrendered.")
    }
    
    // Helper to push the Result View
    func navigateToResult(didWin: Bool, reason: String) {
        navPath.append(GameNavigation.contactResult(
            didGuessersWin: didWin,
            secretWord: secretWord,
            reason: reason
        ))
    }
}

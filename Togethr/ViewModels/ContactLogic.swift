import Foundation
import SwiftUI

// MARK: - View Model 1: Setup Logic
class ContactSetupViewModel: ObservableObject {
    // Inputs
    @Published var secretWord: String = ""
    @Published var isTimerEnabled: Bool = false
    @Published var timerDurationMinutes: Int = 5
    
    // Outputs
    @Published var errorMessage: String?
    
    // Validation Logic
    func validateSettings() -> Bool {
        let cleaned = secretWord.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        // Rule 1: Minimum length
        if cleaned.count < 3 {
            errorMessage = "Word must be at least 3 letters."
            return false
        }
        
        // Rule 2: Letters only
        if !cleaned.allSatisfy({ $0.isLetter }) {
            errorMessage = "Letters only, please (no numbers or symbols)."
            return false
        }
        
        errorMessage = nil
        return true
    }
    
    // Helper to prepare data for the next screen
    func getCleanedWord() -> String {
        return secretWord.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    }
    
    func getTimeLimit() -> TimeInterval? {
        return isTimerEnabled ? TimeInterval(timerDurationMinutes * 60) : nil
    }
}

// MARK: - View Model 2: Game Logic
class ContactGameViewModel: ObservableObject {
    
    // Game Configuration
    let secretWord: String
    let timeLimit: TimeInterval?
    
    // Game State
    @Published var revealedCount: Int = 1
    @Published var history: [Int] = [] // For undo
    
    // Timer State
    @Published var timeRemaining: TimeInterval
    @Published var isTimerRunning: Bool = false
    
    // Outcome State (Observables for View to trigger navigation)
    @Published var gameOver: Bool = false
    @Published var didWin: Bool = false
    @Published var endReason: String = ""
    
    init(secretWord: String, timeLimit: TimeInterval?) {
        self.secretWord = secretWord
        self.timeLimit = timeLimit
        self.timeRemaining = timeLimit ?? 0
        
        // Start timer logic if applicable
        if timeLimit != nil {
            self.isTimerRunning = true
        }
    }
    
    // Computed: What the users actually see (e.g., "AST...")
    var displayedWord: String {
        return String(secretWord.prefix(revealedCount))
    }
    
    var timeString: String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    // MARK: - Intents
    
    func revealNextLetter() {
        // Save current state for undo
        history.append(revealedCount)
        
        if revealedCount < secretWord.count {
            revealedCount += 1
        }
        
        checkWinCondition()
    }
    
    func undoLastAction() {
        guard let previousState = history.popLast() else { return }
        revealedCount = previousState
    }
    
    func giveUp() {
        finishGame(win: false, reason: "The Guessers Surrendered.")
    }
    
    // Called by the View's Timer publisher every second
    func tick() {
        guard isTimerRunning, timeLimit != nil else { return }
        
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            finishGame(win: false, reason: "Time Ran Out!")
        }
    }
    
    // MARK: - Private Helpers
    
    private func checkWinCondition() {
        if revealedCount == secretWord.count {
            finishGame(win: true, reason: "The word was fully revealed!")
        }
    }
    
    private func finishGame(win: Bool, reason: String) {
        isTimerRunning = false
        didWin = win
        endReason = reason
        gameOver = true
    }
}

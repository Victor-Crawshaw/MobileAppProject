import SwiftUI

class HangmanGameViewModel: ObservableObject {
    
    // MARK: - Inputs
    let secretWord: String
    
    // MARK: - Published State
    @Published var guessedLetters: Set<Character> = []
    @Published var incorrectGuesses: Int = 0
    
    // Game Status
    @Published var isGameOver: Bool = false
    @Published var didWin: Bool = false
    
    // Constants
    let maxIncorrectGuesses = 6
    
    // MARK: - Initialization
    init(secretWord: String) {
        self.secretWord = secretWord
    }
    
    // MARK: - Computed Properties
    
    var normalizedSecret: String {
        secretWord.uppercased()
    }
    
    /// Returns the word with hidden letters as underscores (e.g., "H _ L L _")
    var displayWord: String {
        normalizedSecret.map { char in
            if char.isLetter {
                return guessedLetters.contains(char) ? String(char) : "_"
            } else {
                return String(char) // Spaces or punctuation are always shown
            }
        }.joined(separator: " ")
    }
    
    var remainingLives: Int {
        maxIncorrectGuesses - incorrectGuesses
    }
    
    // MARK: - Intentions (Actions)
    
    func guess(_ letter: Character) {
        // Guard 1: Game must be active
        guard !isGameOver else { return }
        
        // Guard 2: Letter already guessed?
        guard !guessedLetters.contains(letter) else { return }
        
        guessedLetters.insert(letter)
        
        if !normalizedSecret.contains(letter) {
            incorrectGuesses += 1
        }
        
        checkGameStatus()
    }
    
    // Determines if a specific letter button should be green, red, or disabled
    func getStatus(for letter: Character) -> LetterStatus {
        if !guessedLetters.contains(letter) { return .unused }
        if normalizedSecret.contains(letter) { return .correct }
        return .incorrect
    }
    
    private func checkGameStatus() {
        let lettersInSecret = Set(normalizedSecret.filter { $0.isLetter })
        let hasWon = lettersInSecret.isSubset(of: guessedLetters)
        let hasLost = incorrectGuesses >= maxIncorrectGuesses
        
        if hasWon {
            didWin = true
            isGameOver = true
        } else if hasLost {
            didWin = false
            isGameOver = true
        }
    }
}
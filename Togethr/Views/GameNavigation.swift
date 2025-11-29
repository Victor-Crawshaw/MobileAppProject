// Views/GameNavigation.swift
import Foundation

// Enum to define all possible navigation destinations
// Making it Hashable allows it to be used in a NavigationPath
enum GameNavigation: Hashable {
    case twentyQuestionsStart
    case contactStart
    case hangmanStart
    
    // --- 20 Questions Flow ---
    case twentyQuestionsCategory
    case twentyQuestionsSecretInput(category: String)
    case twentyQuestionsConfirm(category: String, secretWord: String)
    case twentyQuestionsGame(category: String, secretWord: String)
    case twentyQuestionsResult(didWin: Bool, questionLog: [RecordedQuestion], category: String, secretWord: String)
    
    // --- Contact Flow ---
    case contactWordSetup
    // UPDATED: Added timeLimit parameter
    case contactGame(secretWord: String, timeLimit: TimeInterval?)
    case contactResult(didGuessersWin: Bool, secretWord: String, reason: String)
    
    // --- Hangman Flow ---
    case hangmanWordSetup
    case hangmanConfirm(secretWord: String)
    case hangmanGame(secretWord: String)
    case hangmanResult(didWin: Bool, secretWord: String, incorrectGuesses: Int)

    case telestrationsStart
    case telestrationsSetup // Player count selection
    case telestrationsPass(context: TelepathyContext) // Interstitial "Pass Device"
    case telestrationsTurn(context: TelepathyContext) // The actual Drawing or Guessing
    case telestrationsResult(context: TelepathyContext)
}

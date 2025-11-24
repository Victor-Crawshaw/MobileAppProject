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
    case contactGame(secretWord: String)
    case contactResult(didGuessersWin: Bool, secretWord: String, reason: String)
    
    // --- Hangman Flow ---
    case hangmanWordSetup
    case hangmanConfirm(secretWord: String)
    case hangmanGame(secretWord: String)
    case hangmanResult(didWin: Bool, secretWord: String, incorrectGuesses: Int)
}
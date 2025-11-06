// Views/GameNavigation.swift
import Foundation

// Enum to define all possible navigation destinations
// Making it Hashable allows it to be used in a NavigationPath
enum GameNavigation: Hashable {
    case twentyQuestionsStart
    case contactStart
    
    // --- 20 Questions Flow (MODIFIED) ---
    case twentyQuestionsCategory
    
    // NEW case for the input screen
    case twentyQuestionsSecretInput(category: String)
    
    // MODIFIED to include secretWord
    case twentyQuestionsConfirm(category: String, secretWord: String)
    case twentyQuestionsGame(category: String, secretWord: String)
    case twentyQuestionsResult(didWin: Bool, questionLog: [RecordedQuestion], category: String, secretWord: String)
    
    // --- Contact Flow (Unchanged from your version) ---
    case contactWordSetup
    case contactGame(secretWord: String)
    case contactResult(didGuessersWin: Bool, secretWord: String, reason: String)
}

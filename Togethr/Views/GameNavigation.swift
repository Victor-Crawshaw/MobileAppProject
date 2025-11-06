// Views/GameNavigation.swift
import Foundation

// Enum to define all possible navigation destinations
// Making it Hashable allows it to be used in a NavigationPath
enum GameNavigation: Hashable {
    case twentyQuestionsStart
    case contactStart
    
    // 20 Questions Flow
    case twentyQuestionsCategory
    case twentyQuestionsConfirm(category: String)
    case twentyQuestionsGame(category: String)
    case twentyQuestionsResult(didWin: Bool, questionLog: [RecordedQuestion], category: String)
    
    // --- NEW: Simplified Contact Flow ---
    case contactWordSetup // Replaces player setup
    case contactGame(secretWord: String) // No longer passes players
    
    // Result now reflects win/lose for the group
    case contactResult(didGuessersWin: Bool, secretWord: String, reason: String)
}
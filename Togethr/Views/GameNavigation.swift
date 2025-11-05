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
    
    // MODIFIED: Pass the game log instead of just the count
    case twentyQuestionsResult(didWin: Bool, questionLog: [RecordedQuestion], category: String)
}

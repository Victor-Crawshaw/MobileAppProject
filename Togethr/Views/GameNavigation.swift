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
    case twentyQuestionsResult(didWin: Bool, questionCount: Int, category: String)
}


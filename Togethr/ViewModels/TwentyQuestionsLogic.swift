import Foundation
import SwiftUI

// MARK: - Data Models
// Shared models used by GameView, ResultView, and the Logic

enum Answer: String, CaseIterable, Codable, Hashable {
    case yes, no, unknown
}

struct RecordedQuestion: Identifiable, Equatable, Codable, Hashable {
    var id = UUID()
    let questionText: String
    var answer: Answer
}

// MARK: - View Model 1: Secret Input Logic
class SecretInputViewModel: ObservableObject {
    @Published var textInput: String = ""
    let category: String
    
    init(category: String) {
        self.category = category
    }
    
    var placeholderText: String {
        if category.contains("Animals") { return "e.g. Dolphin" }
        if category.contains("Food") { return "e.g. Pizza" }
        if category.contains("People") { return "e.g. Taylor Swift" }
        if category.contains("Movies") { return "e.g. Star Wars" }
        if category.contains("Objects") { return "e.g. Toaster" }
        if category.contains("Places") { return "e.g. Paris" }
        return "e.g. Magic"
    }
    
    var isInputValid: Bool {
        return !textInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

// MARK: - View Model 2: Game Logic
// RENAMED: Was GameViewModel, now specific to this game
class TwentyQuestionsGameViewModel: ObservableObject {
    
    // Properties
    let category: String
    let secretWord: String
    
    // State
    @Published var questionLog: [RecordedQuestion] = []
    @Published var currentQuestionText: String = ""
    @Published var questionAwaitingAnswer: Bool = false
    
    init(category: String, secretWord: String) {
        self.category = category
        self.secretWord = secretWord
    }
    
    // MARK: - Intents (Actions)
    
    /// Called when the user finishes recording or typing a question
    func submitQuestion(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        currentQuestionText = trimmed
        questionAwaitingAnswer = true
    }
    
    /// Called when the Knower answers Yes or No
    func provideAnswer(_ answer: Answer) {
        guard questionAwaitingAnswer else { return }
        
        // Create the record
        let newRecord = RecordedQuestion(questionText: currentQuestionText, answer: answer)
        
        // Append to log
        questionLog.append(newRecord)
        
        // Reset state for next round
        currentQuestionText = ""
        questionAwaitingAnswer = false
    }
    
    /// Cancel the current question (if user wants to re-record)
    func cancelQuestion() {
        questionAwaitingAnswer = false
        currentQuestionText = ""
    }
    
    /// Removes the last entry (Undo functionality)
    func undoLastLog() {
        guard !questionLog.isEmpty else { return }
        questionLog.removeLast()
        // Reset state to ensure UI is ready for input
        cancelQuestion()
    }
}

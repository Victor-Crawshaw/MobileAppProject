// Models/RecordedQuestion.swift
import Foundation

// Enum to represent the answer
enum Answer: String, Codable, Hashable {
    case yes
    case no
}

// Struct to hold one question-and-answer entry
struct RecordedQuestion: Identifiable, Codable, Hashable {
    let id = UUID()
    let questionText: String
    let answer: Answer
}

// Models/TelepathyModels.swift
import SwiftUI
import PencilKit

// Defines the data for a single step in the game
enum TelepathyEntry: Hashable, Codable {
    case text(String)
    case drawing(Data) // PKDrawing data
}

// The context passed through the navigation stack
struct TelepathyContext: Hashable, Codable {
    let playerCount: Int
    var history: [TelepathyEntry]
    
    // Helper to determine the next player's index (1-based for UI)
    var nextPlayerNumber: Int {
        return history.count + 1
    }
    
    // Helper to check if the game is over
    var isGameOver: Bool {
        return history.count >= playerCount
    }
}
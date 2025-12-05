// ViewModels/TelestrationsViewModel.swift
import SwiftUI
import PencilKit

class TelestrationsViewModel: ObservableObject {
    
    // MARK: - Game State
    @Published var context: TelepathyContext
    @Published var playerCount: Int
    
    // MARK: - Turn Input State
    @Published var textInput: String = ""
    @Published var drawing: PKDrawing = PKDrawing()
    @Published var canvasRect: CGRect = .zero
    
    // Drawing Settings
    @Published var selectedColor: Color = .black
    @Published var strokeWidth: Double = 5.0
    @Published var isEraserActive: Bool = false
    
    // MARK: - Initialization
    init(initialContext: TelepathyContext = TelepathyContext(playerCount: 4, history: []), 
         initialPlayerCount: Int = 4) {
        self.context = initialContext
        self.playerCount = initialPlayerCount
    }
    
    // MARK: - Computed Properties
    
    /// Determines if the current round requires drawing (true) or text guessing (false)
    var isDrawingRound: Bool {
        guard let last = context.history.last else { return false }
        switch last {
        case .text: return true    // Previous was text -> Now we draw
        case .drawing: return false // Previous was drawing -> Now we guess
        }
    }
    
    /// Determines if the "Submit/Done" button should be enabled
    var canSubmit: Bool {
        if isDrawingRound {
            return !drawing.bounds.isEmpty
        } else {
            return !textInput.trimmingCharacters(in: .whitespaces).isEmpty
        }
    }
    
    /// Returns the text for the prompt/mission based on game state
    var missionLabel: String {
        return isDrawingRound ? "MISSION: DRAW THIS" : "MISSION: GUESS THIS"
    }
    
    /// Returns the label for the submit button
    var submitButtonLabel: String {
        return (context.history.count + 1 == context.playerCount) ? "FINISH GAME" : "LOCK IN & PASS"
    }

    // MARK: - Actions
    
    /// Updates player count within bounds (2-12)
    func incrementPlayerCount() {
        if playerCount < 12 { playerCount += 1 }
    }
    
    func decrementPlayerCount() {
        if playerCount > 2 { playerCount -= 1 }
    }
    
    /// Starts a new game chain
    func startGame() -> TelepathyContext {
        return TelepathyContext(playerCount: playerCount, history: [])
    }
    
    /// Submits the current turn (text or drawing) and returns the updated context
    /// Returns nil if submission is invalid (e.g., empty text)
    func submitTurn() -> TelepathyContext? {
        guard canSubmit else { return nil }
        
        var nextHistory = context.history
        
        if isDrawingRound {
            // Logic to capture image data
            let captureRect = calculateCaptureRect()
            
            // FIX START: Force Image Generation to happen in Light Mode traits
            // This ensures Black ink remains Black, preventing PencilKit from inverting it 
            // to White when the system is in Dark Mode (which results in invisible drawings on white backgrounds).
            var image = UIImage()
            let traitCollection = UITraitCollection(userInterfaceStyle: .light)
            traitCollection.performAsCurrent {
                image = drawing.image(from: captureRect, scale: 1.0)
            }
            // FIX END
            
            if let pngData = image.pngData() {
                nextHistory.append(.drawing(pngData))
            } else {
                // Fallback for empty/invalid drawings
                nextHistory.append(.drawing(Data())) 
            }
            
        } else {
            nextHistory.append(.text(textInput))
        }
        
        var nextContext = context
        nextContext.history = nextHistory
        return nextContext
    }
    
    /// Reset input fields for the next turn
    func resetInputs() {
        textInput = ""
        drawing = PKDrawing()
        isEraserActive = false
    }
    
    /// Helper to calculate the drawing bounds
    func calculateCaptureRect() -> CGRect {
        var rect = canvasRect
        if rect.width <= 0 || rect.height <= 0 {
            rect = drawing.bounds.insetBy(dx: -20, dy: -20)
        }
        // Fallback default
        if rect.width <= 0 { rect = CGRect(x: 0, y: 0, width: 300, height: 350) }
        return rect
    }
}
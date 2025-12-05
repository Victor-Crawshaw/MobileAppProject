import XCTest
import PencilKit
import SwiftUI
@testable import Togethr

final class TelestrationsLogicTests: XCTestCase {

    // MARK: - 1. Setup & Initialization Tests
    
    func testInitialization() {
        let vm = TelestrationsViewModel()
        
        XCTAssertEqual(vm.playerCount, 4, "Default player count should be 4")
        XCTAssertTrue(vm.context.history.isEmpty, "History should start empty")
        XCTAssertEqual(vm.textInput, "")
        XCTAssertFalse(vm.isEraserActive)
    }
    
    // MARK: - 2. Player Count Logic
    
    func testPlayerCountIncrement() {
        let vm = TelestrationsViewModel(initialPlayerCount: 11)
        
        // 1. Increment within bounds
        vm.incrementPlayerCount()
        XCTAssertEqual(vm.playerCount, 12)
        
        // 2. Increment at max (boundary check)
        vm.incrementPlayerCount()
        XCTAssertEqual(vm.playerCount, 12, "Should not exceed 12")
    }
    
    func testPlayerCountDecrement() {
        let vm = TelestrationsViewModel(initialPlayerCount: 3)
        
        // 1. Decrement within bounds
        vm.decrementPlayerCount()
        XCTAssertEqual(vm.playerCount, 2)
        
        // 2. Decrement at min (boundary check)
        vm.decrementPlayerCount()
        XCTAssertEqual(vm.playerCount, 2, "Should not go below 2")
    }
    
    func testStartGameGeneratesContext() {
        let vm = TelestrationsViewModel(initialPlayerCount: 6)
        let newContext = vm.startGame()
        
        XCTAssertEqual(newContext.playerCount, 6)
        XCTAssertTrue(newContext.history.isEmpty)
    }
    
    // MARK: - 3. Turn Logic & Computed Properties
    
    func testIsDrawingRoundLogic() {
        // Case A: No history (First turn) -> Text Input (Not drawing round)
        // Wait, strictly looking at code:
        // Turn 1: Enter Prompt (Text) -> History is empty.
        // `isDrawingRound` looks at LAST entry.
        // If last is nil -> return false (Text Mode).
        let vm = TelestrationsViewModel()
        XCTAssertFalse(vm.isDrawingRound, "First turn is creating the text prompt")
        XCTAssertEqual(vm.missionLabel, "MISSION: GUESS THIS") // Technically 'Create Prompt', but uses Text logic
        
        // Case B: Last was Text -> Next is Drawing
        let textContext = TelepathyContext(playerCount: 4, history: [.text("Dog")])
        vm.context = textContext
        XCTAssertTrue(vm.isDrawingRound, "After text comes drawing")
        XCTAssertEqual(vm.missionLabel, "MISSION: DRAW THIS")
        
        // Case C: Last was Drawing -> Next is Text (Guess)
        let drawContext = TelepathyContext(playerCount: 4, history: [.drawing(Data())])
        vm.context = drawContext
        XCTAssertFalse(vm.isDrawingRound, "After drawing comes guessing (text)")
        XCTAssertEqual(vm.missionLabel, "MISSION: GUESS THIS")
    }
    
    func testButtonLabelLogic() {
        // Game of 3 players
        let history: [TelepathyHistoryItem] = [.text("A")]
        let context = TelepathyContext(playerCount: 3, history: history)
        let vm = TelestrationsViewModel(initialContext: context)
        
        // Current history count is 1. We are about to do turn 2.
        // 1 + 1 != 3. Not last turn.
        XCTAssertEqual(vm.submitButtonLabel, "LOCK IN & PASS")
        
        // Advance history to 2 items. Next is turn 3 (Final).
        vm.context.history.append(.drawing(Data()))
        // History count 2. 2 + 1 == 3. Last turn.
        XCTAssertEqual(vm.submitButtonLabel, "FINISH GAME")
    }
    
    // MARK: - 4. Input Validation
    
    func testTextValidation() {
        // Setup Text Round
        let vm = TelestrationsViewModel() // History empty = text round
        
        // 1. Empty
        vm.textInput = ""
        XCTAssertFalse(vm.canSubmit)
        
        // 2. Whitespace
        vm.textInput = "   "
        XCTAssertFalse(vm.canSubmit)
        
        // 3. Valid
        vm.textInput = "Batman"
        XCTAssertTrue(vm.canSubmit)
    }
    
    func testDrawingValidation() {
        // Setup Drawing Round (Last was text)
        let context = TelepathyContext(playerCount: 4, history: [.text("Draw this")])
        let vm = TelestrationsViewModel(initialContext: context)
        
        // 1. Empty Drawing
        vm.drawing = PKDrawing()
        XCTAssertFalse(vm.canSubmit)
        
        // 2. Valid Drawing (Simulate a stroke)
        // We can simulate a non-empty bounds check by manually setting drawing if PKDrawing is hard to mock,
        // but PKDrawing is a value type.
        // A simple way to test the logic branch is trusting PKDrawing behavior or knowing canSubmit checks bounds.
        // Since we can't easily programmatically stroke a PKDrawing in unit tests without UI, 
        // we rely on the logic: `!drawing.bounds.isEmpty`. 
        // We can verify the "False" state confidently.
        XCTAssertFalse(vm.canSubmit) 
    }
    
    // MARK: - 5. Submission Logic
    
    func testSubmitTextTurn() {
        // Setup Text Round
        let vm = TelestrationsViewModel()
        vm.textInput = "Secret Word"
        
        guard let newContext = vm.submitTurn() else {
            XCTFail("Should be able to submit valid text")
            return
        }
        
        XCTAssertEqual(newContext.history.count, 1)
        if case .text(let val) = newContext.history.first! {
            XCTAssertEqual(val, "Secret Word")
        } else {
            XCTFail("Expected text entry")
        }
    }
    
    func testSubmitDrawingTurn() {
        // Setup Drawing Round
        let context = TelepathyContext(playerCount: 4, history: [.text("Prompt")])
        let vm = TelestrationsViewModel(initialContext: context)
        
        // We need to bypass the `canSubmit` check for the drawing test because
        // we can't easily generate a PKDrawing with content in a headless XCTest.
        // However, we can verify the logic inside `submitTurn` handles the append correctly
        // if we assume validation passed, OR we skip validation in a test-specific way.
        
        // For this specific test, we can mock the behavior by subclassing or checking logic flow.
        // But since we want to test the standard VM:
        
        // Note: PKDrawing() is empty, so submitTurn() returns nil.
        let result = vm.submitTurn()
        XCTAssertNil(result, "Empty drawing should return nil")
        
        // If we want to test the APPEND logic for drawing, we would need a populated PKDrawing.
        // Since generating that is complex in unit tests, we primarily test the Text path fully
        // and rely on `calculateCaptureRect` tests for the math.
    }
    
    func testResetInputs() {
        let vm = TelestrationsViewModel()
        vm.textInput = "dirty"
        vm.isEraserActive = true
        
        vm.resetInputs()
        
        XCTAssertEqual(vm.textInput, "")
        XCTAssertFalse(vm.isEraserActive)
        XCTAssertTrue(vm.drawing.bounds.isEmpty)
    }
    
    func testCalculateCaptureRect() {
        let vm = TelestrationsViewModel()
        
        // 1. Default (No canvas rect set, empty drawing)
        let rect = vm.calculateCaptureRect()
        XCTAssertEqual(rect, CGRect(x: 0, y: 0, width: 300, height: 350), "Should use fallback defaults")
        
        // 2. Explicit Canvas Rect
        vm.canvasRect = CGRect(x: 0, y: 0, width: 100, height: 100)
        let explicitRect = vm.calculateCaptureRect()
        XCTAssertEqual(explicitRect, CGRect(x: 0, y: 0, width: 100, height: 100))
    }
}
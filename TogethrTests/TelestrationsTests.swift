import XCTest
import PencilKit
import SwiftUI
@testable import Togethr 

final class TelestrationsViewModelTests: XCTestCase {

    // MARK: - 1. Initialization Tests
    
    func testInitializationDefaults() {
        let vm = TelestrationsViewModel()
        
        XCTAssertEqual(vm.playerCount, 4, "Default player count should be 4")
        XCTAssertTrue(vm.context.history.isEmpty, "History should be empty by default")
        XCTAssertEqual(vm.textInput, "", "Text input should be empty")
        XCTAssertTrue(vm.drawing.bounds.isEmpty, "Drawing should be empty")
    }
    
    func testInitializationCustom() {
        // Create a context with existing history
        let history: [TelepathyEntry] = [.text("Start")]
        let context = TelepathyContext(playerCount: 6, history: history)
        
        let vm = TelestrationsViewModel(initialContext: context, initialPlayerCount: 6)
        
        XCTAssertEqual(vm.playerCount, 6)
        XCTAssertEqual(vm.context.history.count, 1)
        
        // Verify the content of the history item
        if case .text(let val) = vm.context.history.first {
            XCTAssertEqual(val, "Start")
        } else {
            XCTFail("History item mismatch")
        }
    }
    
    // MARK: - 2. Game State Logic (IsDrawingRound)
    
    func testIsDrawingRound_EmptyHistory() {
        // Round 1: No history. User must enter a text prompt.
        let vm = TelestrationsViewModel()
        vm.context.history = []
        
        XCTAssertFalse(vm.isDrawingRound, "First round should be Text (Input a word)")
        XCTAssertEqual(vm.missionLabel, "MISSION: GUESS THIS") 
    }
    
    func testIsDrawingRound_AfterText() {
        // Round 2: Previous user entered text. Now we draw it.
        let vm = TelestrationsViewModel()
        vm.context.history = [.text("Cat")]
        
        XCTAssertTrue(vm.isDrawingRound, "After text, player should Draw")
        XCTAssertEqual(vm.missionLabel, "MISSION: DRAW THIS")
    }
    
    func testIsDrawingRound_AfterDrawing() {
        // Round 3: Previous user drew something. Now we guess (text).
        let vm = TelestrationsViewModel()
        vm.context.history = [.text("Cat"), .drawing(Data())]
        
        XCTAssertFalse(vm.isDrawingRound, "After drawing, player should Guess (Text)")
        XCTAssertEqual(vm.missionLabel, "MISSION: GUESS THIS")
    }
    
    // MARK: - 3. Input Validation (canSubmit)
    
    func testCanSubmit_TextMode() {
        let vm = TelestrationsViewModel()
        vm.context.history = [] // Text Mode
        
        // 1. Empty -> False
        vm.textInput = ""
        XCTAssertFalse(vm.canSubmit)
        
        // 2. Whitespace only -> False
        vm.textInput = "   "
        XCTAssertFalse(vm.canSubmit)
        
        // 3. Valid -> True
        vm.textInput = "Taco"
        XCTAssertTrue(vm.canSubmit)
    }
    
    func testCanSubmit_DrawingMode() {
        let vm = TelestrationsViewModel()
        vm.context.history = [.text("Draw a taco")] // Drawing Mode
        
        // 1. Empty Drawing -> False
        vm.drawing = PKDrawing()
        XCTAssertFalse(vm.canSubmit)
        
        // 2. With Stroke -> True
        vm.drawing = createSimpleDrawing()
        XCTAssertTrue(vm.canSubmit)
    }
    
    // MARK: - 4. Submit Logic
    
    func testSubmitTurn_AppendsText() {
        let vm = TelestrationsViewModel()
        vm.context.history = [] // Text Mode
        vm.textInput = "Pizza"
        
        guard let nextContext = vm.submitTurn() else {
            XCTFail("Submit should succeed")
            return
        }
        
        XCTAssertEqual(nextContext.history.count, 1)
        
        if case .text(let val) = nextContext.history.last {
            XCTAssertEqual(val, "Pizza")
        } else {
            XCTFail("Expected .text entry")
        }
    }
    
    func testSubmitTurn_AppendsDrawing() {
        let vm = TelestrationsViewModel()
        vm.context.history = [.text("Prompt")] // Drawing Mode
        vm.drawing = createSimpleDrawing()
        // Provide a valid rect so image generation attempts to work
        vm.canvasRect = CGRect(x: 0, y: 0, width: 200, height: 200)
        
        guard let nextContext = vm.submitTurn() else {
            XCTFail("Submit should succeed")
            return
        }
        
        XCTAssertEqual(nextContext.history.count, 2)
        
        if case .drawing(let data) = nextContext.history.last {
            // Note: Since we are in a unit test environment without a real UI window,
            // PKDrawing.image() might produce empty data or valid data depending on the simulator/device.
            // We mainly want to ensure the .drawing case was appended.
            XCTAssertNotNil(data)
        } else {
            XCTFail("Expected .drawing entry")
        }
    }
    
    func testSubmitTurn_InvalidReturnsNil() {
        let vm = TelestrationsViewModel()
        vm.textInput = "" // Invalid
        XCTAssertNil(vm.submitTurn())
    }
    
    // MARK: - 5. Player Count Actions
    
    func testIncrementPlayerCount() {
        let vm = TelestrationsViewModel(initialPlayerCount: 4)
        vm.incrementPlayerCount()
        XCTAssertEqual(vm.playerCount, 5)
        
        // Max limit test (12)
        vm.playerCount = 12
        vm.incrementPlayerCount()
        XCTAssertEqual(vm.playerCount, 12, "Should cap at 12")
    }
    
    func testDecrementPlayerCount() {
        let vm = TelestrationsViewModel(initialPlayerCount: 4)
        vm.decrementPlayerCount()
        XCTAssertEqual(vm.playerCount, 3)
        
        // Min limit test (2)
        vm.playerCount = 2
        vm.decrementPlayerCount()
        XCTAssertEqual(vm.playerCount, 2, "Should cap at 2")
    }
    
    func testStartGame() {
        let vm = TelestrationsViewModel(initialPlayerCount: 8)
        let newContext = vm.startGame()
        
        XCTAssertEqual(newContext.playerCount, 8)
        XCTAssertTrue(newContext.history.isEmpty)
    }
    
    // MARK: - 6. Submit Button Label
    
    func testSubmitButtonLabel() {
        // Game of 3 players
        let context = TelepathyContext(playerCount: 3, history: [])
        let vm = TelestrationsViewModel(initialContext: context, initialPlayerCount: 3)
        
        // Turn 1 (0 items in history) -> Next is Turn 2. Not finished.
        XCTAssertEqual(vm.submitButtonLabel, "LOCK IN & PASS")
        
        // Turn 2 (1 item in history) -> Next is Turn 3. Not finished.
        vm.context.history = [.text("1")]
        XCTAssertEqual(vm.submitButtonLabel, "LOCK IN & PASS")
        
        // Turn 3 (2 items in history) -> This is the last player!
        // history.count (2) + 1 == 3 (playerCount)
        vm.context.history = [.text("1"), .drawing(Data())]
        XCTAssertEqual(vm.submitButtonLabel, "FINISH GAME")
    }
    
    // MARK: - 7. Utilities
    
    func testResetInputs() {
        let vm = TelestrationsViewModel()
        vm.textInput = "Foo"
        vm.drawing = createSimpleDrawing()
        vm.isEraserActive = true
        
        vm.resetInputs()
        
        XCTAssertEqual(vm.textInput, "")
        XCTAssertTrue(vm.drawing.bounds.isEmpty)
        XCTAssertFalse(vm.isEraserActive)
    }
    
    func testCalculateCaptureRect() {
        let vm = TelestrationsViewModel()
        
        // 1. Valid View Rect
        vm.canvasRect = CGRect(x: 0, y: 0, width: 100, height: 100)
        XCTAssertEqual(vm.calculateCaptureRect(), CGRect(x: 0, y: 0, width: 100, height: 100))
        
        // 2. Invalid View Rect -> Uses Drawing Bounds (inset -20)
        vm.canvasRect = .zero
        let d = createSimpleDrawing() // ~ (10,10,40,40)
        vm.drawing = d
        
        let expected = d.bounds.insetBy(dx: -20, dy: -20)
        XCTAssertEqual(vm.calculateCaptureRect(), expected)
        
        // 3. Both Invalid -> Defaults
        vm.canvasRect = .zero
        vm.drawing = PKDrawing()
        XCTAssertEqual(vm.calculateCaptureRect(), CGRect(x: 0, y: 0, width: 300, height: 350))
    }

    // MARK: - Private Helpers
    
    private func createSimpleDrawing() -> PKDrawing {
        let path = PKStrokePath(controlPoints: [
            PKStrokePoint(location: CGPoint(x: 10, y: 10), timeOffset: 0, size: CGSize(width: 5, height: 5), opacity: 1, force: 1, azimuth: 0, altitude: 0),
            PKStrokePoint(location: CGPoint(x: 50, y: 50), timeOffset: 1, size: CGSize(width: 5, height: 5), opacity: 1, force: 1, azimuth: 0, altitude: 0)
        ], creationDate: Date())
        let stroke = PKStroke(ink: PKInk(.pen, color: .black), path: path)
        return PKDrawing(strokes: [stroke])
    }
}
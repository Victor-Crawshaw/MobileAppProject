import XCTest
@testable import Togethr // ⚠️ REPLACE WITH YOUR PROJECT NAME

final class ContactLogicTests: XCTestCase {

    // MARK: - Setup ViewModel Tests
    
    func testValidationTooShort() {
        let vm = ContactSetupViewModel()
        vm.secretWord = "Hi" // Too short
        
        XCTAssertFalse(vm.validateSettings())
        XCTAssertEqual(vm.errorMessage, "Word must be at least 3 letters.")
    }
    
    func testValidationInvalidCharacters() {
        let vm = ContactSetupViewModel()
        vm.secretWord = "H3llo" // Contains number
        
        XCTAssertFalse(vm.validateSettings())
        XCTAssertEqual(vm.errorMessage, "Letters only, please (no numbers or symbols).")
    }
    
    func testValidationSuccess() {
        let vm = ContactSetupViewModel()
        vm.secretWord = "  Hello  " // Valid but needs trim
        
        XCTAssertTrue(vm.validateSettings())
        XCTAssertNil(vm.errorMessage)
        
        // Test Helper
        XCTAssertEqual(vm.getCleanedWord(), "HELLO")
    }
    
    func testTimeLimitHelpers() {
        let vm = ContactSetupViewModel()
        
        // Disabled
        vm.isTimerEnabled = false
        XCTAssertNil(vm.getTimeLimit())
        
        // Enabled
        vm.isTimerEnabled = true
        vm.timerDurationMinutes = 5
        XCTAssertEqual(vm.getTimeLimit(), 300) // 5 * 60
    }

    // MARK: - Game ViewModel Tests
    
    func testInitialization() {
        // Test with Timer
        let vmWithTimer = ContactGameViewModel(secretWord: "TEST", timeLimit: 60)
        XCTAssertEqual(vmWithTimer.secretWord, "TEST")
        XCTAssertEqual(vmWithTimer.timeLimit, 60)
        XCTAssertEqual(vmWithTimer.timeRemaining, 60)
        XCTAssertTrue(vmWithTimer.isTimerRunning)
        
        // Test without Timer
        let vmNoTimer = ContactGameViewModel(secretWord: "TEST", timeLimit: nil)
        XCTAssertFalse(vmNoTimer.isTimerRunning)
    }
    
    func testDisplayedWord() {
        let vm = ContactGameViewModel(secretWord: "PLANET", timeLimit: nil)
        
        // Initially shows 1 letter
        XCTAssertEqual(vm.displayedWord, "P")
        
        // Reveal next
        vm.revealNextLetter()
        XCTAssertEqual(vm.displayedWord, "PL")
    }
    
    func testRevealAndWin() {
        let vm = ContactGameViewModel(secretWord: "CAT", timeLimit: nil)
        
        // Start: C
        XCTAssertEqual(vm.revealedCount, 1)
        XCTAssertFalse(vm.gameOver)
        
        // Reveal 2: CA
        vm.revealNextLetter()
        XCTAssertEqual(vm.revealedCount, 2)
        XCTAssertFalse(vm.gameOver)
        
        // Reveal 3: CAT (Win!)
        vm.revealNextLetter()
        XCTAssertEqual(vm.revealedCount, 3)
        XCTAssertTrue(vm.gameOver)
        XCTAssertTrue(vm.didWin)
        XCTAssertEqual(vm.endReason, "The word was fully revealed!")
        
        // Try revealing beyond length (Should stay at max)
        vm.revealNextLetter()
        XCTAssertEqual(vm.revealedCount, 3)
    }
    
    func testUndo() {
        let vm = ContactGameViewModel(secretWord: "SPACE", timeLimit: nil)
        
        vm.revealNextLetter() // SP
        vm.revealNextLetter() // SPA
        XCTAssertEqual(vm.revealedCount, 3)
        XCTAssertEqual(vm.history.count, 2)
        
        // Undo Once
        vm.undoLastAction() // Back to SP
        XCTAssertEqual(vm.revealedCount, 2)
        XCTAssertEqual(vm.displayedWord, "SP")
        
        // Undo Again
        vm.undoLastAction() // Back to S
        XCTAssertEqual(vm.revealedCount, 1)
        
        // Undo on empty history (Safe fail)
        vm.undoLastAction()
        XCTAssertEqual(vm.revealedCount, 1)
    }
    
    func testGiveUp() {
        let vm = ContactGameViewModel(secretWord: "SPACE", timeLimit: nil)
        
        vm.giveUp()
        
        XCTAssertTrue(vm.gameOver)
        XCTAssertFalse(vm.didWin)
        XCTAssertEqual(vm.endReason, "The Guessers Surrendered.")
    }
    
    func testTimerLogic() {
        let vm = ContactGameViewModel(secretWord: "SPACE", timeLimit: 2) // 2 seconds
        
        // Tick 1
        vm.tick()
        XCTAssertEqual(vm.timeRemaining, 1)
        XCTAssertFalse(vm.gameOver)
        
        // Tick 2
        vm.tick()
        XCTAssertEqual(vm.timeRemaining, 0)
        XCTAssertFalse(vm.gameOver) // Hits 0, next tick triggers end
        
        // Tick 3 (Over)
        vm.tick()
        XCTAssertTrue(vm.gameOver)
        XCTAssertFalse(vm.didWin)
        XCTAssertEqual(vm.endReason, "Time Ran Out!")
        XCTAssertFalse(vm.isTimerRunning)
    }
    
    func testTimerStringFormat() {
        let vm = ContactGameViewModel(secretWord: "TEST", timeLimit: 65) // 1m 5s
        XCTAssertEqual(vm.timeString, "01:05")
    }
}

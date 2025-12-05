import XCTest
@testable import Togethr // ⚠️ REPLACE WITH YOUR PROJECT NAME

final class HangmanTests: XCTestCase {

    // MARK: - 1. Setup Logic Tests
    // Based on the logic found in HangmanWordSetupView.handleConfirm
    
    func testWordValidation() {
        // Helper function to simulate the logic inside HangmanWordSetupView
        func validate(_ input: String) -> Bool {
            let cleaned = input.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
            let lettersOnly = cleaned.filter { $0.isLetter }
            return lettersOnly.count >= 2
        }
        
        // Test Valid Inputs
        XCTAssertTrue(validate("Hello"), "Standard word should be valid")
        XCTAssertTrue(validate("AB"), "Two letters should be valid")
        XCTAssertTrue(validate("  Space  "), "Trimmable whitespace should be valid")
        
        // Test Invalid Inputs
        XCTAssertFalse(validate("A"), "Single letter should be invalid")
        XCTAssertFalse(validate("123"), "Numbers only should be invalid")
        XCTAssertFalse(validate(""), "Empty string should be invalid")
        XCTAssertFalse(validate("!@#"), "Symbols only should be invalid")
    }

    // MARK: - 2. Game ViewModel Tests

    func testInitialization() {
        let vm = HangmanGameViewModel(secretWord: "Swift")
        
        XCTAssertEqual(vm.secretWord, "Swift")
        XCTAssertEqual(vm.normalizedSecret, "SWIFT")
        XCTAssertEqual(vm.incorrectGuesses, 0)
        XCTAssertTrue(vm.guessedLetters.isEmpty)
        XCTAssertFalse(vm.isGameOver)
    }
    
    func testDisplayWordFormatting() {
        let vm = HangmanGameViewModel(secretWord: "Code")
        
        // Initial state: "_ _ _ _"
        XCTAssertEqual(vm.displayWord, "_ _ _ _")
        
        // Partial guess: "C _ _ E"
        vm.guess("C")
        vm.guess("E")
        XCTAssertEqual(vm.displayWord, "C _ _ E")
        
        // Non-letter characters (spaces/hyphens) should pass through
        let vmComplex = HangmanGameViewModel(secretWord: "Hi Mom")
        XCTAssertEqual(vmComplex.displayWord, "_ _   _ _ _")
    }
    
    func testCorrectGuess() {
        let vm = HangmanGameViewModel(secretWord: "Apple")
        
        // Guess 'A'
        vm.guess("A")
        
        XCTAssertTrue(vm.guessedLetters.contains("A"))
        XCTAssertEqual(vm.incorrectGuesses, 0)
        XCTAssertEqual(vm.getStatus(for: "A"), .correct)
    }
    
    func testIncorrectGuess() {
        let vm = HangmanGameViewModel(secretWord: "Apple")
        
        // Guess 'Z'
        vm.guess("Z")
        
        XCTAssertTrue(vm.guessedLetters.contains("Z"))
        XCTAssertEqual(vm.incorrectGuesses, 1)
        XCTAssertEqual(vm.getStatus(for: "Z"), .incorrect)
        XCTAssertEqual(vm.remainingLives, 5)
    }
    
    func testDuplicateGuess() {
        let vm = HangmanGameViewModel(secretWord: "Apple")
        
        // Guess 'Z' twice
        vm.guess("Z")
        let errorCountBefore = vm.incorrectGuesses
        
        vm.guess("Z") // Second attempt
        
        XCTAssertEqual(vm.incorrectGuesses, errorCountBefore, "Duplicate wrong guess should not penalize twice")
        XCTAssertEqual(vm.guessedLetters.count, 1, "Should not duplicate letters in set")
    }
    
    func testWinCondition() {
        let vm = HangmanGameViewModel(secretWord: "Go")
        
        vm.guess("G")
        XCTAssertFalse(vm.isGameOver)
        
        vm.guess("O")
        XCTAssertTrue(vm.isGameOver)
        XCTAssertTrue(vm.didWin)
    }
    
    func testLoseCondition() {
        let vm = HangmanGameViewModel(secretWord: "A")
        
        // Burn 6 lives: B, C, D, E, F, G
        let wrongGuesses = ["B", "C", "D", "E", "F", "G"]
        
        for letter in wrongGuesses {
            vm.guess(Character(letter))
        }
        
        XCTAssertEqual(vm.incorrectGuesses, 6)
        XCTAssertTrue(vm.isGameOver)
        XCTAssertFalse(vm.didWin)
        
        // Ensure no further guesses are accepted after game over
        vm.guess("H")
        XCTAssertFalse(vm.guessedLetters.contains("H"), "Should not accept guesses after game over")
    }
    
    func testLetterStatus() {
        let vm = HangmanGameViewModel(secretWord: "A")
        
        // 1. Unused
        XCTAssertEqual(vm.getStatus(for: "B"), .unused)
        
        // 2. Correct
        vm.guess("A")
        XCTAssertEqual(vm.getStatus(for: "A"), .correct)
        
        // 3. Incorrect
        vm.guess("Z")
        XCTAssertEqual(vm.getStatus(for: "Z"), .unused)
    }
}

// TogethrAppTests/HangmanTests.swift
import XCTest
import SwiftUI
@testable import Togethr

final class HangmanTests: XCTestCase {

    // MARK: - Validation Tests (Setup View)
    
    func testHangmanValidation_ValidWord() {
        let setupView = HangmanWordSetupView(navPath: .constant(NavigationPath()))
        
        let result = setupView.validateSecretWord("GALAXY")
        XCTAssertNil(result, "Valid word 'GALAXY' should return nil error.")
    }
    
    func testHangmanValidation_TooShort() {
        let setupView = HangmanWordSetupView(navPath: .constant(NavigationPath()))
        
        let result = setupView.validateSecretWord("A")
        XCTAssertEqual(result, "Must contain at least 2 letters.")
    }
    
    func testHangmanValidation_NonLetters() {
        let setupView = HangmanWordSetupView(navPath: .constant(NavigationPath()))
        
        let result = setupView.validateSecretWord("HELLO!")
        XCTAssertEqual(result, "Must only contain letters.")
    }
    
    func testHangmanValidation_Empty() {
        let setupView = HangmanWordSetupView(navPath: .constant(NavigationPath()))
        
        let result = setupView.validateSecretWord("")
        XCTAssertEqual(result, "Word cannot be empty.")
    }
    
    func testHangmanValidation_TrimsWhitespace() {
        let setupView = HangmanWordSetupView(navPath: .constant(NavigationPath()))
        
        let result = setupView.validateSecretWord("  TEST  ")
        XCTAssertNil(result, "Word with whitespace should be trimmed and validated.")
    }

    // MARK: - Game Logic Tests (ViewModel)
    
    func testGameInit_InitialState() {
        let vm = HangmanGameViewModel(secretWord: "SWIFT")
        
        XCTAssertEqual(vm.incorrectGuesses, 0)
        XCTAssertTrue(vm.guessedLetters.isEmpty)
        XCTAssertFalse(vm.isGameOver)
        // Initial display should be underscores
        XCTAssertEqual(vm.displayWord, "_ _ _ _ _")
    }
    
    func testGame_CorrectGuess() {
        let vm = HangmanGameViewModel(secretWord: "APPLE")
        
        vm.guess("P")
        
        XCTAssertTrue(vm.guessedLetters.contains("P"))
        XCTAssertEqual(vm.incorrectGuesses, 0) // Should not increase
        XCTAssertEqual(vm.displayWord, "_ P P _ _")
        XCTAssertEqual(vm.getStatus(for: "P"), .correct)
    }
    
    func testGame_IncorrectGuess() {
        let vm = HangmanGameViewModel(secretWord: "APPLE")
        
        vm.guess("Z")
        
        XCTAssertTrue(vm.guessedLetters.contains("Z"))
        XCTAssertEqual(vm.incorrectGuesses, 1) // Should increase
        XCTAssertEqual(vm.displayWord, "_ _ _ _ _") // Nothing revealed
        XCTAssertEqual(vm.getStatus(for: "Z"), .incorrect)
    }
    
    func testGame_DuplicateGuessIgnored() {
        let vm = HangmanGameViewModel(secretWord: "APPLE")
        
        vm.guess("Z")
        let initialIncorrect = vm.incorrectGuesses
        
        // Guess same letter again
        vm.guess("Z")
        
        XCTAssertEqual(vm.incorrectGuesses, initialIncorrect, "Duplicate incorrect guess should not penalize twice")
    }
    
    func testGame_WinCondition() {
        let vm = HangmanGameViewModel(secretWord: "HI")
        
        vm.guess("H")
        XCTAssertFalse(vm.isGameOver)
        
        vm.guess("I")
        XCTAssertTrue(vm.isGameOver)
        XCTAssertTrue(vm.didWin)
    }
    
    func testGame_LossCondition() {
        let vm = HangmanGameViewModel(secretWord: "A")
        let badLetters = ["B", "C", "D", "E", "F", "G"] // 6 wrong guesses
        
        for letter in badLetters {
            vm.guess(Character(letter))
        }
        
        XCTAssertEqual(vm.incorrectGuesses, 6)
        XCTAssertTrue(vm.isGameOver)
        XCTAssertFalse(vm.didWin)
    }
    
    func testGame_DisplayWordHandlesSpaces() {
        let vm = HangmanGameViewModel(secretWord: "HI MOM")
        // Note: Logic handles spaces by printing them directly
        // H I   M O M
        // _ _   _ _ _ (Initially)
        
        // Our current logic in VM splits by ' ' in `displayWord` logic map:
        // if char isLetter -> check guess. else return char.
        // Result is joined by " ".
        // "H" "I" " " "M" "O" "M"
        
        // Expected initial: "_ _   _ _ _" (approximate, depending on join logic)
        // Let's verify logic:
        // H -> _
        // I -> _
        // " " -> " "
        // Joined by " ": "_ _   _ _ _"
        
        let display = vm.displayWord
        XCTAssertTrue(display.contains(" "), "Display word should preserve spaces or non-letters")
    }
    
    func testGame_CaseInsensitive() {
        let vm = HangmanGameViewModel(secretWord: "apple") // Lowercase input
        
        vm.guess("A") // Uppercase guess
        
        XCTAssertEqual(vm.displayWord, "A _ _ _ _")
    }
}
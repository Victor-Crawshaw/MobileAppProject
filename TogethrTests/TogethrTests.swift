// TogethrAppTests/TogethrAppTests.swift
import XCTest
import Foundation
import SwiftUI 

// Import your app module to make its code available for testing
@testable import Togethr

final class TogethrAppTests: XCTestCase {

    // --- Test Group 1: Contact Game Validation Logic ---
     
    // We create a "dummy" instance to get access to its validation method.
    // The navPath doesn't matter for these tests.
    let contactSetupView = ContactWordSetupView(navPath: .constant(NavigationPath()))

    // Test case for a perfectly valid word
    func testValidation_ValidWord() {
        // "ELEPHANT" is > 2 letters and all letters.
        // The validator should return `nil` (no error).
        let result = contactSetupView.validateSecretWord("ELEPHANT")
        XCTAssertNil(result, "A valid word should not produce an error.")
    }

    // Test case for a word that is too short
    func testValidation_WordTooShort() {
        // "NO" is only 2 letters.
        let result = contactSetupView.validateSecretWord("NO")
        // We expect a specific error message.
        XCTAssertEqual(result, "Secret word must be at least 3 letters long.")
    }

    // Test case for a word that contains numbers
    func testValidation_WordWithNumbers() {
        let result = contactSetupView.validateSecretWord("SWIFT1")
        XCTAssertEqual(result, "Secret word must only contain letters.")
    }
    
    // Test case for a word that contains symbols
    func testValidation_WordWithSymbols() {
        let result = contactSetupView.validateSecretWord("SWIFT!")
        XCTAssertEqual(result, "Secret word must only contain letters.")
    }

    // Test case for a word that is valid but has whitespace
    func testValidation_WordWithWhitespace() {
        // The validator should trim whitespace before checking.
        // " SWIFT " becomes "SWIFT", which is valid.
        let result = contactSetupView.validateSecretWord(" SWIFT ")
        XCTAssertNil(result, "A valid word with whitespace should be trimmed and pass validation.")
    }
    
    // Test case for an empty string
    func testValidation_EmptyWord() {
        let result = contactSetupView.validateSecretWord("")
        XCTAssertEqual(result, "Secret word must be at least 3 letters long.")
    }

    
    // --- Test Group 2: Game Model & Mock Data ---
    
    // Test that the mock data array isn't empty
    func testGameMockData_IsNotEmpty() {
        let mockData = Game.mockData
        XCTAssertFalse(mockData.isEmpty, "Mock data array should not be empty.")
    }
    
    // Test that the mock data contains the games we expect
    func testGameMockData_ContainsExpectedGames() {
        let mockData = Game.mockData
        
        // `contains` checks if at least one element satisfies the condition
        let has20Questions = mockData.contains { $0.name == "20 Questions" }
        let hasContact = mockData.contains { $0.name == "Contact" }
        
        XCTAssertTrue(has20Questions, "Mock data should include '20 Questions'.")
        XCTAssertTrue(hasContact, "Mock data should include 'Contact'.")
        
        // We can also check the count
        XCTAssertEqual(mockData.count, 2, "Mock data should have exactly 2 games.")
    }
    
    // Test the properties of a specific game model
    func testGameMockData_TwentyQuestionsProperties() {
        let mockData = Game.mockData
        
        // Find the "20 Questions" game
        guard let twentyQuestionsGame = mockData.first(where: { $0.name == "20 Questions" }) else {
            XCTFail("Could not find '20 Questions' game in mock data.")
            return
        }
        
        // Test its properties
        XCTAssertEqual(twentyQuestionsGame.emoji, "🤔")
        XCTAssertEqual(twentyQuestionsGame.mode, .inPerson)
        XCTAssertEqual(twentyQuestionsGame.description, "Guess the secret item in 20 'yes' or 'no' questions.")
    }
}

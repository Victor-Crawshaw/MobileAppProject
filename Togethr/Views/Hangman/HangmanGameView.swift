// Views/Hangman/HangmanGameView.swift
import SwiftUI

struct HangmanGameView: View {
    
    @Binding var navPath: NavigationPath
    let secretWord: String
    
    @State private var guessedLetters: Set<Character> = []
    @State private var incorrectGuesses: Int = 0
    
    private let maxIncorrectGuesses = 6
    private let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    
    // Normalize (Uppercased)
    private var normalizedSecret: String { secretWord.uppercased() }
    
    // Display Logic
    private var displayWord: String {
        normalizedSecret.map { char in
            if char.isLetter {
                return guessedLetters.contains(char) ? String(char) : "_"
            } else {
                return String(char)
            }
        }.joined(separator: " ")
    }
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.05, green: 0.0, blue: 0.15).ignoresSafeArea()
            
            // Glow behind the Hangman
            GeometryReader { geo in
                Circle()
                    .fill(Color.orange.opacity(0.1))
                    .frame(width: 300, height: 300)
                    .blur(radius: 80)
                    .position(x: geo.size.width / 2, y: geo.size.height * 0.25)
            }
            
            VStack(spacing: 0) {
                
                // HUD Header
                HStack {
                    Button(action: { navPath = NavigationPath() }) {
                        HStack(spacing: 5) {
                            Image(systemName: "xmark.circle.fill")
                            Text("ABORT")
                        }
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(.red.opacity(0.8))
                        .padding(8)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                    }
                    Spacer()
                    Text("LIVES: \(maxIncorrectGuesses - incorrectGuesses)")
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(incorrectGuesses > 3 ? .red : .teal)
                }
                .padding()
                
                // Drawing Area
                ZStack {
                    HangmanDrawingView(incorrectGuesses: incorrectGuesses)
                        .frame(width: 200, height: 200)
                }
                .padding(.vertical, 20)
                
                // Word Display
                Text(displayWord)
                    .font(.system(size: 32, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.05))
                
                Spacer()
                
                // Keyboard
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 40), spacing: 8)], spacing: 8) {
                    ForEach(Array(alphabet), id: \.self) { letter in
                        LetterButton(letter: letter, status: getStatus(for: letter)) {
                            guess(letter)
                        }
                    }
                }
                .padding(20)
            }
        }
        .navigationBarHidden(true)
    }
    
    // --- Logic ---
    
    func guess(_ letter: Character) {
        guard !guessedLetters.contains(letter) else { return }
        
        guessedLetters.insert(letter)
        
        if !normalizedSecret.contains(letter) {
            incorrectGuesses += 1
        }
        
        checkGameStatus()
    }
    
    func getStatus(for letter: Character) -> LetterStatus {
        if !guessedLetters.contains(letter) { return .unused }
        if normalizedSecret.contains(letter) { return .correct }
        return .incorrect
    }
    
    func checkGameStatus() {
        let lettersInSecret = Set(normalizedSecret.filter { $0.isLetter })
        let isWon = lettersInSecret.isSubset(of: guessedLetters)
        let isLost = incorrectGuesses >= maxIncorrectGuesses
        
        if isWon {
            navigateToResult(didWin: true)
        } else if isLost {
            navigateToResult(didWin: false)
        }
    }
    
    func navigateToResult(didWin: Bool) {
        // Small delay to let the user see the final move
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            navPath.append(GameNavigation.hangmanResult(
                didWin: didWin,
                secretWord: secretWord,
                incorrectGuesses: incorrectGuesses
            ))
        }
    }
}

// --- Subviews ---

enum LetterStatus {
    case unused, correct, incorrect
}

struct LetterButton: View {
    let letter: Character
    let status: LetterStatus
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(String(letter))
                .font(.system(size: 20, weight: .bold, design: .monospaced))
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(backgroundColor)
                .foregroundColor(foregroundColor)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(borderColor, lineWidth: 1)
                )
        }
        .disabled(status != .unused)
    }
    
    var backgroundColor: Color {
        switch status {
        case .unused: return Color.white.opacity(0.1)
        case .correct: return Color.green.opacity(0.3)
        case .incorrect: return Color.red.opacity(0.3)
        }
    }
    
    var foregroundColor: Color {
        switch status {
        case .unused: return .white
        case .correct: return .green
        case .incorrect: return .red.opacity(0.5)
        }
    }
    
    var borderColor: Color {
        switch status {
        case .unused: return Color.white.opacity(0.2)
        case .correct: return Color.green
        case .incorrect: return Color.red
        }
    }
}

struct HangmanDrawingView: View {
    let incorrectGuesses: Int
    
    var body: some View {
        ZStack {
            // Scaffold (Always visible)
            Group {
                // Base
                RoundedRectangle(cornerRadius: 2).frame(width: 100, height: 6)
                    .offset(y: 90)
                // Pole
                RoundedRectangle(cornerRadius: 2).frame(width: 6, height: 180)
                    .offset(x: -30)
                // Top
                RoundedRectangle(cornerRadius: 2).frame(width: 100, height: 6)
                    .offset(x: 17, y: -90)
                // Rope
                RoundedRectangle(cornerRadius: 1).frame(width: 2, height: 30)
                    .offset(x: 40, y: -75)
            }
            .foregroundColor(.gray.opacity(0.5))
            
            // Body Parts (Neon Style)
            Group {
                if incorrectGuesses >= 1 {
                    Circle().stroke(Color.white, lineWidth: 3)
                        .frame(width: 40, height: 40)
                        .shadow(color: .cyan, radius: 5)
                        .offset(x: 40, y: -40)
                }
                if incorrectGuesses >= 2 {
                    RoundedRectangle(cornerRadius: 2).fill(Color.white)
                        .frame(width: 4, height: 60)
                        .shadow(color: .cyan, radius: 5)
                        .offset(x: 40, y: 10)
                }
                if incorrectGuesses >= 3 { // Left Arm
                    RoundedRectangle(cornerRadius: 2).fill(Color.white)
                        .frame(width: 40, height: 4)
                        .shadow(color: .cyan, radius: 5)
                        .rotationEffect(.degrees(-45))
                        .offset(x: 25, y: -10)
                }
                if incorrectGuesses >= 4 { // Right Arm
                    RoundedRectangle(cornerRadius: 2).fill(Color.white)
                        .frame(width: 40, height: 4)
                        .shadow(color: .cyan, radius: 5)
                        .rotationEffect(.degrees(45))
                        .offset(x: 55, y: -10)
                }
                if incorrectGuesses >= 5 { // Left Leg
                    RoundedRectangle(cornerRadius: 2).fill(Color.white)
                        .frame(width: 40, height: 4)
                        .shadow(color: .cyan, radius: 5)
                        .rotationEffect(.degrees(-45))
                        .offset(x: 25, y: 50)
                }
                if incorrectGuesses >= 6 { // Right Leg
                    RoundedRectangle(cornerRadius: 2).fill(Color.white)
                        .frame(width: 40, height: 4)
                        .shadow(color: .cyan, radius: 5)
                        .rotationEffect(.degrees(45))
                        .offset(x: 55, y: 50)
                }
            }
        }
    }
}

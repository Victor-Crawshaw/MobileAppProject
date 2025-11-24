// Views/Hangman/HangmanGameView.swift
import SwiftUI

struct HangmanGameView: View {
    
    @Binding var navPath: NavigationPath
    let secretWord: String
    
    @State private var guessedLetters: Set<Character> = []
    @State private var incorrectGuesses: Int = 0
    
    private let maxIncorrectGuesses = 6
    private let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    
    // Normalize the secret word (uppercase, preserve spaces)
    private var normalizedSecret: String {
        secretWord.uppercased()
    }
    
    // Get the display string with blanks for unguessed letters
    private var displayWord: String {
        normalizedSecret.map { char in
            if char.isLetter {
                return guessedLetters.contains(char) ? String(char) : "_"
            } else {
                return String(char) // Preserve spaces and punctuation
            }
        }.joined(separator: " ")
    }
    
    // Check if the game is won
    private var isGameWon: Bool {
        let lettersInSecret = Set(normalizedSecret.filter { $0.isLetter })
        return lettersInSecret.isSubset(of: guessedLetters)
    }
    
    // Check if the game is lost
    private var isGameLost: Bool {
        incorrectGuesses >= maxIncorrectGuesses
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.orange.opacity(0.7),
                    Color.red.opacity(0.7)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                
                // Hangman Drawing
                HangmanDrawing(incorrectGuesses: incorrectGuesses)
                    .frame(height: 200)
                    .padding()
                
                // Guesses Remaining
                Text("Guesses Left: \(maxIncorrectGuesses - incorrectGuesses)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                
                // Word Display
                Text(displayWord)
                    .font(.system(size: 32, weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white.opacity(0.2))
                    )
                    .padding(.horizontal)
                
                // Letter Keyboard
                VStack(spacing: 10) {
                    ForEach(0..<3) { row in
                        HStack(spacing: 8) {
                            ForEach(lettersForRow(row), id: \.self) { letter in
                                LetterButton(
                                    letter: letter,
                                    isGuessed: guessedLetters.contains(letter),
                                    action: {
                                        guessLetter(letter)
                                    }
                                )
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .onChange(of: isGameWon) { won in
            if won {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    navPath.append(GameNavigation.hangmanResult(
                        didWin: true,
                        secretWord: secretWord,
                        incorrectGuesses: incorrectGuesses
                    ))
                }
            }
        }
        .onChange(of: isGameLost) { lost in
            if lost {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    navPath.append(GameNavigation.hangmanResult(
                        didWin: false,
                        secretWord: secretWord,
                        incorrectGuesses: incorrectGuesses
                    ))
                }
            }
        }
    }
    
    // Returns letters for each row of the keyboard
    private func lettersForRow(_ row: Int) -> [Character] {
        let rows = [
            Array("QWERTYUIOP"),
            Array("ASDFGHJKL"),
            Array("ZXCVBNM")
        ]
        return rows[row]
    }
    
    // Handle letter guess
    private func guessLetter(_ letter: Character) {
        guard !guessedLetters.contains(letter) else { return }
        
        guessedLetters.insert(letter)
        
        // Check if the letter is in the secret word
        if !normalizedSecret.contains(letter) {
            incorrectGuesses += 1
        }
    }
}

// Letter Button Component
struct LetterButton: View {
    let letter: Character
    let isGuessed: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(String(letter))
                .font(.system(size: 20, weight: .bold))
                .frame(width: 32, height: 44)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isGuessed ? Color.gray.opacity(0.3) : Color.white.opacity(0.9))
                )
                .foregroundColor(isGuessed ? .white.opacity(0.5) : .black)
        }
        .disabled(isGuessed)
    }
}

// Hangman Drawing Component
struct HangmanDrawing: View {
    let incorrectGuesses: Int
    
    var body: some View {
        ZStack {
            // Base
            if incorrectGuesses >= 0 {
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 150, height: 10)
                    .offset(y: 90)
            }
            
            // Post
            if incorrectGuesses >= 0 {
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 10, height: 180)
                    .offset(x: -60, y: 0)
            }
            
            // Top beam
            if incorrectGuesses >= 0 {
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 100, height: 10)
                    .offset(x: -10, y: -85)
            }
            
            // Rope
            if incorrectGuesses >= 0 {
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 4, height: 30)
                    .offset(x: 40, y: -65)
            }
            
            // Head
            if incorrectGuesses >= 1 {
                Circle()
                    .stroke(Color.white, lineWidth: 4)
                    .frame(width: 40, height: 40)
                    .offset(x: 40, y: -35)
            }
            
            // Body
            if incorrectGuesses >= 2 {
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 4, height: 50)
                    .offset(x: 40, y: 5)
            }
            
            // Left arm
            if incorrectGuesses >= 3 {
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 30, height: 4)
                    .rotationEffect(.degrees(-45))
                    .offset(x: 25, y: -5)
            }
            
            // Right arm
            if incorrectGuesses >= 4 {
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 30, height: 4)
                    .rotationEffect(.degrees(45))
                    .offset(x: 55, y: -5)
            }
            
            // Left leg
            if incorrectGuesses >= 5 {
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 30, height: 4)
                    .rotationEffect(.degrees(-45))
                    .offset(x: 25, y: 40)
            }
            
            // Right leg
            if incorrectGuesses >= 6 {
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 30, height: 4)
                    .rotationEffect(.degrees(45))
                    .offset(x: 55, y: 40)
            }
        }
    }
}

struct HangmanGameView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HangmanGameView(
                navPath: .constant(NavigationPath()),
                secretWord: "ELEPHANT"
            )
        }
    }
}

// Views/Hangman/HangmanResultView.swift
import SwiftUI

struct HangmanResultView: View {
    
    @Binding var navPath: NavigationPath
    let didWin: Bool
    let secretWord: String
    let incorrectGuesses: Int
    
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
                Spacer()
                
                // Win/Loss Icon
                if didWin {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.green)
                        .padding(10)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())
                    
                    Text("You Won!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("The word was: \(secretWord.uppercased())")
                        .font(.title3)
                        .foregroundColor(.white)
                    
                    Text("With \(6 - incorrectGuesses) \(6 - incorrectGuesses == 1 ? "guess" : "guesses") remaining!")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                    
                } else {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.red)
                        .padding(10)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())
                    
                    Text("Game Over")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("The word was: \(secretWord.uppercased())")
                        .font(.title3)
                        .foregroundColor(.white)
                    
                    Text("Better luck next time!")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                // Final Hangman Drawing
                HangmanDrawing(incorrectGuesses: incorrectGuesses)
                    .frame(height: 200)
                    .padding()
                
                Spacer()
                
                // Bottom Buttons
                VStack(spacing: 15) {
                    Button(action: {
                        // Pop 3 views: Result, Game, Confirm
                        navPath.removeLast(3)
                    }) {
                        Text("Play Again")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                Capsule()
                                    .fill(Color.green.gradient)
                            )
                            .foregroundColor(.white)
                    }
                    
                    Button(action: {
                        navPath.removeLast(navPath.count)
                    }) {
                        Text("Main Menu")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                Capsule()
                                    .stroke(Color.white.opacity(0.7), lineWidth: 2)
                                    .fill(Color.white.opacity(0.2))
                            )
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 30)
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct HangmanResultView_Previews: PreviewProvider {
    static var previews: some View {
        HangmanResultView(
            navPath: .constant(NavigationPath()),
            didWin: true,
            secretWord: "ELEPHANT",
            incorrectGuesses: 2
        )
        
        HangmanResultView(
            navPath: .constant(NavigationPath()),
            didWin: false,
            secretWord: "ELEPHANT",
            incorrectGuesses: 6
        )
    }
}
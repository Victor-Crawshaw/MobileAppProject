// Views/Contact/ContactResultView.swift
import SwiftUI

struct ContactResultView: View {
    
    @Binding var navPath: NavigationPath
    
    let didGuessersWin: Bool
    let secretWord: String
    let reason: String
    
    var body: some View {
        // NEW: ZStack for gradient
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.7),
                    Color.cyan.opacity(0.7)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                
                Spacer()
                
                // Top Section (Win/Loss)
                // MODIFIED: Colors for dark background
                Image(systemName: didGuessersWin ? "party.popper.fill" : "hand.thumbsdown.fill")
                    .font(.system(size: 80))
                    .foregroundColor(didGuessersWin ? .green : .red)
                    .padding(10)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Circle())
                
                Text(didGuessersWin ? "Guessers Win!" : "Guessers Lose!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(reason) // e.g., "You guessed the word!"
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.8))
                
                Text("The secret word was:")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.top, 10)
                
                Text(secretWord)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Spacer()
                
                // Bottom Buttons
                VStack(spacing: 15) {
                    // MODIFIED: "Play Again" button (Green Capsule)
                    Button(action: {
                        // Pop 2 views: Result, Game
                        // This lands you back on ContactWordSetupView
                        navPath.removeLast(2)
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
                    
                    // MODIFIED: "Main Menu" button (Stroked Capsule)
                    Button(action: {
                        // Pop all views to return to the root (MainMenuView)
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

struct ContactResultView_Previews: PreviewProvider {
    static var previews: some View {
        // Win state preview
        ContactResultView(
            navPath: .constant(NavigationPath()),
            didGuessersWin: true,
            secretWord: "SWIFTUI",
            reason: "You guessed the word!"
        )
        
        // Lose state preview
        ContactResultView(
            navPath: .constant(NavigationPath()),
            didGuessersWin: false,
            secretWord: "DEVELOPER",
            reason: "You gave up!"
        )
    }
}

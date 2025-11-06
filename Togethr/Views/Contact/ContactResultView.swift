// Views/Contact/ContactResultView.swift
import SwiftUI

struct ContactResultView: View {
    
    @Binding var navPath: NavigationPath
    
    let didGuessersWin: Bool
    let secretWord: String
    let reason: String
    
    var body: some View {
        VStack(spacing: 30) {
            
            Spacer()
            
            // Top Section (Win/Loss)
            Image(systemName: didGuessersWin ? "party.popper.fill" : "hand.thumbsdown.fill")
                .font(.system(size: 80))
                .foregroundColor(didGuessersWin ? .green : .red)
            
            Text(didGuessersWin ? "Guessers Win!" : "Guessers Lose!")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(reason) // e.g., "You guessed the word!"
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("The secret word was:")
                .font(.title3)
                .padding(.top, 10)
            
            Text(secretWord)
                .font(.system(size: 32, weight: .bold, design: .rounded))
            
            Spacer()
            
            // Bottom Buttons
            VStack(spacing: 10) {
                Button(action: {
                    // Pop 2 views: Result, Game
                    // This lands you back on ContactWordSetupView
                    navPath.removeLast(2)
                }) {
                    Text("Play Again")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .font(.headline)
                        .cornerRadius(12)
                }
                
                Button(action: {
                    // Pop all views to return to the root (MainMenuView)
                    navPath.removeLast(navPath.count)
                }) {
                    Text("Main Menu")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.secondary.opacity(0.2))
                        .foregroundColor(.primary)
                        .font(.headline)
                        .cornerRadius(12)
                }
            }
        }
        .padding()
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
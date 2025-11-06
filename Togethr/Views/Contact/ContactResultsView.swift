// Views/Contact/ContactResultView.swift
import SwiftUI

struct ContactResultView: View {
    
    @Binding var navPath: NavigationPath
    
    let winner: String
    let secretWord: String
    
    var body: some View {
        VStack(spacing: 30) {
            
            Spacer()
            
            // Top Section
            Image(systemName: "star.fill")
                .font(.system(size: 80))
                .foregroundColor(.yellow)
            
            Text(winner) // e.g., "Player 1 Wins!" or "It's a tie!"
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("The secret word was:")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text(secretWord)
                .font(.system(size: 32, weight: .bold, design: .rounded))
            
            Spacer()
            
            // Bottom Buttons
            VStack(spacing: 10) {
                Button(action: {
                    // Pop 2 views: Result, Game
                    // This lands you back on ContactPlayerSetupView
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
        ContactResultView(
            navPath: .constant(NavigationPath()),
            winner: "Alice Wins!",
            secretWord: "SWIFTUI"
        )
    }
}

// Views/TwentyQuestions/ConfirmationView.swift
import SwiftUI

struct ConfirmationView: View {
    
    @Binding var navPath: NavigationPath
    let category: String
    
    // 1. ADD: It now needs to know the secret word
    let secretWord: String
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // MODIFIED: Updated text
            Text("Knower, pass the phone to the first Guesser.")
                .font(.title)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            Spacer()
            
            // 2. MODIFIED: The button action now passes the secretWord
            Button(action: {
                navPath.append(GameNavigation.twentyQuestionsGame(
                    category: category,
                    secretWord: secretWord
                ))
            }) {
                // MODIFIED: Updated button text
                Text("I'm Ready to Guess")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(12)
            }
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }
}

struct ConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationView(
            navPath: .constant(NavigationPath()),
            category: "Animals",
            secretWord: "Lion" // Add mock data for preview
        )
    }
}

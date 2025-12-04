// Views/TwentyQuestions/HowToPlayView.swift
import SwiftUI

struct HowToPlayView: View {
    // Access dismiss action to close the sheet/modal
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            
            // MARK: Header
            Text("How to Play")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)

            // MARK: Instructions List
            
            // 1. The Knower Role
            VStack(alignment: .leading, spacing: 5) {
                Text("1. The Knower")
                    .font(.title3)
                    .fontWeight(.semibold)
                Text("One person, the Knower, thinks of a secret (e.g., \"an animal\").")
                    .foregroundColor(.secondary)
            }
            
            // 2. The Guessers Role
            VStack(alignment: .leading, spacing: 5) {
                Text("2. The Guessers")
                    .font(.title3)
                    .fontWeight(.semibold)
                Text("Everyone else, the Guessers, take turns asking the Knower \"Yes/No\" questions, while holding the phone and recording these questions.")
                    .foregroundColor(.secondary)
            }

            // 3. The Gameplay Loop (Logging)
            VStack(alignment: .leading, spacing: 5) {
                Text("3. The Log")
                    .font(.title3)
                    .fontWeight(.semibold)
                Text("For each question, the Guesser taps 'Record', asks their question, then stops recording. After the question appears, the Knower taps 'Yes' or 'No' to log the answer and advance.")
                    .foregroundColor(.secondary)
            }
            
            // 4. Winning Condition
            VStack(alignment: .leading, spacing: 5) {
                Text("4. The Win")
                    .font(.title3)
                    .fontWeight(.semibold)
                Text("When a Guesser says the final correct answer, they tap \"They Guessed It!\" to win.")
                    .foregroundColor(.secondary)
            }

            Spacer()
            
            // MARK: Dismiss Button
            Button(action: {
                dismiss() // Close the sheet
            }) {
                Text("Got It!")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(12)
            }
        }
        .padding(30) // Add ample padding for the sheet
    }
}

// UNCHANGED PREVIEW
struct HowToPlayView_Previews: PreviewProvider {
    static var previews: some View {
        HowToPlayView()
    }
}

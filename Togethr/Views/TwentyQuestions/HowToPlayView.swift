import SwiftUI

struct HowToPlayView: View {
    // Access dismiss action to close the sheet
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            
            // Title
            Text("How to Play")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)

            // 1. The Knower
            VStack(alignment: .leading, spacing: 5) {
                Text("1. The Knower")
                    .font(.title3)
                    .fontWeight(.semibold)
                Text("One person, the Knower, holds the phone and thinks of a secret (e.g., \"an animal\").")
                    .foregroundColor(.secondary)
            }
            
            // 2. The Guessers
            VStack(alignment: .leading, spacing: 5) {
                Text("2. The Guessers")
                    .font(.title3)
                    .fontWeight(.semibold)
                Text("Everyone else, the Guessers, take turns asking the Knower \"Yes/No\" questions. (e.g., \"Does it live in the water?\").")
                    .foregroundColor(.secondary)
            }

            // 3. The Count
            VStack(alignment: .leading, spacing: 5) {
                Text("3. The Count")
                    .font(.title3)
                    .fontWeight(.semibold)
                Text("After each question, the Knower taps the \"Yes/No\" button to advance the counter.")
                    .foregroundColor(.secondary)
            }
            
            // 4. The Win
            VStack(alignment: .leading, spacing: 5) {
                Text("4. The Win")
                    .font(.title3)
                    .fontWeight(.semibold)
                Text("When a Guesser says the final correct answer, the Knower taps \"They Guessed It!\" to win.")
                    .foregroundColor(.secondary)
            }

            Spacer()
            
            // Got It! button to dismiss the sheet
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

struct HowToPlayView_Previews: PreviewProvider {
    static var previews: some View {
        HowToPlayView()
    }
}


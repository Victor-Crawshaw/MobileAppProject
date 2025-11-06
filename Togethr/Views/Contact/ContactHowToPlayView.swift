// Views/Contact/ContactHowToPlayView.swift
import SwiftUI

struct ContactHowToPlayView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            
            Text("How to Play: Contact")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 10)

            // 1. The Word Master
            VStack(alignment: .leading, spacing: 5) {
                Text("1. The Word Master")
                    .font(.title3)
                    .fontWeight(.semibold)
                Text("One person, the **Word Master**, holds the phone and enters a secret word. They reveal only the first letter.")
                    .foregroundColor(.secondary)
            }
            
            // 2. The Guessers
            VStack(alignment: .leading, spacing: 5) {
                Text("2. The Guessers")
                    .font(.title3)
                    .fontWeight(.semibold)
                Text("Everyone else (the **Guessers**) tries to think of a word that *starts* with the visible letters.")
                    .foregroundColor(.secondary)
            }

            // 3. "Contact!"
            VStack(alignment: .leading, spacing: 5) {
                Text("3. Making 'Contact'")
                    .font(.title3)
                    .fontWeight(.semibold)
                Text("When a Guesser has a word, they give a clue. If another Guesser *also* thinks of a word for that clue (it doesn't have to be the same word!), they say \"Contact!\".")
                    .foregroundColor(.secondary)
            }
            
            // 4. The Reveal
            VStack(alignment: .leading, spacing: 5) {
                Text("4. The Reveal")
                    .font(.title3)
                    .fontWeight(.semibold)
                Text("If the Word Master can't guess the clue, the Guessers reveal their words. If they match, the Word Master taps **'Reveal Next Letter'**.")
                    .foregroundColor(.secondary)
            }
            
            // 5. Winning
            VStack(alignment: .leading, spacing: 5) {
                Text("5. Winning & Losing")
                    .font(.title3)
                    .fontWeight(.semibold)
                Text("The Guessers win if they guess the full word (tap **'Guessers Got It!'**) or if all letters are revealed. The Guessers lose if they give up (tap **'Guessers Give Up'**).")
                    .foregroundColor(.secondary)
            }

            Spacer()
            
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
        .padding(30)
    }
}

struct ContactHowToPlayView_Previews: PreviewProvider {
    static var previews: some View {
        ContactHowToPlayView()
    }
}
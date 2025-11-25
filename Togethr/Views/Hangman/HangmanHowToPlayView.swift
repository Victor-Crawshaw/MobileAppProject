// Views/Hangman/HangmanHowToPlayView.swift
import SwiftUI

struct HangmanHowToPlayView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            
            Text("How to Play")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .center)

            VStack(alignment: .leading, spacing: 5) {
                Text("1. Choose a Word")
                    .font(.title3)
                    .fontWeight(.semibold)
                Text("One person, the Chooser, picks a secret word or phrase.")
                    .foregroundColor(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("2. Guess Letters")
                    .font(.title3)
                    .fontWeight(.semibold)
                Text("The Guesser taps letters to guess them. Correct guesses reveal the letter's position(s) in the word.")
                    .foregroundColor(.secondary)
            }

            VStack(alignment: .leading, spacing: 5) {
                Text("3. Limited Tries")
                    .font(.title3)
                    .fontWeight(.semibold)
                Text("You have 6 incorrect guesses before losing. Each wrong guess adds a body part to the hangman!")
                    .foregroundColor(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("4. Win or Lose")
                    .font(.title3)
                    .fontWeight(.semibold)
                Text("Complete the word before running out of guesses to win. Otherwise, the hangman is completed and you lose.")
                    .foregroundColor(.secondary)
            }

            Spacer()
            
            Button(action: {
                dismiss()
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

struct HangmanHowToPlayView_Previews: PreviewProvider {
    static var previews: some View {
        HangmanHowToPlayView()
    }
}

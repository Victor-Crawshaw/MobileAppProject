// Views/Hangman/HangmanWordSetupView.swift
import SwiftUI

struct HangmanWordSetupView: View {
    
    @Binding var navPath: NavigationPath
    
    var body: some View {
        SecretWordInputView(
            title: "Word or Phrase",
            subtitle: "Must be at least 2 letters",
            placeholder: "e.g., \"ELEPHANT\" or \"GOLDEN GATE\"",
            buttonText: "Confirm Secret",
            validation: { word in
                let cleaned = word.trimmingCharacters(in: .whitespacesAndNewlines)
                let lettersOnly = cleaned.filter { $0.isLetter }
                if lettersOnly.count < 2 {
                    return "Must have at least 2 letters."
                }
                return nil
            },
            onConfirm: { secretWord in
                navPath.append(GameNavigation.hangmanConfirm(secretWord: secretWord))
            }
        )
        .navigationTitle("Enter Secret")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct HangmanWordSetupView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HangmanWordSetupView(navPath: .constant(NavigationPath()))
        }
    }
}

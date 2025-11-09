// Views/Contact/ContactWordSetupView.swift
import SwiftUI

struct ContactWordSetupView: View {
    
    @Binding var navPath: NavigationPath
    
    var body: some View {
        SecretWordInputView(
            title: "Word",
            subtitle: "Only the defender should see this screen",
            placeholder: "e.g., \"ELEPHANT\"",
            buttonText: "Start Game",
            validation: validateSecretWord,
            onConfirm: { word in
                let cleanedWord = word
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .uppercased()
                navPath.append(GameNavigation.contactGame(secretWord: cleanedWord))
            }
        )
        .navigationTitle("Contact Setup")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func validateSecretWord(_ word: String) -> String? {
        let cleanedWord = word
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased()
        
        guard cleanedWord.count > 2 else {
            return "Secret word must be at least 3 letters long."
        }
        
        guard cleanedWord.allSatisfy({ $0.isLetter }) else {
            return "Secret word must only contain letters."
        }
        
        return nil
    }
}

struct ContactWordSetupView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ContactWordSetupView(navPath: .constant(NavigationPath()))
        }
    }
}

// Views/TwentyQuestions/TwentyQuestionsSecretInputView.swift
import SwiftUI

struct TwentyQuestionsSecretInputView: View {
    
    @Binding var navPath: NavigationPath
    let category: String
    
    var body: some View {
        SecretWordInputView(
            title: String(category.dropLast(1)), // "Animals" -> "Animal"
            subtitle: nil,
            placeholder: "e.g., \"Dolphin\" or \"My Left Shoe\"",
            buttonText: "Confirm Secret",
            validation: { _ in nil }, // No validation needed for Twenty Questions
            onConfirm: { secretWord in
                navPath.append(GameNavigation.twentyQuestionsConfirm(
                    category: category,
                    secretWord: secretWord
                ))
            }
        )
        .navigationTitle("Enter Secret")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TwentyQuestionsSecretInputView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TwentyQuestionsSecretInputView(navPath: .constant(NavigationPath()), category: "Animals")
        }
    }
}

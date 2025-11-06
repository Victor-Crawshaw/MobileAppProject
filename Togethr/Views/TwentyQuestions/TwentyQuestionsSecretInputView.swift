//
//  TwentyQuestionsSecretInputView.swift
//  Togethr
//
//  Created by Victor Crawshaw on 11/6/25.
//

// Views/TwentyQuestions/TwentyQuestionsSecretInputView.swift
import SwiftUI

struct TwentyQuestionsSecretInputView: View {
    
    @Binding var navPath: NavigationPath
    let category: String
    
    @State private var secretWord: String = ""
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text("Knower, enter your secret")
                .font(.title)
                .foregroundColor(.secondary)
            
            // We still show the category they picked
            Text(category.dropLast(1)) // "Animals" -> "Animal"
                .font(.system(size: 40, weight: .bold, design: .rounded))
            
            TextField("e.g., \"Dolphin\" or \"My Left Shoe\"", text: $secretWord)
                .font(.title2)
                .padding()
                .background(.regularMaterial)
                .cornerRadius(12)
                .multilineTextAlignment(.center)
                .focused($isTextFieldFocused)
                .padding(.horizontal)
            
            Spacer()
            
            Button(action: {
                // Navigate to the next step, passing both category AND the new secret word
                navPath.append(GameNavigation.twentyQuestionsConfirm(
                    category: category,
                    secretWord: secretWord
                ))
            }) {
                Text("Confirm Secret")
                    .frame(maxWidth: .infinity)
                    .padding()
                    // Disable button if no word is entered
                    .background(secretWord.isEmpty ? Color.secondary.opacity(0.5) : Color.blue)
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(12)
            }
            .disabled(secretWord.isEmpty)
        }
        .padding()
        .navigationTitle("Enter Secret")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            isTextFieldFocused = true // Show keyboard immediately
        }
    }
}

struct TwentyQuestionsSecretInputView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TwentyQuestionsSecretInputView(navPath: .constant(NavigationPath()), category: "Animals")
        }
    }
}

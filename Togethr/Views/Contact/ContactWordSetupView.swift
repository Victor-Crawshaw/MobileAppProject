// Views/Contact/ContactWordSetupView.swift
import SwiftUI

struct ContactWordSetupView: View {
    
    @Binding var navPath: NavigationPath
    
    @State private var secretWord: String = ""
    @State private var formError: String?
    
    var body: some View {
        Form {
            Section("Word Master Setup") {
                TextField("Enter the secret word", text: $secretWord)
                    .autocorrectionDisabled(true)
                    .autocapitalization(.allCharacters)
                
                Text("Only the defender (person coming up with the secret word) should see this screen. Enter the secret word and tap 'Start Game'.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if let formError {
                Section {
                    Text(formError)
                        .foregroundColor(.red)
                }
            }
            
            Button(action: startGame) {
                Text("Start Game")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationTitle("Contact Setup")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func startGame() {
        // Validation
        let cleanedWord = secretWord
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased()
        
        guard cleanedWord.count > 2 else {
            formError = "Secret word must be at least 3 letters long."
            return
        }
        
        guard cleanedWord.allSatisfy({ $0.isLetter }) else {
            formError = "Secret word must only contain letters."
            return
        }
        
        formError = nil
        
        // Navigate to the game
        navPath.append(GameNavigation.contactGame(secretWord: cleanedWord))
    }
}

struct ContactWordSetupView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContactWordSetupView(navPath: .constant(NavigationPath()))
        }
    }
}
// Views/Contact/ContactPlayerSetupView.swift
import SwiftUI

struct ContactPlayerSetupView: View {
    
    @Binding var navPath: NavigationPath
    
    // For V1, we'll hardcode 2 players for simplicity
    @State private var player1Name: String = "Player 1"
    @State private var player2Name: String = "Player 2"
    @State private var secretWord: String = ""
    
    @State private var formError: String?
    
    var body: some View {
        Form {
            Section("Players") {
                TextField("Player 1 Name", text: $player1Name)
                TextField("Player 2 Name", text: $player2Name)
                // TODO: Add support for dynamic player list (2-6 players)
            }
            
            Section("Secret Word") {
                TextField("Enter the secret word", text: $secretWord)
                    .autocorrectionDisabled(true)
                    .autocapitalization(.allCharacters)
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
        
        guard !player1Name.isEmpty, !player2Name.isEmpty else {
            formError = "Player names cannot be empty."
            return
        }
        
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
        let players = [player1Name, player2Name]
        navPath.append(GameNavigation.contactGame(
            players: players,
            secretWord: cleanedWord
        ))
    }
}

struct ContactPlayerSetupView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContactPlayerSetupView(navPath: .constant(NavigationPath()))
        }
    }
}

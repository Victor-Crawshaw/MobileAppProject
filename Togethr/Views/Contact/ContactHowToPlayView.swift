// Views/Contact/ContactHowToPlayView.swift
import SwiftUI

struct ContactHowToPlayView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            
            Text("How to Play: Contact")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 30)
                .padding(.bottom, 20)
                .padding(.horizontal)

            // ScrollView to contain all the rules
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    
                    // Overview Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Overview")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("One player is the **Defender** who thinks of a secret word. Everyone else works together to guess it by giving clever clues.")
                            .foregroundColor(.secondary)
                    }
                    
                    // How It Works Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("How It Works")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(alignment: .top, spacing: 10) {
                                Text("1.")
                                    .fontWeight(.semibold)
                                    .frame(width: 20, alignment: .leading)
                                Text("The Defender reveals the **first letter** of their secret word.")
                            }
                            
                            HStack(alignment: .top, spacing: 10) {
                                Text("2.")
                                    .fontWeight(.semibold)
                                    .frame(width: 20, alignment: .leading)
                                Text("Players give **clues** to words starting with that letter, trying to stump the Defender while helping others guess.")
                            }
                            
                            HStack(alignment: .top, spacing: 10) {
                                Text("3.")
                                    .fontWeight(.semibold)
                                    .frame(width: 20, alignment: .leading)
                                Text("When someone thinks they know the clue word, they yell **\"Contact!\"**")
                            }
                            
                            HStack(alignment: .top, spacing: 10) {
                                Text("4.")
                                    .fontWeight(.semibold)
                                    .frame(width: 20, alignment: .leading)
                                Text("The Defender tries to guess the clue word. If they can't, they say **\"Challenge!\"**")
                            }
                            
                            HStack(alignment: .top, spacing: 10) {
                                Text("5.")
                                    .fontWeight(.semibold)
                                    .frame(width: 20, alignment: .leading)
                                Text("On \"Challenge,\" the clue-giver and contacter count to 3 and shout their word. If they **match**, the Defender reveals the next letter!")
                            }
                        }
                        .foregroundColor(.secondary)
                    }
                    
                    // Example Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Example Round")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Secret word: **duck** → Letter revealed: **D**")
                                .fontWeight(.medium)
                            
                            Text("• Player 1: \"A type of flower\"")
                            Text("• Player 2: \"Contact!\"")
                            Text("• Defender: \"Daisy? Dandelion? OK, Challenge!\"")
                            Text("• Both players: \"1... 2... 3... Daffodil!\"")
                            Text("• ✅ They match! Next letters revealed: **Du**")
                            
                            Text("\nNow all clues must start with \"Du.\" The process repeats until someone guesses the full word!")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .italic()
                        }
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                    }
                    
                    // Important Rules
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Important Rules")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            RuleRow(icon: "💬", text: "No turns—anyone can give a clue anytime")
                            RuleRow(icon: "🚫", text: "Each word can only be used once as a clue")
                            RuleRow(icon: "👥", text: "Multiple people can contact the same clue")
                            RuleRow(icon: "⏱️", text: "Defenders can call \"Challenge\" early to prevent more contacts")
                            RuleRow(icon: "🏆", text: "Win by giving a clue to the secret word that gets revealed through a challenge")
                            RuleRow(icon: "✏️", text: "Clue-givers can modify or drop their clue if no one contacts")
                        }
                    }
                    
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 20)
            }

            // "Got It!" button sticks to the bottom
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
            .padding(.horizontal, 30)
            .padding(.vertical, 20)
            .background(.bar)
        }
    }
}

// Helper view for rule rows
struct RuleRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(icon)
                .font(.title3)
            Text(text)
                .foregroundColor(.secondary)
        }
    }
}

struct ContactHowToPlayView_Previews: PreviewProvider {
    static var previews: some View {
        ContactHowToPlayView()
    }
}

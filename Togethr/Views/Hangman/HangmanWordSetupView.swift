// Views/Hangman/HangmanWordSetupView.swift
import SwiftUI

struct HangmanWordSetupView: View {
    
    @Binding var navPath: NavigationPath
    
    @State private var secretWord: String = ""
    @State private var errorMessage: String?
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.05, green: 0.0, blue: 0.15).ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                // Header
                VStack(spacing: 10) {
                    Text("SETUP PHASE")
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundColor(.orange)
                        .tracking(2)
                    
                    Text("Secret Word")
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                }
                .padding(.top, 40)
                
                // Input Field
                VStack(alignment: .leading, spacing: 10) {
                    Text("CHOOSER INPUT ONLY")
                        .font(.caption)
                        .fontDesign(.monospaced)
                        .foregroundColor(.gray)
                        .padding(.leading, 5)
                    
                    SecureField("", text: $secretWord)
                        .textFieldStyle(.plain)
                        .font(.system(size: 24, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(isFocused ? Color.orange : Color.clear, lineWidth: 2)
                        )
                        .focused($isFocused)
                        .submitLabel(.done)
                        .placeholder(when: secretWord.isEmpty) {
                            Text("e.g. GALAXY").foregroundColor(.gray.opacity(0.5)).padding(.leading, 15)
                        }
                    
                    if let error = errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.leading, 5)
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                // Confirm Button
                Button(action: handleConfirm) {
                    HStack {
                        Text("LOCK IN WORD")
                        Image(systemName: "lock.fill")
                    }
                    .font(.system(size: 18, weight: .heavy, design: .rounded))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(secretWord.isEmpty ? Color.gray.opacity(0.3) : Color.orange)
                    )
                    .foregroundColor(secretWord.isEmpty ? .white.opacity(0.3) : .white)
                    .shadow(color: secretWord.isEmpty ? .clear : .orange.opacity(0.5), radius: 10, y: 5)
                }
                .disabled(secretWord.isEmpty)
                .buttonStyle(BouncyGameButtonStyle())
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
            }
        }
        .onAppear { isFocused = true }
        .toolbarBackground(.hidden, for: .navigationBar)
    }
    
    private func handleConfirm() {
        let cleaned = secretWord.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        let lettersOnly = cleaned.filter { $0.isLetter }
        
        if lettersOnly.count < 2 {
            errorMessage = "Must contain at least 2 letters."
        } else {
            navPath.append(GameNavigation.hangmanConfirm(secretWord: cleaned))
        }
    }
}

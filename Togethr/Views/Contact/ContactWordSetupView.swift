// Views/Contact/ContactWordSetupView.swift
import SwiftUI

struct ContactWordSetupView: View {
    
    @Binding var navPath: NavigationPath
    
    @State private var secretWord: String = ""
    @State private var errorMessage: String?
    @FocusState private var isFocused: Bool
    
    // Timer Settings
    @State private var isTimerEnabled: Bool = false
    @State private var timerDurationMinutes: Int = 5
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.05, green: 0.0, blue: 0.15).ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                // Navigation Header (Added Back Button)
                HStack {
                    Button(action: {
                        if !navPath.isEmpty { navPath.removeLast() }
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.leading, 20)
                    }
                    Spacer()
                }
                .padding(.top, 10)
                
                // Header
                VStack(spacing: 10) {
                    Text("SETUP PHASE")
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundColor(.teal)
                        .tracking(2)
                    
                    Text("Secret Word")
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                }
                
                // Input Field
                VStack(alignment: .leading, spacing: 10) {
                    Text("DEFENDER INPUT ONLY")
                        .font(.caption)
                        .fontDesign(.monospaced)
                        .foregroundColor(.gray)
                        .padding(.leading, 5)
                    
                    // TextField ensures visibility (SecureField would hide it)
                    TextField("", text: $secretWord)
                        .placeholder(when: secretWord.isEmpty) {
                            Text("e.g. ASTEROID").foregroundColor(.gray.opacity(0.5))
                        }
                        .font(.system(size: 24, weight: .bold, design: .monospaced))
                        .foregroundColor(.teal)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.black.opacity(0.3))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(isFocused ? Color.teal : Color.white.opacity(0.1), lineWidth: 2)
                                )
                        )
                        .focused($isFocused)
                        .submitLabel(.done)
                        .onChange(of: secretWord) { _ in
                            errorMessage = nil
                        }
                    
                    if let error = errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.leading, 5)
                    }
                }
                .padding(.horizontal, 30)
                
                // Timer Toggle
                HStack {
                    VStack(alignment: .leading) {
                        Text("Timer Limit")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text(isTimerEnabled ? "\(timerDurationMinutes) Minutes" : "No Time Limit")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: $isTimerEnabled)
                        .labelsHidden()
                        .tint(.teal)
                }
                .padding(20)
                .background(Color.white.opacity(0.05))
                .cornerRadius(15)
                .padding(.horizontal, 30)
                
                if isTimerEnabled {
                    Stepper("Duration: \(timerDurationMinutes) min", value: $timerDurationMinutes, in: 1...30)
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                }
                
                Spacer()
                
                // Confirm Button
                Button(action: handleConfirm) {
                    HStack {
                        Text("CONFIRM SETUP")
                        Image(systemName: "checkmark.shield.fill")
                    }
                    .font(.system(size: 18, weight: .heavy, design: .rounded))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(secretWord.isEmpty ? Color.gray.opacity(0.3) : Color.purple)
                    )
                    .foregroundColor(secretWord.isEmpty ? .white.opacity(0.3) : .white)
                    .shadow(color: secretWord.isEmpty ? .clear : .purple.opacity(0.5), radius: 10, y: 5)
                }
                .disabled(secretWord.isEmpty)
                .buttonStyle(BouncyGameButtonStyle())
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
            }
        }
        .onAppear { isFocused = true }
        .toolbarBackground(.hidden, for: .navigationBar)
        .animation(.spring(), value: isTimerEnabled)
        .navigationBarHidden(true)
    }
    
    private func handleConfirm() {
        if let error = validateSecretWord(secretWord) {
            errorMessage = error
        } else {
            let cleaned = secretWord.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
            
            // Calculate time limit (nil if disabled)
            let limit: TimeInterval? = isTimerEnabled ? TimeInterval(timerDurationMinutes * 60) : nil
            
            navPath.append(GameNavigation.contactGame(secretWord: cleaned, timeLimit: limit))
        }
    }
    
    func validateSecretWord(_ word: String) -> String? {
        let cleaned = word.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cleaned.count < 3 { return "Word must be at least 3 letters." }
        if !cleaned.allSatisfy({ $0.isLetter }) { return "Letters only, please." }
        return nil
    }
}


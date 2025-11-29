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
                .padding(.top, 40)
                
                // Input Field
                VStack(alignment: .leading, spacing: 10) {
                    Text("DEFENDER INPUT ONLY")
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
                                .stroke(isFocused ? Color.teal : Color.clear, lineWidth: 2)
                        )
                        .focused($isFocused)
                        .submitLabel(.done)
                        .placeholder(when: secretWord.isEmpty) {
                            Text("e.g. ELEPHANT").foregroundColor(.gray.opacity(0.5)).padding(.leading, 15)
                        }
                    
                    if let error = errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.leading, 5)
                    }
                }
                .padding(.horizontal, 40)
                
                // MARK: - Timer Settings
                VStack(spacing: 15) {
                    Toggle(isOn: $isTimerEnabled) {
                        HStack {
                            Image(systemName: isTimerEnabled ? "timer" : "infinity.circle")
                                .foregroundColor(isTimerEnabled ? .yellow : .gray)
                            Text(isTimerEnabled ? "TIME LIMIT" : "ZEN MODE (NO TIMER)")
                                .font(.system(size: 16, weight: .bold, design: .monospaced))
                                .foregroundColor(.white)
                        }
                    }
                    .toggleStyle(SwitchToggleStyle(tint: .teal))
                    .padding()
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(12)
                    
                    if isTimerEnabled {
                        HStack {
                            Text("DURATION:")
                                .font(.system(size: 14, weight: .bold, design: .monospaced))
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Picker("Duration", selection: $timerDurationMinutes) {
                                Text("3 Min").tag(3)
                                Text("5 Min").tag(5)
                                Text("10 Min").tag(10)
                                Text("15 Min").tag(15)
                            }
                            .pickerStyle(.menu)
                            .accentColor(.teal)
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(8)
                        }
                        .padding(.horizontal)
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                // Confirm Button
                Button(action: handleConfirm) {
                    HStack {
                        Text("LOCK IN SETTINGS")
                            .tracking(1)
                        Image(systemName: "lock.fill")
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
    }
    
    private func handleConfirm() {
        if let error = validateSecretWord(secretWord) {
            errorMessage = error
        } else {
            let cleaned = secretWord.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
            
            // Calculate time limit (nil if disabled)
            let limit: TimeInterval? = isTimerEnabled ? TimeInterval(timerDurationMinutes * 60) : nil
            
            // NOTE: You must update your GameNavigation enum to accept 'timeLimit'
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

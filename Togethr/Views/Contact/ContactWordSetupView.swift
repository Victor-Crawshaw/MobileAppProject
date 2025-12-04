// Views/Contact/ContactWordSetupView.swift
import SwiftUI

struct ContactWordSetupView: View {
    
    // MARK: - Properties
    @Binding var navPath: NavigationPath
    
    // Input State
    @State private var secretWord: String = ""
    @State private var errorMessage: String?
    @FocusState private var isFocused: Bool // Controls keyboard focus
    
    // Timer Settings
    @State private var isTimerEnabled: Bool = false
    @State private var timerDurationMinutes: Int = 5
    
    var body: some View {
        ZStack {
            // MARK: Background
            Color(red: 0.05, green: 0.0, blue: 0.15).ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                // MARK: Navigation Header
                // Includes logic to remove the current view from the stack
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
                
                // MARK: Page Header
                VStack(spacing: 10) {
                    Text("SETUP PHASE")
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundColor(.teal)
                        .tracking(2)
                    
                    Text("Secret Word")
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                }
                
                // MARK: Input Field
                VStack(alignment: .leading, spacing: 10) {
                    Text("DEFENDER INPUT ONLY")
                        .font(.caption)
                        .fontDesign(.monospaced)
                        .foregroundColor(.gray)
                        .padding(.leading, 5)
                    
                    // TextField ensures visibility (SecureField would hide it, but Defender might want to check spelling)
                    TextField("", text: $secretWord)
                        .placeholder(when: secretWord.isEmpty) {
                            Text("e.g. ASTEROID").foregroundColor(.gray.opacity(0.5))
                        }
                        .font(.system(size: 24, weight: .bold, design: .rounded))
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
                        .onChange(of: secretWord) { _ in errorMessage = nil } // Clear error when typing
                    
                    // Error Message Display
                    if let error = errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.leading, 5)
                    }
                }
                .padding(.horizontal, 30)
                
                // MARK: Timer Toggle Section
                VStack(spacing: 15) {
                    Toggle(isOn: $isTimerEnabled) {
                        HStack {
                            Image(systemName: "timer")
                                .foregroundColor(.orange)
                            Text("Enable Time Limit")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                    }
                    .tint(.orange)
                    .padding()
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(12)
                    
                    // Conditional Slider for duration
                    if isTimerEnabled {
                        VStack(spacing: 5) {
                            HStack {
                                Text("Duration")
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("\(timerDurationMinutes) Minutes")
                                    .fontWeight(.bold)
                                    .foregroundColor(.orange)
                            }
                            
                            Slider(value: Binding(
                                get: { Double(timerDurationMinutes) },
                                set: { timerDurationMinutes = Int($0) }
                            ), in: 1...15, step: 1)
                            .accentColor(.orange)
                        }
                        .padding()
                        .background(Color.white.opacity(0.05))
                        .cornerRadius(12)
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }
                .padding(.horizontal, 30)
                
                Spacer()
                
                // MARK: Confirm / Start Button
                Button(action: handleConfirm) {
                    HStack {
                        Text("LOCK & START")
                        Image(systemName: "lock.shield.fill")
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
        .onAppear { isFocused = true } // Auto-focus input
        .toolbarBackground(.hidden, for: .navigationBar)
        .animation(.spring(), value: isTimerEnabled)
        .navigationBarHidden(true)
    }
    
    // MARK: - Logic Functions
    
    // Validates input and pushes the Game View
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
    
    // Basic validation rules
    func validateSecretWord(_ word: String) -> String? {
        let cleaned = word.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cleaned.count < 3 { return "Word must be at least 3 letters." }
        if !cleaned.allSatisfy({ $0.isLetter }) { return "Letters only, please." }
        return nil
    }
}

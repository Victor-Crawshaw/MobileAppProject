// Views/Shared/SecretWordInputView.swift
import SwiftUI

/// A reusable view for entering secret words across different games
struct SecretWordInputView: View {
    
    // MARK: - Properties
    let title: String
    let subtitle: String?
    let placeholder: String
    let buttonText: String
    let validation: (String) -> String?
    let onConfirm: (String) -> Void
    
    @State private var secretWord: String = ""
    @State private var errorMessage: String?
    @FocusState private var isTextFieldFocused: Bool
    
    // MARK: - Initialization
    init(
        title: String,
        subtitle: String? = nil,
        placeholder: String = "Enter secret word",
        buttonText: String = "Confirm Secret",
        validation: @escaping (String) -> String? = { _ in nil },
        onConfirm: @escaping (String) -> Void
    ) {
        self.title = title
        self.subtitle = subtitle
        self.placeholder = placeholder
        self.buttonText = buttonText
        self.validation = validation
        self.onConfirm = onConfirm
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text("Enter your secret")
                .font(.title)
                .foregroundColor(.secondary)
            
            Text(title)
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .multilineTextAlignment(.center)
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            VStack(spacing: 8) {
                TextField(placeholder, text: $secretWord)
                    .font(.title2)
                    .padding()
                    .background(.regularMaterial)
                    .cornerRadius(12)
                    .multilineTextAlignment(.center)
                    .focused($isTextFieldFocused)
                    .padding(.horizontal)
                    .onChange(of: secretWord) { _ in
                        // Clear error when user types
                        errorMessage = nil
                    }
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
            }
            
            Spacer()
            
            Button(action: handleConfirm) {
                Text(buttonText)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(secretWord.isEmpty ? Color.secondary.opacity(0.5) : Color.blue)
                    .foregroundColor(.white)
                    .font(.headline)
                    .cornerRadius(12)
            }
            .disabled(secretWord.isEmpty)
        }
        .padding()
        .onAppear {
            isTextFieldFocused = true
        }
    }
    
    // MARK: - Methods
    private func handleConfirm() {
        // Run validation
        if let error = validation(secretWord) {
            errorMessage = error
            return
        }
        
        // Clear any errors and confirm
        errorMessage = nil
        onConfirm(secretWord)
    }
}

// MARK: - Preview
struct SecretWordInputView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SecretWordInputView(
                title: "Word",
                subtitle: "Must be at least 3 letters",
                placeholder: "e.g., \"ELEPHANT\"",
                buttonText: "Start Game",
                validation: { word in
                    let cleaned = word.trimmingCharacters(in: .whitespacesAndNewlines)
                    if cleaned.count < 3 {
                        return "Word must be at least 3 letters long."
                    }
                    return nil
                },
                onConfirm: { word in
                    print("Confirmed: \(word)")
                }
            )
            .navigationTitle("Setup")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

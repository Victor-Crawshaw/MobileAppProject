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
        // NEW: ZStack for gradient background
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.7),
                    Color.cyan.opacity(0.7)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            .onTapGesture {
                isTextFieldFocused = false // Dismiss keyboard on bg tap
            }
            
            VStack(spacing: 20) {
                Spacer()
                
                // MODIFIED: Title styling
                Text("Enter your secret")
                    .font(.title)
                    .foregroundColor(.white.opacity(0.8))
                
                Text(title)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white) // MODIFIED: Color
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8)) // MODIFIED: Color
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                // MODIFIED: Text Field styled for dark background
                TextField(placeholder, text: $secretWord)
                    .focused($isTextFieldFocused)
                    .font(.title2)
                    .padding(16)
                    .background(Color.black.opacity(0.2)) // Darker inset bg
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.5), lineWidth: 1)
                    )
                    .foregroundColor(.white) // Text color
                    .accentColor(.white) // Cursor color
                    .padding(.horizontal, 30)
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .font(.headline)
                        .foregroundColor(.red) // Error color
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                }
                
                Spacer()
                
                // MODIFIED: Button to match primary green style
                Button(action: handleConfirm) {
                    Text(buttonText)
                        .font(.title3)
                        .fontWeight(.heavy)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            Capsule()
                                .fill(secretWord.isEmpty ? Color.gray.gradient : Color.green.gradient)
                                .shadow(color: .black.opacity(0.3), radius: 5, y: 5)
                        )
                        .foregroundColor(.white)
                }
                .disabled(secretWord.isEmpty)
                .padding(.horizontal, 30)
                .padding(.bottom)
            }
            .padding()
            .onAppear {
                isTextFieldFocused = true
            }
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

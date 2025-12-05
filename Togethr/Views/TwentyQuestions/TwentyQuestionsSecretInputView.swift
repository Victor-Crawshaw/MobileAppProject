import SwiftUI

struct TwentyQuestionsSecretInputView: View {
    
    // MARK: - Properties
    @Binding var navPath: NavigationPath
    let category: String
    
    // Input State
    @State private var textInput: String = ""
    @FocusState private var isFocused: Bool // Controls keyboard visibility
    
    // Dynamic placeholder based on the category string
    private var placeholderText: String {
        if category.contains("Animals") { return "e.g. Dolphin" }
        if category.contains("Food") { return "e.g. Pizza" }
        if category.contains("People") { return "e.g. Taylor Swift" }
        if category.contains("Movies") { return "e.g. Star Wars" }
        if category.contains("Objects") { return "e.g. Toaster" }
        if category.contains("Places") { return "e.g. Paris" }
        return "e.g. Magic" // Fallback
    }
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.05, green: 0.0, blue: 0.15).ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                // MARK: Navigation Header
                HStack {
                    Button(action: {
                        // Go back to Category Selection
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
                
                // Instructions
                VStack(spacing: 10) {
                    Text("SECRET TARGET")
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundColor(.purple)
                        .tracking(2)
                    
                    Text("Enter The Word")
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                }
                
                // MARK: Custom Input Field
                VStack(alignment: .leading, spacing: 10) {
                    Text(String(category.dropLast(1))) // Simple plural-to-singular logic: "Animals" -> "Animal"
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.leading, 5)
                    
                    TextField("", text: $textInput)
                        // Uses the dynamic placeholderText property now
                        .placeholder(when: textInput.isEmpty) {
                            Text(placeholderText).foregroundColor(.gray.opacity(0.5))
                        }
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.teal)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.black.opacity(0.3))
                                .overlay(
                                    // Highlights border when typing
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(isFocused ? Color.teal : Color.white.opacity(0.1), lineWidth: 2)
                                )
                        )
                        .focused($isFocused)
                        .submitLabel(.done)
                }
                .padding(.horizontal, 30)
                
                Spacer()
                
                // MARK: Confirm Button
                Button(action: {
                    if !textInput.isEmpty {
                        // Move to Confirmation Screen
                        navPath.append(GameNavigation.twentyQuestionsConfirm(
                            category: category,
                            secretWord: textInput
                        ))
                    }
                }) {
                    HStack {
                        Text("LOCK IN SECRET")
                        Image(systemName: "lock.fill")
                    }
                    .font(.system(size: 18, weight: .heavy, design: .rounded))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        // Conditional coloring based on input validity
                        RoundedRectangle(cornerRadius: 16)
                            .fill(textInput.isEmpty ? Color.gray.opacity(0.3) : Color.purple)
                    )
                    .foregroundColor(textInput.isEmpty ? .white.opacity(0.3) : .white)
                    .shadow(color: textInput.isEmpty ? .clear : .purple.opacity(0.5), radius: 10, y: 5)
                }
                .disabled(textInput.isEmpty) // Prevent empty submissions
                .padding(.horizontal, 40)
                .padding(.bottom, 20) // Push up from keyboard
            }
        }
        .onAppear {
            isFocused = true // Auto-focus the text field
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Helper Extension for Custom Placeholder
// This extension allows for a custom View (Text with color) to be used as a placeholder
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

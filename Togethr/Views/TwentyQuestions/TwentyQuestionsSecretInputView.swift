import SwiftUI

struct TwentyQuestionsSecretInputView: View {
    
    @Binding var navPath: NavigationPath
    let category: String
    @State private var textInput: String = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.05, green: 0.0, blue: 0.15).ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                // Navigation Header (Back Button)
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
                
                VStack(spacing: 10) {
                    Text("SECRET TARGET")
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundColor(.purple)
                        .tracking(2)
                    
                    Text("Enter The Word")
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                }
                
                // Custom Input Field
                VStack(alignment: .leading, spacing: 10) {
                    Text(String(category.dropLast(1))) // "Animals" -> "Animal"
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.leading, 5)
                    
                    TextField("", text: $textInput)
                        // This uses the extension defined at the bottom of the file
                        .placeholder(when: textInput.isEmpty) {
                            Text("e.g. Dolphin").foregroundColor(.gray.opacity(0.5))
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
                }
                .padding(.horizontal, 30)
                
                Spacer()
                
                // Confirm Button
                Button(action: {
                    if !textInput.isEmpty {
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
                        RoundedRectangle(cornerRadius: 16)
                            .fill(textInput.isEmpty ? Color.gray.opacity(0.3) : Color.purple)
                    )
                    .foregroundColor(textInput.isEmpty ? .white.opacity(0.3) : .white)
                    .shadow(color: textInput.isEmpty ? .clear : .purple.opacity(0.5), radius: 10, y: 5)
                }
                .disabled(textInput.isEmpty)
                .padding(.horizontal, 40)
                .padding(.bottom, 20) // Push up from keyboard
            }
        }
        .onAppear {
            isFocused = true
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Helper Extension for Custom Placeholder
// This extension fixes the "Value of type 'TextField<Text>' has no member 'placeholder'" error
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

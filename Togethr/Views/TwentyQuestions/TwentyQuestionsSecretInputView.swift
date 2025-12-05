import SwiftUI

struct TwentyQuestionsSecretInputView: View {
    
    // MARK: - Properties
    @Binding var navPath: NavigationPath
    
    // Logic extracted to ViewModel (From Block 1)
    @StateObject private var viewModel: SecretInputViewModel
    @FocusState private var isFocused: Bool
    
    // Init to handle ViewModel creation
    init(navPath: Binding<NavigationPath>, category: String) {
        self._navPath = navPath
        self._viewModel = StateObject(wrappedValue: SecretInputViewModel(category: category))
    }
    
    var body: some View {
        ZStack {
            // Background (From Block 2)
            Color(red: 0.05, green: 0.0, blue: 0.15).ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                // MARK: Navigation Header
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
                
                // MARK: Instructions (From Block 2 Visuals)
                VStack(spacing: 10) {
                    Text("SECRET TARGET")
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundColor(.purple)
                        .tracking(2)
                    
                    Text("Enter The Word")
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                }
                
                // MARK: Custom Input Field (From Block 2 Visuals, Block 1 Logic)
                VStack(alignment: .leading, spacing: 10) {
                    // "Animals" -> "Animal" logic
                    Text(String(viewModel.category.dropLast(1)))
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.leading, 5)
                    
                    TextField("", text: $viewModel.textInput)
                        .placeholder(when: viewModel.textInput.isEmpty) {
                            // Uses ViewModel placeholder text, but Block 2 styling
                            Text(viewModel.placeholderText).foregroundColor(.gray.opacity(0.5))
                        }
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.teal)
                        .padding()
                        .background(
                            // The specific styling you wanted to keep
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
                
                // MARK: Confirm Button (From Block 2 Visuals, Block 1 Logic)
                Button(action: {
                    if viewModel.isInputValid {
                        navPath.append(GameNavigation.twentyQuestionsConfirm(
                            category: viewModel.category,
                            secretWord: viewModel.textInput
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
                            .fill(viewModel.isInputValid ? Color.purple : Color.gray.opacity(0.3))
                    )
                    .foregroundColor(viewModel.isInputValid ? .white : .white.opacity(0.3))
                    .shadow(color: viewModel.isInputValid ? .purple.opacity(0.5) : .clear, radius: 10, y: 5)
                }
                .disabled(!viewModel.isInputValid)
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
            }
        }
        .onAppear {
            isFocused = true
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Helper Extension
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

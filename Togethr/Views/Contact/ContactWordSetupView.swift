import SwiftUI

struct ContactWordSetupView: View {
    
    // MARK: - Properties
    @Binding var navPath: NavigationPath
    
    // Replaced local state with ViewModel
    @StateObject private var viewModel = ContactSetupViewModel()
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.05, green: 0.0, blue: 0.15).ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                // Header
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
                
                // Page Header
                VStack(spacing: 10) {
                    Text("DEFENDER SETUP")
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundColor(.teal)
                        .tracking(2)
                    
                    Text("Enter Secret Word")
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                }
                
                // Validation Error Message
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                        .transition(.opacity)
                }
                
                // Input Field
                TextField("", text: $viewModel.secretWord)
                    .placeholder(when: viewModel.secretWord.isEmpty) {
                        Text("e.g. ASTEROID").foregroundColor(.gray)
                    }
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.teal)
                    .multilineTextAlignment(.center)
                    .padding()
                    .focused($isFocused)
                    .submitLabel(.done)
                
                // Timer Toggle
                VStack(spacing: 15) {
                    Toggle("Enable Time Limit", isOn: $viewModel.isTimerEnabled)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .tint(.teal)
                        .padding(.horizontal, 40)
                    
                    if viewModel.isTimerEnabled {
                        VStack {
                            Text("\(viewModel.timerDurationMinutes) Minutes")
                                .font(.system(size: 24, weight: .black, design: .monospaced))
                                .foregroundColor(.teal)
                            
                            Slider(value: Binding(
                                get: { Double(viewModel.timerDurationMinutes) },
                                set: { viewModel.timerDurationMinutes = Int($0) }
                            ), in: 1...15, step: 1)
                            .accentColor(.teal)
                        }
                        .padding(.horizontal, 40)
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }
                
                Spacer()
                
                // Confirm Button
                Button(action: {
                    if viewModel.validateSettings() {
                        navPath.append(GameNavigation.contactGame(
                            secretWord: viewModel.getCleanedWord(),
                            timeLimit: viewModel.getTimeLimit()
                        ))
                    }
                }) {
                    HStack {
                        Text("LOCK IT IN")
                        Image(systemName: "lock.fill")
                    }
                    .font(.system(size: 18, weight: .heavy, design: .rounded))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(viewModel.secretWord.isEmpty ? Color.gray.opacity(0.3) : Color.purple)
                    )
                    .foregroundColor(viewModel.secretWord.isEmpty ? .white.opacity(0.3) : .white)
                    .shadow(color: viewModel.secretWord.isEmpty ? .clear : .purple.opacity(0.5), radius: 10, y: 5)
                }
                .disabled(viewModel.secretWord.isEmpty)
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
            }
        }
        .onAppear { isFocused = true }
        .toolbarBackground(.hidden, for: .navigationBar)
        .animation(.spring(), value: viewModel.isTimerEnabled)
        .navigationBarHidden(true)
    }
}

// Views/Contact/ContactWordSetupView.swift
import SwiftUI

struct ContactWordSetupView: View {
    
    // MARK: - Properties
    @Binding var navPath: NavigationPath
    
    // Logic extracted to ViewModel (Maintains 100% test coverage capability)
    @StateObject private var viewModel = ContactSetupViewModel()
    @FocusState private var isFocused: Bool // Controls keyboard focus
    
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
                    TextField("", text: $viewModel.secretWord)
                        .placeholder(when: viewModel.secretWord.isEmpty) {
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
                        // Clear error when typing (Logic handled here for UI responsiveness)
                        .onChange(of: viewModel.secretWord) { _ in viewModel.errorMessage = nil }
                    
                    // Error Message Display
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.leading, 5)
                    }
                }
                .padding(.horizontal, 30)
                
                // MARK: Timer Toggle Section
                VStack(spacing: 15) {
                    Toggle(isOn: $viewModel.isTimerEnabled) {
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
                    if viewModel.isTimerEnabled {
                        VStack(spacing: 5) {
                            HStack {
                                Text("Duration")
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("\(viewModel.timerDurationMinutes) Minutes")
                                    .fontWeight(.bold)
                                    .foregroundColor(.orange)
                            }
                            
                            Slider(value: Binding(
                                get: { Double(viewModel.timerDurationMinutes) },
                                set: { viewModel.timerDurationMinutes = Int($0) }
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
                Button(action: {
                    if viewModel.validateSettings() {
                        navPath.append(GameNavigation.contactGame(
                            secretWord: viewModel.getCleanedWord(),
                            timeLimit: viewModel.getTimeLimit()
                        ))
                    }
                }) {
                    HStack {
                        Text("LOCK & START")
                        Image(systemName: "lock.shield.fill")
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
                .buttonStyle(BouncyGameButtonStyle())
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
            }
        }
        .onAppear { isFocused = true } // Auto-focus input
        .toolbarBackground(.hidden, for: .navigationBar)
        .animation(.spring(), value: viewModel.isTimerEnabled)
        .navigationBarHidden(true)
    }
}

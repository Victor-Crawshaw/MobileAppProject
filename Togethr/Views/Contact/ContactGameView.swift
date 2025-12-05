import SwiftUI

struct ContactGameView: View {
    
    // MARK: - Properties
    @Binding var navPath: NavigationPath
    
    // Logic extracted to ViewModel (Maintains 100% test coverage capability)
    @StateObject private var viewModel: ContactGameViewModel
    
    // Timer Publisher (Drives the ViewModel tick)
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(navPath: Binding<NavigationPath>, secretWord: String, timeLimit: TimeInterval?) {
        self._navPath = navPath
        self._viewModel = StateObject(wrappedValue: ContactGameViewModel(secretWord: secretWord, timeLimit: timeLimit))
    }
    
    var body: some View {
        ZStack {
            // MARK: Background
            Color(red: 0.05, green: 0.0, blue: 0.15).ignoresSafeArea()
            
            // Background Glow (Changes color based on timer urgency)
            // Logic linked to ViewModel state
            GeometryReader { geo in
                Circle()
                    .fill(viewModel.timeLimit != nil && viewModel.timeRemaining < 30 ? Color.red.opacity(0.1) : Color.blue.opacity(0.1))
                    .frame(width: 400, height: 400)
                    .blur(radius: 80)
                    .position(x: geo.size.width / 2, y: geo.size.height * 0.3)
            }
            
            VStack(spacing: 30) {
                
                // MARK: 1. HUD Header
                HStack {
                    // Abort Button (Resets Navigation)
                    Button(action: {
                        navPath = NavigationPath() // Reset to Home
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: "xmark.circle.fill")
                            Text("ABORT GAME")
                        }
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(.red.opacity(0.8))
                        .padding(8)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    Spacer()
                    
                    // Timer Display (if enabled)
                    if viewModel.timeLimit != nil {
                        Text(viewModel.timeString)
                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                            .foregroundColor(viewModel.timeRemaining < 30 ? .red : .orange)
                            .padding(8)
                            .background(RoundedRectangle(cornerRadius: 8).stroke(viewModel.timeRemaining < 30 ? Color.red : Color.orange, lineWidth: 1))
                    }
                }
                .padding(.top, 10)
                .padding(.horizontal)
                
                Spacer()
                
                // MARK: 2. The Word Display
                VStack(spacing: 15) {
                    Text("CURRENT REVEAL")
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(.teal)
                        .tracking(3)
                    
                    // Shows the letters revealed so far (From ViewModel)
                    Text(viewModel.displayedWord)
                        .font(.system(size: 60, weight: .black, design: .monospaced))
                        .foregroundColor(.white)
                        .shadow(color: .purple, radius: 15)
                    
                    // Shows dashes for the remaining hidden letters
                    HStack(spacing: 5) {
                        ForEach(0..<(viewModel.secretWord.count - viewModel.revealedCount), id: \.self) { _ in
                            Circle()
                                .fill(Color.white.opacity(0.2))
                                .frame(width: 8, height: 8)
                        }
                    }
                }
                
                Spacer()
                
                // MARK: 3. Game Controls
                VStack(spacing: 20) {
                    
                    // REVEAL LETTER Button
                    // Used when the guessers successfully make "Contact"
                    Button(action: {
                        viewModel.revealNextLetter()
                    }) {
                        HStack {
                            Image(systemName: "eye.fill")
                            Text("REVEAL NEXT LETTER")
                        }
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .shadow(color: .blue.opacity(0.5), radius: 10)
                    }
                    .buttonStyle(BouncyGameButtonStyle())
                    
                    HStack(spacing: 15) {
                        // UNDO Button
                        // Reverts the last "Reveal" action
                        Button(action: {
                            viewModel.undoLastAction()
                        }) {
                            HStack {
                                Image(systemName: "arrow.uturn.backward")
                                Text("UNDO")
                            }
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        .disabled(viewModel.history.isEmpty) // Disable if nothing to undo
                        .opacity(viewModel.history.isEmpty ? 0.5 : 1.0)
                        
                        // GIVE UP Button
                        // Triggers a Loss for the Guessers
                        Button(action: {
                            viewModel.giveUp()
                        }) {
                            HStack {
                                Image(systemName: "flag.fill")
                                Text("GIVE UP")
                            }
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.2))
                            .foregroundColor(.red)
                            .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
            }
        }
        .navigationBarHidden(true)
        // Link Timer to ViewModel Tick
        .onReceive(timer) { _ in
            viewModel.tick()
        }
        // Observe ViewModel Game Over state to trigger navigation
        .onChange(of: viewModel.gameOver) { gameOver in
            if gameOver {
                navPath.append(GameNavigation.contactResult(
                    didGuessersWin: viewModel.didWin,
                    secretWord: viewModel.secretWord,
                    reason: viewModel.endReason
                ))
            }
        }
    }
}

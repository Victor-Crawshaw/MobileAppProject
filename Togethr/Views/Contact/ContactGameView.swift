import SwiftUI

struct ContactGameView: View {
    
    // MARK: - Properties
    @Binding var navPath: NavigationPath
    
    // Logic extracted to ViewModel
    @StateObject private var viewModel: ContactGameViewModel
    
    // Timer Publisher (View-side driver)
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(navPath: Binding<NavigationPath>, secretWord: String, timeLimit: TimeInterval?) {
        self._navPath = navPath
        self._viewModel = StateObject(wrappedValue: ContactGameViewModel(secretWord: secretWord, timeLimit: timeLimit))
    }
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.05, green: 0.0, blue: 0.15).ignoresSafeArea()
            
            // Background Glow (Changes color based on timer urgency)
            GeometryReader { geo in
                Circle()
                    .fill(viewModel.timeLimit != nil && viewModel.timeRemaining < 30 ? Color.red.opacity(0.2) : Color.blue.opacity(0.1))
                    .frame(width: 500, height: 500)
                    .blur(radius: 100)
                    .position(x: geo.size.width / 2, y: geo.size.height / 2)
            }
            
            VStack(spacing: 0) {
                
                // MARK: HUD
                HStack {
                    // Give Up Button
                    Button(action: { viewModel.giveUp() }) {
                        HStack(spacing: 5) {
                            Image(systemName: "flag.fill")
                            Text("GIVE UP")
                        }
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(.white.opacity(0.6))
                        .padding(8)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    Spacer()
                    
                    // Timer Display
                    if viewModel.timeLimit != nil {
                        HStack(spacing: 5) {
                            Image(systemName: "stopwatch.fill")
                            Text(viewModel.timeString)
                        }
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundColor(viewModel.timeRemaining < 30 ? .red : .teal)
                        .padding(8)
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(8)
                    }
                }
                .padding()
                
                Spacer()
                
                // MARK: Main Word Display
                VStack(spacing: 20) {
                    Text("CURRENT CONTACT")
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundColor(.teal)
                        .tracking(4)
                        .opacity(0.8)
                    
                    Text(viewModel.displayedWord)
                        .font(.system(size: 60, weight: .black, design: .monospaced))
                        .foregroundColor(.white)
                        .shadow(color: .white.opacity(0.5), radius: 20, x: 0, y: 0)
                        .minimumScaleFactor(0.5)
                        .padding(.horizontal)
                        .transition(.scale.combined(with: .opacity))
                    
                    Text("\(viewModel.secretWord.count) letters total")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // MARK: Controls
                VStack(spacing: 20) {
                    
                    // Reveal Button
                    Button(action: {
                        withAnimation(.spring()) {
                            viewModel.revealNextLetter()
                        }
                    }) {
                        VStack(spacing: 5) {
                            Image(systemName: "eye.fill")
                                .font(.title2)
                            Text("REVEAL NEXT LETTER")
                                .font(.system(size: 16, weight: .heavy, design: .rounded))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(
                            LinearGradient(colors: [.blue, .purple], startPoint: .leading, endPoint: .trailing)
                        )
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .shadow(color: .blue.opacity(0.4), radius: 10, y: 5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.white.opacity(0.2), lineWidth: 1)
                        )
                    }
                    
                    // Undo Button
                    if viewModel.revealedCount > 1 {
                        Button(action: {
                            withAnimation {
                                viewModel.undoLastAction()
                            }
                        }) {
                            HStack {
                                Image(systemName: "arrow.uturn.backward")
                                Text("OOPS, UNDO REVEAL")
                            }
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .foregroundColor(.white.opacity(0.5))
                            .padding()
                        }
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
        // Timer Logic
        .onReceive(timer) { _ in
            viewModel.tick()
        }
        // Navigation Logic (Reacting to ViewModel state changes)
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

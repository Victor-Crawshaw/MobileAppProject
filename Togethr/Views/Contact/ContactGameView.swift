// Views/Contact/ContactGameView.swift
import SwiftUI

struct ContactGameView: View {
    
    @Binding var navPath: NavigationPath
    let secretWord: String
    let timeLimit: TimeInterval? // New Parameter
    
    // --- Game State ---
    @State private var revealedCount: Int = 1
    @State private var history: [Int] = []
    
    // Timer State
    @State private var timeRemaining: TimeInterval = 0
    @State private var timerRunning = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var displayedWord: String {
        String(secretWord.prefix(revealedCount))
    }
    
    var timeString: String {
        let minutes = Int(timeRemaining) / 60
        let seconds = Int(timeRemaining) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.05, green: 0.0, blue: 0.15).ignoresSafeArea()
            
            // Background Glow
            GeometryReader { geo in
                Circle()
                    .fill(timeLimit != nil && timeRemaining < 30 ? Color.red.opacity(0.1) : Color.blue.opacity(0.1))
                    .frame(width: 400, height: 400)
                    .blur(radius: 80)
                    .position(x: geo.size.width / 2, y: geo.size.height * 0.4)
                    .animation(.easeInOut, value: timeRemaining)
            }
            
            VStack(spacing: 0) {
                
                // HUD Header
                HStack {
                    Button(action: { navPath = NavigationPath() }) {
                        HStack(spacing: 5) {
                            Image(systemName: "xmark.circle.fill")
                            Text("ABORT")
                        }
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(.red.opacity(0.8))
                        .padding(8)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    Spacer()
                    
                    // Timer Display
                    if timeLimit != nil {
                        HStack(spacing: 5) {
                            Image(systemName: "clock.fill")
                            Text(timeString)
                                .font(.system(size: 16, weight: .black, design: .monospaced))
                                .monospacedDigit()
                        }
                        .foregroundColor(timeRemaining < 60 ? .red : .teal)
                        .padding(8)
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(timeRemaining < 60 ? Color.red.opacity(0.5) : Color.teal.opacity(0.5), lineWidth: 1)
                        )
                    } else {
                        Text("ZEN MODE")
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundColor(.teal.opacity(0.5))
                    }
                }
                .padding()
                
                Spacer()
                
                // Main Content
                VStack(spacing: 40) {
                    
                    VStack(spacing: 10) {
                        Text("CURRENT REVEAL")
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .foregroundColor(.purple)
                            .tracking(2)
                        
                        // The Word Display
                        HStack(spacing: 0) {
                            Text(displayedWord)
                                .foregroundColor(.white)
                            Text(String(repeating: "_", count: max(0, secretWord.count - revealedCount)))
                                .foregroundColor(.white.opacity(0.3))
                        }
                        .font(.system(size: 60, weight: .black, design: .monospaced))
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .padding(.horizontal)
                        .shadow(color: .purple.opacity(0.5), radius: 10)
                        
                        Text("\(secretWord.count) LETTERS TOTAL")
                            .font(.caption)
                            .fontDesign(.monospaced)
                            .foregroundColor(.gray)
                    }
                    
                    // Controls
                    VStack(spacing: 15) {
                        Button(action: revealNextLetter) {
                            Text("REVEAL NEXT LETTER")
                                .font(.system(size: 18, weight: .heavy, design: .rounded))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 18)
                                .background(Color.teal)
                                .foregroundColor(.black)
                                .cornerRadius(16)
                                .shadow(color: .teal.opacity(0.5), radius: 10)
                        }
                        .buttonStyle(BouncyGameButtonStyle())
                        .disabled(revealedCount >= secretWord.count)
                        
                        HStack(spacing: 15) {
                            // Undo Button
                            Button(action: undoLastAction) {
                                HStack {
                                    Image(systemName: "arrow.uturn.backward")
                                    Text("UNDO")
                                }
                                .font(.system(size: 14, weight: .bold, design: .monospaced))
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(12)
                            }
                            .buttonStyle(BouncyGameButtonStyle())
                            .disabled(history.isEmpty)
                            
                            // Give Up Button (Only if No Timer)
                            if timeLimit == nil {
                                Button(action: giveUp) {
                                    HStack {
                                        Image(systemName: "flag.fill")
                                        Text("GIVE UP")
                                    }
                                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                                    .foregroundColor(.red)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.red.opacity(0.1))
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.red.opacity(0.3), lineWidth: 1)
                                    )
                                }
                                .buttonStyle(BouncyGameButtonStyle())
                            }
                        }
                    }
                    .padding(.horizontal, 40)
                }
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            if let limit = timeLimit {
                timeRemaining = limit
                timerRunning = true
            }
        }
        .onReceive(timer) { _ in
            guard timerRunning, timeLimit != nil else { return }
            
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timerRunning = false
                navigateToResult(didWin: false, reason: "Time Ran Out!")
            }
        }
    }
    
    // --- Logic ---
    
    func revealNextLetter() {
        history.append(revealedCount)
        if revealedCount < secretWord.count {
            revealedCount += 1
        }
        if revealedCount == secretWord.count {
            timerRunning = false
            navigateToResult(didWin: true, reason: "The word was fully revealed!")
        }
    }

    func undoLastAction() {
        guard let lastCount = history.popLast() else { return }
        self.revealedCount = lastCount
    }
    
    func giveUp() {
        navigateToResult(didWin: false, reason: "The Guessers Surrendered.")
    }
    
    func navigateToResult(didWin: Bool, reason: String) {
        navPath.append(GameNavigation.contactResult(
            didGuessersWin: didWin,
            secretWord: secretWord,
            reason: reason
        ))
    }
}

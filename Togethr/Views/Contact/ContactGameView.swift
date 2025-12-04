// Views/Contact/ContactGameView.swift
import SwiftUI

struct ContactGameView: View {
    
    @Binding var navPath: NavigationPath
    let secretWord: String
    let timeLimit: TimeInterval?
    
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
                    .position(x: geo.size.width / 2, y: geo.size.height * 0.3)
            }
            
            VStack(spacing: 30) {
                
                // MARK: 1. HUD (Added Abort Button)
                HStack {
                    // Abort Button
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
                    
                    if timeLimit != nil {
                        Text(timeString)
                            .font(.system(size: 20, weight: .bold, design: .monospaced))
                            .foregroundColor(timeRemaining < 30 ? .red : .white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.black.opacity(0.3))
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                Spacer()
                
                // MARK: 2. Word Display
                VStack(spacing: 10) {
                    Text("CURRENT STATUS")
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundColor(.gray)
                        .tracking(2)
                    
                    HStack(spacing: 2) {
                        // Revealed part
                        Text(displayedWord)
                            .foregroundColor(.white)
                        // Hidden part
                        Text(String(repeating: "_", count: secretWord.count - revealedCount))
                            .foregroundColor(.white.opacity(0.2))
                    }
                    .font(.system(size: 50, weight: .black, design: .monospaced))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                }
                
                Spacer()
                
                // MARK: 3. Controls
                VStack(spacing: 15) {
                    
                    HStack(spacing: 15) {
                        // Undo Button
                        if !history.isEmpty {
                            Button(action: undoLastAction) {
                                Image(systemName: "arrow.uturn.backward")
                                    .font(.title2)
                                    .frame(width: 60, height: 60)
                                    .background(Color.white.opacity(0.1))
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                            }
                        }
                        
                        // Reveal Button
                        Button(action: revealNextLetter) {
                            Text("REVEAL NEXT LETTER")
                                .font(.system(size: 16, weight: .heavy, design: .rounded))
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .background(Color.teal)
                                .foregroundColor(.white)
                                .cornerRadius(16)
                                .shadow(color: .teal.opacity(0.4), radius: 8)
                        }
                    }
                    
                    // Give Up / Defenders Win
                    Button(action: giveUp) {
                        Text("GUESSERS SURRENDER")
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .foregroundColor(.red)
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.red.opacity(0.3), lineWidth: 1))
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 20)
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

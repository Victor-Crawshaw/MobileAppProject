// Views/Hangman/HangmanStartView.swift
import SwiftUI

struct HangmanStartView: View {
    
    @Binding var navPath: NavigationPath
    @State private var showingHowToPlay = false

    var body: some View {
        ZStack {
            // MARK: 1. Deep Space Background
            Color(red: 0.05, green: 0.0, blue: 0.15).ignoresSafeArea()
            
            // Ambient Orbs
            GeometryReader { geo in
                Circle().fill(Color.orange.opacity(0.15)).frame(width: 300).blur(radius: 60).offset(x: -50, y: -50)
                Circle().fill(Color.red.opacity(0.15)).frame(width: 300).blur(radius: 60).offset(x: geo.size.width - 150, y: geo.size.height / 2)
            }
            
            VStack(spacing: 40) {
                Spacer()
                
                // MARK: 2. Hero Title
                VStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(colors: [.red.opacity(0.2), .clear], startPoint: .top, endPoint: .bottom))
                            .frame(width: 180, height: 180)
                            .blur(radius: 10)
                        
                        Image(systemName: "figure.fall") // Or "scope"
                            .font(.system(size: 80))
                            .foregroundStyle(LinearGradient(colors: [.orange, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .shadow(color: .red.opacity(0.5), radius: 10)
                    }
                    
                    Text("HANGMAN")
                        .font(.system(size: 56, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(color: .orange.opacity(0.5), radius: 10, x: 0, y: 5)
                        .tracking(2)
                    
                    Text("Tactical Word Guessing")
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .foregroundColor(.gray)
                        .tracking(1)
                }
                
                Spacer()
                
                // MARK: 3. Actions
                VStack(spacing: 20) {
                    // Start Button
                    Button(action: {
                        navPath.append(GameNavigation.hangmanWordSetup)
                    }) {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("INITIALIZE GAME")
                        }
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(LinearGradient(colors: [.orange, .red], startPoint: .leading, endPoint: .trailing))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.white.opacity(0.3), lineWidth: 1)
                        )
                        .foregroundColor(.white)
                        .shadow(color: .red.opacity(0.5), radius: 10, y: 5)
                    }
                    .buttonStyle(BouncyGameButtonStyle())
                    
                    // How to Play
                    Button(action: {
                        showingHowToPlay = true
                    }) {
                        Text("HOW TO PLAY")
                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.05))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .buttonStyle(BouncyGameButtonStyle())
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingHowToPlay) {
            HangmanHowToPlayView()
                .preferredColorScheme(.dark)
        }
    }
}

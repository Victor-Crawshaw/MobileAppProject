// Views/Contact/ContactResultView.swift
import SwiftUI

struct ContactResultView: View {
    
    @Binding var navPath: NavigationPath
    
    let didGuessersWin: Bool // In Contact, if word is revealed, guessers usually "Win" the contact chain, but if they guess the word, they win.
    let secretWord: String
    let reason: String
    
    var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.0, blue: 0.15).ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                // Icon
                Image(systemName: didGuessersWin ? "flag.checkered" : "xmark.shield.fill")
                    .font(.system(size: 100))
                    .foregroundColor(didGuessersWin ? .yellow : .red)
                    .shadow(color: didGuessersWin ? .orange : .red.opacity(0.5), radius: 20)
                
                VStack(spacing: 5) {
                    Text(didGuessersWin ? "GAME OVER" : "DEFENDED")
                        .font(.system(size: 40, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(reason)
                        .font(.system(.body, design: .monospaced))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                }
                
                VStack(spacing: 10) {
                    Text("SECRET WORD")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.teal)
                        .tracking(2)
                    
                    Text(secretWord)
                        .font(.system(size: 32, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 10)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)
                }
                
                Spacer()
                
                Button(action: {
                    navPath = NavigationPath() // Reset to root
                }) {
                    Text("RETURN TO MENU")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(color: .blue.opacity(0.4), radius: 10)
                }
                .buttonStyle(BouncyGameButtonStyle())
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
    }
}

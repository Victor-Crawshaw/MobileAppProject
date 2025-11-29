// Views/Hangman/HangmanConfirmationView.swift
import SwiftUI

struct HangmanConfirmationView: View {
    
    @Binding var navPath: NavigationPath
    let secretWord: String
    
    var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.0, blue: 0.15).ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Animated pulsing icon
                Image(systemName: "iphone.gen3")
                    .font(.system(size: 100))
                    .foregroundColor(.white)
                    .symbolEffect(.bounce, options: .repeating)
                    .shadow(color: .orange, radius: 20)

                VStack(spacing: 15) {
                    Text("HAND OFF DEVICE")
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .foregroundColor(.orange)
                        .tracking(3)
                    
                    Text("Pass to the\nGuesser")
                        .font(.system(size: 36, weight: .black, design: .rounded))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: {
                    navPath.append(GameNavigation.hangmanGame(secretWord: secretWord))
                }) {
                    Text("I AM READY")
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(LinearGradient(colors: [.orange, .red], startPoint: .leading, endPoint: .trailing))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.white.opacity(0.3), lineWidth: 1)
                        )
                        .foregroundColor(.white)
                        .shadow(color: .orange.opacity(0.5), radius: 10, y: 5)
                }
                .buttonStyle(BouncyGameButtonStyle())
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
        .navigationBarHidden(true)
    }
}

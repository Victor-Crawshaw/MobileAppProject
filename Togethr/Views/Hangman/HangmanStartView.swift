// Views/Hangman/HangmanStartView.swift
import SwiftUI

struct HangmanStartView: View {
    
    @Binding var navPath: NavigationPath
    @State private var showingHowToPlay = false

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.orange.opacity(0.7),
                    Color.red.opacity(0.7)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Spacer()
                
                Text("🎯")
                    .font(.system(size: 120, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 5, y: 5)
                    .padding(.bottom, 10)
                
                Text("Hangman")
                    .font(.custom("ChalkboardSE-Bold", size: 48))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.4), radius: 5, y: 5)
                
                Spacer()
                
                Button(action: {
                    navPath.append(GameNavigation.hangmanWordSetup)
                }) {
                    Text("Start Game")
                        .font(.title2)
                        .fontWeight(.heavy)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            Capsule()
                                .fill(Color.green.gradient)
                                .shadow(color: .black.opacity(0.3), radius: 5, y: 5)
                        )
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 30)
                
                Button(action: {
                    showingHowToPlay = true
                }) {
                    Text("How to Play")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            Capsule()
                                .stroke(Color.white.opacity(0.7), lineWidth: 2)
                                .fill(Color.white.opacity(0.2))
                        )
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 30)
                
                Spacer()
            }
            .padding(.vertical, 40)
        }
        .sheet(isPresented: $showingHowToPlay) {
            HangmanHowToPlayView()
        }
        .navigationTitle("Hangman")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
    }
}

struct HangmanStartView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HangmanStartView(navPath: .constant(NavigationPath()))
        }
    }
}

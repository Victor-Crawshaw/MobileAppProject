import SwiftUI

struct ResultView: View {
    
    // MARK: - Properties
    @Binding var navPath: NavigationPath
    
    let didWin: Bool
    let questionLog: [RecordedQuestion]
    let category: String
    let secretWord: String
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.05, green: 0.0, blue: 0.15).ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                // MARK: Victory/Defeat Icon
                Image(systemName: didWin ? "trophy.fill" : "xmark.octagon.fill")
                    .font(.system(size: 100))
                    .foregroundColor(didWin ? .yellow : .red)
                    .shadow(color: didWin ? .orange : .red.opacity(0.5), radius: 20)
                
                // Main Text Logic
                VStack(spacing: 5) {
                    Text(didWin ? "VICTORY" : "GAME OVER")
                        .font(.system(size: 48, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(didWin ? "The Guessers Won!" : "The Secret Remains Safe")
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.gray)
                }
                
                // MARK: Reveal Secret
                VStack(spacing: 10) {
                    Text("SECRET WORD")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.teal)
                        .tracking(2)
                    
                    Text(secretWord)
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 10)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)
                }
                
                Spacer()
                
                // MARK: Navigation Footer
                VStack(spacing: 15) {
                    Button(action: {
                        // Reset to root (empty path)
                        navPath = NavigationPath()
                    }) {
                        Text("BACK TO MENU")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
    }
}

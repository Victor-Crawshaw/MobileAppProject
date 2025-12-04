import SwiftUI

struct ConfirmationView: View {
    
    // MARK: - Properties
    @Binding var navPath: NavigationPath
    let category: String
    let secretWord: String
    
    var body: some View {
        ZStack {
            // Dark Background
            Color(red: 0.05, green: 0.0, blue: 0.15).ignoresSafeArea()
            
            VStack(spacing: 40) {
                
                // MARK: Navigation Header
                // Contains a custom "Back" button to return to the input screen
                HStack {
                    Button(action: {
                        // Go back to Input View safely
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
                
                Spacer()
                
                // MARK: Visual Prompt
                // Animated pulsing icon indicating device handover
                Image(systemName: "iphone.gen3")
                    .font(.system(size: 100))
                    .foregroundColor(.white)
                    .symbolEffect(.bounce, options: .repeating) // iOS 17+ Symbol Effect
                    .shadow(color: .teal, radius: 20)

                // Instructional Text
                VStack(spacing: 15) {
                    Text("HAND OFF DEVICE")
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .foregroundColor(.teal)
                        .tracking(3)
                    
                    Text("Pass to the\nFirst Guesser")
                        .font(.system(size: 36, weight: .black, design: .rounded))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                
                Spacer()
                
                // MARK: Start Game Button
                // This action officially pushes the GameView onto the stack
                Button(action: {
                    navPath.append(GameNavigation.twentyQuestionsGame(
                        category: category,
                        secretWord: secretWord
                    ))
                }) {
                    Text("I AM READY")
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(LinearGradient(colors: [.green, .teal], startPoint: .leading, endPoint: .trailing))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.white.opacity(0.3), lineWidth: 1)
                        )
                        .foregroundColor(.white)
                        .shadow(color: .green.opacity(0.5), radius: 10, y: 5)
                }
                .buttonStyle(BouncyScaleButtonStyle()) // Custom style for press animation
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
        .navigationBarHidden(true)
    }
}

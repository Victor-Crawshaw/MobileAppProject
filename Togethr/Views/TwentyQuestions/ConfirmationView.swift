import SwiftUI

struct ConfirmationView: View {
    
    @Binding var navPath: NavigationPath
    let category: String
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
                    .shadow(color: .teal, radius: 20)

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
                .buttonStyle(BouncyScaleButtonStyle())
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
        .navigationBarHidden(true)
    }
}

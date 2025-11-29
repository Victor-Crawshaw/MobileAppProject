import SwiftUI

struct TelestrationsPassView: View {
    
    @Binding var navPath: NavigationPath
    let context: TelepathyContext
    
    var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.0, blue: 0.15).ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Animated pulsing icon
                Image(systemName: "hand.wave.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.white)
                    .symbolEffect(.bounce, options: .repeating)
                    .shadow(color: .teal, radius: 20)

                VStack(spacing: 15) {
                    Text("HAND OFF DEVICE")
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .foregroundColor(.teal)
                        .tracking(3)
                    
                    Text("Pass to\nPlayer \(context.nextPlayerNumber)")
                        .font(.system(size: 36, weight: .black, design: .rounded))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: {
                    // Go to next turn
                    navPath.append(GameNavigation.telestrationsTurn(context: context))
                }) {
                    Text("I AM PLAYER \(context.nextPlayerNumber)")
                        .font(.system(size: 20, weight: .heavy, design: .rounded))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(LinearGradient(colors: [.teal, .purple], startPoint: .leading, endPoint: .trailing))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.white.opacity(0.3), lineWidth: 1)
                        )
                        .foregroundColor(.white)
                        .shadow(color: .purple.opacity(0.5), radius: 10, y: 5)
                }
                .buttonStyle(BouncyGameButtonStyle())
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
        .navigationBarHidden(true)
    }
}
import SwiftUI

struct TwentyQuestionsStartView: View {
    
    @Binding var navPath: NavigationPath
    @State private var showingHowToPlay = false
    
    // Add dismiss environment to handle "Back" to a previous Home Page/Root
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            // MARK: 1. Gamey Background
            Color(red: 0.05, green: 0.0, blue: 0.15).ignoresSafeArea()
            
            // Ambient Orbs (Blurred circles for atmosphere)
            GeometryReader { geo in
                Circle().fill(Color.teal.opacity(0.2)).frame(width: 300).blur(radius: 60).offset(x: -100, y: -100)
                Circle().fill(Color.purple.opacity(0.2)).frame(width: 300).blur(radius: 60).offset(x: geo.size.width - 150, y: geo.size.height / 2)
            }
            
            VStack(spacing: 30) {
                
                // MARK: 2. Navigation Header (Added Back Button)
                HStack {
                    Button(action: {
                        dismiss()
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
                
                // MARK: 3. Hero Logo
                // Composed of stacked text and gradients
                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [.purple.opacity(0.3), .clear], startPoint: .top, endPoint: .bottom))
                        .frame(width: 220, height: 220)
                        .blur(radius: 10)
                    
                    Text("20")
                        .font(.system(size: 140, weight: .black, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(colors: [.yellow, .orange], startPoint: .top, endPoint: .bottom)
                        )
                        .shadow(color: .orange.opacity(0.6), radius: 15, x: 0, y: 0)
                        .offset(y: -10)
                    
                    Text("QUESTIONS")
                        .font(.system(size: 32, weight: .heavy, design: .monospaced))
                        .tracking(4)
                        .foregroundColor(.white)
                        .shadow(color: .purple, radius: 10)
                        .offset(y: 80)
                }
                .padding(.bottom, 40)
                
                Spacer()
                
                // MARK: 4. Action Buttons
                VStack(spacing: 20) {
                    // Start Game -> Navigates to Category Select
                    Button(action: {
                        navPath.append(GameNavigation.twentyQuestionsCategory)
                    }) {
                        Text("START GAME")
                            .font(.system(size: 20, weight: .heavy, design: .rounded))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(LinearGradient(colors: [.teal, .blue], startPoint: .leading, endPoint: .trailing))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.white.opacity(0.3), lineWidth: 1)
                            )
                            .foregroundColor(.white)
                            .shadow(color: .teal.opacity(0.5), radius: 10, x: 0, y: 5)
                    }
                    .buttonStyle(BouncyScaleButtonStyle())
                    
                    // How To Play -> Opens Sheet
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
                                    .stroke(Color.white.opacity(0.2), lineWidth: 2)
                            )
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .buttonStyle(BouncyScaleButtonStyle())
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
        .sheet(isPresented: $showingHowToPlay) {
            HowToPlayView()
                .presentationDetents([.medium, .large])
                .preferredColorScheme(.dark)
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Helper Style
// Provides a spring animation when buttons are pressed
struct BouncyScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

struct TwentyQuestionsStartView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TwentyQuestionsStartView(navPath: .constant(NavigationPath()))
        }
    }
}

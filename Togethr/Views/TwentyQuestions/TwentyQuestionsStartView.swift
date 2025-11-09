// Views/TwentyQuestions/TwentyQuestionsStartView.swift
import SwiftUI

struct TwentyQuestionsStartView: View {
    
    @Binding var navPath: NavigationPath
    @State private var showingHowToPlay = false

    var body: some View {
        ZStack {
            // NEW: Updated background gradient (blue/teal)
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.7),
                    Color.cyan.opacity(0.7)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Spacer()
                
                // NEW: Number-based logo instead of emoji
                Text("🤔")
                    .font(.system(size: 120, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 5, y: 5)
                    .padding(.bottom, 10)
                
                Text("20 Questions")
                    .font(.custom("ChalkboardSE-Bold", size: 48))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.4), radius: 5, y: 5)
                
                Spacer()
                
                // MODIFIED: "Start Game" button is now green
                Button(action: {
                    navPath.append(GameNavigation.twentyQuestionsCategory)
                }) {
                    Text("Start Game")
                        .font(.title2)
                        .fontWeight(.heavy)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            Capsule()
                                // Use a green gradient
                                .fill(Color.green.gradient)
                                .shadow(color: .black.opacity(0.3), radius: 5, y: 5)
                        )
                        // Text color changed to white for contrast
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 30)
                
                // "How to Play" button (unchanged, still looks good)
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
            HowToPlayView() // Make sure you have this view defined
        }
        .navigationTitle("20 Questions")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
    }
}

struct TwentyQuestionsStartView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TwentyQuestionsStartView(navPath: .constant(NavigationPath()))
        }
    }
}

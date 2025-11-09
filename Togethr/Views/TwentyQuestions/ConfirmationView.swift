// Views/TwentyQuestions/ConfirmationView.swift
import SwiftUI

struct ConfirmationView: View {
    
    @Binding var navPath: NavigationPath
    let category: String
    let secretWord: String
    
    var body: some View {
        ZStack {
            // 1. Consistent Background
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
                
                // 2. Fun "pass the phone" emoji
                Text("📲")
                    .font(.system(size: 100))

                // 3. Styled instruction text
                Text("Knower, pass the phone to the first Guesser.")
                    .font(.custom("ChalkboardSE-Bold", size: 36))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.4), radius: 5, y: 5)
                    .padding(.horizontal, 20)
                
                Spacer()
                
                // 4. "I'm Ready" button styled like "Start Game"
                Button(action: {
                    navPath.append(GameNavigation.twentyQuestionsGame(
                        category: category,
                        secretWord: secretWord
                    ))
                }) {
                    Text("I'm Ready to Guess")
                        .font(.title2)
                        .fontWeight(.heavy)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            Capsule()
                                .fill(Color.green.gradient) // Green "Go" button
                                .shadow(color: .black.opacity(0.3), radius: 5, y: 5)
                        )
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 30) // Match horizontal padding
                
                Spacer()
            }
            .padding()
        }
        .navigationBarBackButtonHidden(false)
        .navigationTitle("Pass the Phone") // Adds context
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack { // Wrap in NavigationStack to see title
            ConfirmationView(
                navPath: .constant(NavigationPath()),
                category: "Animals",
                secretWord: "Lion"
            )
        }
    }
}

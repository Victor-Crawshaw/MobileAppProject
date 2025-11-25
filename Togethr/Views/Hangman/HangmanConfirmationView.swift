// Views/Hangman/HangmanConfirmationView.swift
import SwiftUI

struct HangmanConfirmationView: View {
    
    @Binding var navPath: NavigationPath
    let secretWord: String
    
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
                
                Text("📲")
                    .font(.system(size: 100))

                Text("Chooser, pass the phone to the Guesser.")
                    .font(.custom("ChalkboardSE-Bold", size: 36))
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.4), radius: 5, y: 5)
                    .padding(.horizontal, 20)
                
                Spacer()
                
                Button(action: {
                    navPath.append(GameNavigation.hangmanGame(secretWord: secretWord))
                }) {
                    Text("I'm Ready to Guess")
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
                
                Spacer()
            }
            .padding()
        }
        .navigationBarBackButtonHidden(false)
        .navigationTitle("Pass the Phone")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct HangmanConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HangmanConfirmationView(
                navPath: .constant(NavigationPath()),
                secretWord: "ELEPHANT"
            )
        }
    }
}

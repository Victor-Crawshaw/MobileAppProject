import SwiftUI

// This is the placeholder start screen for your "Contact" game
struct ContactStartView: View {
    var body: some View {
        VStack(spacing: 25) {
            Text("Contact")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer()

            // Main "Start Game" button
            Button(action: {
                // This would navigate to the Contact player setup
                // e.g., navPath.append(GameNavigation.contactPlayerSetup)
            }) {
                Text("Start Game")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green) // Different color
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            
            // "How to Play" button
            Button(action: {
                // Show a modal or sheet with rules
            }) {
                Text("How to Play")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.secondary.opacity(0.2))
                    .foregroundColor(.primary)
                    .cornerRadius(12)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Contact")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ContactStartView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContactStartView()
        }
    }
}


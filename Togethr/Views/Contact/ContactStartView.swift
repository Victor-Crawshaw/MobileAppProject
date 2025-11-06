import SwiftUI

// This is the start screen for your "Contact" game
struct ContactStartView: View {
    
    // 1. Add navPath binding
    @Binding var navPath: NavigationPath
    
    var body: some View {
        VStack(spacing: 25) {
            Text("Contact")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer()

            // 2. Main "Start Game" button now navigates
            Button(action: {
                // Navigate to the Contact player setup
                navPath.append(GameNavigation.contactPlayerSetup)
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
                // TODO: Show a modal or sheet with rules
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
            // Update preview to pass a constant path
            ContactStartView(navPath: .constant(NavigationPath()))
        }
    }
}
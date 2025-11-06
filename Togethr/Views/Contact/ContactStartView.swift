// Views/Contact/ContactStartView.swift
import SwiftUI

// This is the start screen for your "Contact" game
struct ContactStartView: View {
    
    @Binding var navPath: NavigationPath
    
    // State to control the "How to Play" modal
    @State private var showingHowToPlay = false
    
    var body: some View {
        VStack(spacing: 25) {
            Text("Contact")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer()

            // Main "Start Game" button
            Button(action: {
                // Navigate to the word setup screen
                navPath.append(GameNavigation.contactWordSetup)
            }) {
                Text("Start Game")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            
            // "How to Play" button
            Button(action: {
                showingHowToPlay = true
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
        // Add the sheet modifier to present the rules
        .sheet(isPresented: $showingHowToPlay) {
            ContactHowToPlayView()
        }
    }
}

struct ContactStartView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContactStartView(navPath: .constant(NavigationPath()))
        }
    }
}
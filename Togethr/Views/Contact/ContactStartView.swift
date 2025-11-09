// Views/Contact/ContactStartView.swift
import SwiftUI

// This is the start screen for your "Contact" game
struct ContactStartView: View {
    
    @Binding var navPath: NavigationPath
    
    // State to control the "How to Play" modal
    @State private var showingHowToPlay = false
    
    var body: some View {
        // NEW: ZStack to hold the gradient background
        ZStack {
            // NEW: Consistent background gradient from 20 Questions
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.7),
                    Color.cyan.opacity(0.7)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 25) {
                Spacer()
                
                // NEW: Emoji logo
                Text("🔤")
                    .font(.system(size: 120, weight: .bold, design: .rounded))
                    .shadow(color: .black.opacity(0.3), radius: 5, y: 5)
                    .padding(.bottom, 10)

                // MODIFIED: Styled title to match 20 Questions
                Text("Contact")
                    .font(.custom("ChalkboardSE-Bold", size: 48))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.4), radius: 5, y: 5)
                
                Spacer()

                // MODIFIED: Main "Start Game" button (Green Capsule)
                Button(action: {
                    // Navigate to the word setup screen
                    navPath.append(GameNavigation.contactWordSetup)
                }) {
                    Text("Start Game")
                        .font(.title2)
                        .fontWeight(.heavy) // Make text bolder
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18) // Taller button
                        .background(
                            Capsule()
                                .fill(Color.green.gradient) // Green "Go" button
                                .shadow(color: .black.opacity(0.3), radius: 5, y: 5)
                        )
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 30) // Match 20Q padding
                
                // MODIFIED: "How to Play" button (Stroked Capsule)
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
                .padding(.horizontal, 30) // Match 20Q padding
                
                Spacer()
            }
            .padding()
        }
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
        NavigationStack { // MODIFIED: Use NavigationStack for preview
            ContactStartView(navPath: .constant(NavigationPath()))
        }
    }
}

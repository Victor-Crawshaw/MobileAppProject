// Views/TwentyQuestions/TwentyQuestionsStartView.swift
import SwiftUI

struct TwentyQuestionsStartView: View {
    
    @Binding var navPath: NavigationPath
    @State private var showingHowToPlay = false
    
    // 1. ADD THIS: Needed to go back
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 25) {
            Text("🤔")
                .font(.system(size: 80))
            
            Text("20 Questions")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer()

            // Main "Start Game" button
            Button(action: {
                // This now navigates to Category Selection
                navPath.append(GameNavigation.twentyQuestionsCategory)
            }) {
                Text("Start Game")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
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
        .sheet(isPresented: $showingHowToPlay) {
            HowToPlayView()
        }
        // 2. ADD THIS: This adds the custom "Back" button
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss() // This goes back
                }) {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
            }
        }
        // 3. CHANGE THIS: Add a title to force the nav bar to appear
        .navigationTitle("20 Questions")
        .navigationBarTitleDisplayMode(.inline)
        
        // 4. CHANGE THIS: This hides the *default* back button, letting us use our custom one
        .navigationBarBackButtonHidden(true)
    }
}

struct TwentyQuestionsStartView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TwentyQuestionsStartView(navPath: .constant(NavigationPath()))
        }
    }
}

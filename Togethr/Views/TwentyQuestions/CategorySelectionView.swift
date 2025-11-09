// Views/TwentyQuestions/CategorySelectionView.swift
import SwiftUI

struct CategorySelectionView: View {
    
    @Binding var navPath: NavigationPath
    
    // NEW: List of categories with emojis for fun
    let categories = [
        "Animals 🦁",
        "Food 🍕",
        "Famous People 👩‍🎤",
        "Movies & TV 🎬",
    ]

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
            
            VStack(spacing: 20) {
                // 2. Consistent Title Style
                Text("Choose a Category")
                    .font(.custom("ChalkboardSE-Bold", size: 36))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.4), radius: 5, y: 5)
                    .padding(.top, 20)
                    .padding(.bottom, 10)

                // 3. Scrollable list of categories
                ScrollView {
                    VStack(spacing: 15) {
                        ForEach(categories, id: \.self) { category in
                            
                            // 4. Consistent Button Style
                            Button(action: {
                                // Navigate to the *next* step with the chosen category
                                navPath.append(GameNavigation.twentyQuestionsSecretInput(category: category))
                            }) {
                                Text(category)
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(
                                        Capsule() // Use same style as "How to Play"
                                            .stroke(Color.white.opacity(0.7), lineWidth: 2)
                                            .fill(Color.white.opacity(0.2))
                                    )
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.horizontal, 30) // Match horizontal padding
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Select Category")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CategorySelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CategorySelectionView(navPath: .constant(NavigationPath()))
        }
    }
}
